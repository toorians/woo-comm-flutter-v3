import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_paystack/src/common/card_utils.dart';
import 'package:flutter_paystack/src/widgets/input/cvc_field.dart';
import 'package:flutter_paystack/src/widgets/input/date_field.dart';
import 'package:flutter_paystack/src/widgets/input/number_field.dart';
import '../../../../src/ui/widgets/buttons/button_text.dart';

class CardInput extends StatefulWidget {
  final String text;
  final PaymentCard card;
  final ValueChanged<PaymentCard> onValidated;

  CardInput({required this.text, required this.card, required this.onValidated});

  @override
  _CardInputState createState() => _CardInputState();
}

class _CardInputState extends State<CardInput> {
  var _formKey = new GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  late TextEditingController numberController;
  bool _validated = false;


  @override
  void initState() {
    super.initState();
    numberController = new TextEditingController();
    numberController.addListener(_getCardTypeFrmNumber);
    numberController.text = widget.card.number != null ? widget.card.number! : '';
  }

  @override
  void dispose() {
    super.dispose();
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
        autovalidateMode: _autoValidate,
        key: _formKey,
        child: new Column(
          children: <Widget>[
            new NumberField(
              controller: numberController,
              card: widget.card,
              onSaved: (String? value) =>
              widget.card.number = CardUtils.getCleanedNumber(value),
              suffix: getCardIcon(),
            ),
            new SizedBox(
              height: 15.0,
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Flexible(
                    child: new DateField(
                        card: widget.card,
                        onSaved: (value) {
                          List<int> expiryDate = CardUtils.getExpiryDate(value);
                          widget.card.expiryMonth = expiryDate[0];
                          widget.card.expiryYear = expiryDate[1];
                        }
                    )),
                new SizedBox(width: 15.0),
                new Flexible(
                    child: new CVCField(
                      card: widget.card,
                      onSaved: (value) {
                        widget.card.cvc = CardUtils.getCleanedNumber(value);
                      },
                    )),
              ],
            ),
            new SizedBox(
              height: 20.0,
            ),
            new ElevatedButton(
                onPressed: _validateInputs,
                child: ButtonText(
                    isLoading: _validated,
                    text: widget
                        .text)),
          ],
        ));
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    String cardType = widget.card.getTypeForIIN(input);
    setState(() {
      widget.card.type = cardType;
    });
  }

  void _validateInputs() {
    FocusScope.of(context).requestFocus(new FocusNode());
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      widget.onValidated(widget.card);
      if (mounted) {
        setState(() => _validated = true);
      }
    } else {
      setState(() => _autoValidate = AutovalidateMode.always);
    }
  }

  Widget getCardIcon() {
    String img = "";
    var defaultIcon = new Icon(
      Icons.credit_card,
      size: 15.0,
      color: Colors.grey[600],
    );
    switch (widget.card.type) {
      case CardType.masterCard:
        img = 'mastercard.png';
        break;
      case CardType.visa:
        img = 'visa.png';
        break;
      case CardType.verve:
        img = 'verve.png';
        break;
      case CardType.americanExpress:
        img = 'american_express.png';
        break;
      case CardType.discover:
        img = 'discover.png';
        break;
      case CardType.dinersClub:
        img = 'dinners_club.png';
        break;
      case CardType.jcb:
        img = 'jcb.png';
        break;
    }
    Widget newWidget;
    if (img.isNotEmpty) {
      newWidget = new Image.asset('assets/images/$img',
          height: 15.0, width: 30.0, package: 'flutter_paystack');
    } else {
      newWidget = defaultIcon;
    }
    return newWidget;
  }
}
