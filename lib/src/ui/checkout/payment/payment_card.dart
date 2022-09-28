import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_paystack/src/widgets/base_widget.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../functions.dart';
import 'card_input.dart';

const kFullTabHeight = 74.0;

class CheckoutWidget extends StatefulWidget {
  final Charge charge;
  final bool fullscreen;
  final Widget logo;
  final String total;

  CheckoutWidget({
    required this.charge,
    required this.fullscreen,
    required this.logo,
    required this.total
  });

  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends BaseState<CheckoutWidget>
    with TickerProviderStateMixin {
  static const tabBorderRadius = BorderRadius.all(Radius.circular(4.0));

  @override
  void initState() {
    super.initState();
    if (widget.charge.card == null) {
      widget.charge.card = PaymentCard.empty();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildChild(BuildContext context) {
    var securedWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsetsDirectional.only(start: 3),
              child: Text(
                "Card Payment",
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'lib/assets/images/payment_card.png',
              width: 120,
            ),
          ],
        )
      ],
    );
    return Container(
      child: new CustomAlertDialog(
        expanded: true,
        fullscreen: widget.fullscreen,
        titlePadding: EdgeInsets.all(0.0),
        onCancelPress: onCancelPress,
        title: _buildTitle(),
        content: new Container(
          child: new SingleChildScrollView(
            child: new Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Column(
                  children: <Widget>[
                    new Text(
                      'Enter your card details to pay',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    new SizedBox(
                      height: 20.0,
                    ),
                    CardInput(
                      text: 'PAY ' + parseHtmlString(widget.total),
                      card: widget.charge.card!,
                      onValidated: _onCardValidated,
                    ),
                    SizedBox(height: 20),
                    securedWidget
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    var emailAndAmount = new Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        widget.charge.email != null
            ? new Text(
          widget.charge.email!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey, fontSize: 12.0),
        )
            : new Container(),
        widget.charge.amount.isNegative
            ? new Container()
            : new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Pay',
              style:
              const TextStyle(fontSize: 14.0),
            ),
            new SizedBox(
              width: 5.0,
            ),
            new Flexible(
                child: new Text(parseHtmlString(widget.total),
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        fontWeight: FontWeight.w500)))
          ],
        )
      ],
    );
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.all(10.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/assets/images/stripe_logo_slate_sm.png',
                width: 80,
              ),
              new SizedBox(
                width: 50,
              ),
              new Expanded(child: emailAndAmount),
            ],
          ),
        ),
      ],
    );
  }

  void _onCardValidated(PaymentCard paymentCard) {
    Navigator.of(context).pop(paymentCard);
  }

}

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.titlePadding,
    required this.onCancelPress,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 10.0),
    this.expanded = false,
    this.fullscreen = false,
    required this.content,
  })  : assert(content != null),
        super(key: key);

  final Widget title;
  final EdgeInsetsGeometry titlePadding;
  final Widget content;
  final EdgeInsetsGeometry contentPadding;
  final VoidCallback onCancelPress;
  final bool expanded;
  final bool fullscreen;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    if (title != null && titlePadding != null) {
      children.add(new Padding(
        padding: titlePadding,
        child: new DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyText1!,
          child: new Semantics(child: title, namesRoute: true),
        ),
      ));
    }

    children.add(new Flexible(
      child: new Padding(
        padding: contentPadding,
        child: new DefaultTextStyle(
          style: Theme.of(context).textTheme.subtitle1!,
          child: content,
        ),
      ),
    ));

    return buildContent(children);
  }

  Widget buildContent(List<Widget> children) {
    Widget widget;
    if (fullscreen) {
      widget = new Material(
        //color: Colors.white,
        child: new Container(
            child: onCancelPress == null
                ? new Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children),
            )
                : new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Align(
                  alignment: Alignment.topRight,
                  child: new IconButton(
                    icon: new Icon(Icons.close),
                    onPressed: onCancelPress,
                    color: Colors.black54,
                    padding: const EdgeInsets.all(15.0),
                    iconSize: 30.0,
                  ),
                ),
                new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: new Column(
                        children: children,
                      ),
                    ))
              ],
            )),
      );
    } else {
      var body = new Material(
        type: MaterialType.card,
        borderRadius: new BorderRadius.circular(10.0),
        //color: Colors.white,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      );
      var child = new IntrinsicWidth(
        child: onCancelPress == null
            ? body
            : new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.all(10.0),
              child: new IconButton(
                  highlightColor: Colors.white54,
                  splashColor: Colors.white54,
                  //color: Colors.white,
                  iconSize: 30.0,
                  padding: const EdgeInsets.all(3.0),
                  icon: const Icon(
                    Icons.cancel,
                  ),
                  onPressed: onCancelPress),
            ),
            new Flexible(child: body),
          ],
        ),
      );
      widget = new CustomDialog(child: child, expanded: expanded);
    }
    return widget;
  }
}

/// This is a modification of [Dialog]. The only modification is increasing the
/// elevation and changing the Material type.
class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    required this.child,
    required this.expanded,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
  }) : super(key: key);

  final Widget child;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return new AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: new MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: new Center(
          child: new ConstrainedBox(
            constraints: new BoxConstraints(
                minWidth: expanded
                    ? math.min(
                    (MediaQuery.of(context).size.width - 40.0), 332.0)
                    : 280.0),
            child: new Material(
              elevation: 50.0,
              type: MaterialType.transparency,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}