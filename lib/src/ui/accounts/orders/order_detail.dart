import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../functions.dart';
import './../../../blocs/orders_bloc.dart';
import './../../../models/app_state_model.dart';
import './../../../models/orders_model.dart';
import 'cancell_order.dart';
import 'order_note.dart';
import 'refund_order.dart';
import 'support_order.dart';
import 'track_order.dart';

class OrderDetail extends StatefulWidget {

  AppStateModel appStateModel = AppStateModel();
  final OrdersBloc ordersBloc;
  final Order order;

  OrderDetail({required  this.order, required this.ordersBloc});

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {


  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.appStateModel.blocks.localeText.order)
        ),
        body: ListView(
          children: _buildList(context)
        )
    );
  }

  _buildList(BuildContext context) {
    List<Widget> list = [];

    final ThemeData theme = Theme.of(context);
    final ListTileThemeData tileTheme = ListTileTheme.of(context);

    final NumberFormat formatter = NumberFormat.currency(
        decimalDigits: widget.order.decimals, locale: Localizations.localeOf(context).toString(), name: widget.order.currency);

    list.add(TrackOrder(order: widget.order));

    list.add(
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.order.number.toString() + ' - ' + getOrderStatusText(widget.order.status, widget.appStateModel.blocks.localeText),
              ),
              widget.order.status == 'pending' ? Container(
                height: 25,
                child: OutlinedButton(
                    onPressed: () async {
                      widget.ordersBloc.cancelOrder(widget.order);
                      setState(() {
                        widget.order.status = 'cancelled';
                      });
                    }, child: Text(widget.appStateModel.blocks.localeText.cancel)
                ),
              ) : Container()
            ],
          ),
        )
    );

    list.add(
      ListTile(
        title: Text(
          widget.appStateModel.blocks.localeText.billing.toUpperCase(),
        ),
        subtitle: Text('''${widget.order.billing.firstName} ${widget.order.billing.lastName} ${widget.order.billing.address1} ${widget.order.billing.address2} ${widget.order.billing.city} ${widget.order.billing.country} ${widget.order.billing.postcode}'''),
    ));

    list.add(SizedBox(height: 16));

    list.add(
        ListTile(
          title: Text(
            widget.appStateModel.blocks.localeText.shipping.toUpperCase(),
          ),
          subtitle: Text(
              '''${widget.order.shipping.firstName} ${widget.order.shipping.lastName} ${widget.order.shipping.address1} ${widget.order.shipping.address2} ${widget.order.shipping.city} ${widget.order.shipping.country} ${widget.order.shipping.postcode}'''),
        ));

    list.add(
        ListTile(
          title: Text(
            widget.appStateModel.blocks.localeText.payment.toUpperCase(),
          ),
          subtitle: Text(widget.order.paymentMethodTitle),
        ));

    if(widget.order.lineItems.length > 0)
    list.add(
        ListTile(
          title: Text(
            widget.appStateModel.blocks.localeText.products.toUpperCase(),
          ),
        )
    );

    for(final item in widget.order.lineItems) {

      list.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(item.name +
                              ' x ' +
                              item.quantity.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(formatter.format(
                            (double.parse('${item.total}')))),
                      ],
                    ))
              ],
            ),
          )
      );

      item.metaData.forEach((element) {
        if(element.value is String && !element.key.startsWith('_'))
          list.add(Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(toBeginningOfSentenceCase(element.key.replaceAll('pa_', ''))! + ': ' + element.value, style: _subtitleTextStyle(theme, tileTheme)))
          );
      });
    }

    list.add(
        ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OrderNotes(order: widget.order);
            }));
          },
          title: Text(widget.appStateModel.blocks.localeText.orderNote),
          trailing: Icon(Icons.keyboard_arrow_right),
        )
    );

    list.add(
        buildTotalDetails(context, formatter)
    );

    list.add(
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          if(widget.appStateModel.blocks.settings.orderSettings.supportOrderStatus.contains(widget.order.status))
            OutlinedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SupportOrder(order: widget.order);
              }));
            }, child: Text(widget.appStateModel.blocks.localeText.support)),
          if(widget.appStateModel.blocks.settings.orderSettings.refundOrderStatus.contains(widget.order.status))
            OutlinedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RefundOrder(order: widget.order);
              }));
            }, child: Text(widget.appStateModel.blocks.localeText.refund)),
            if(widget.appStateModel.blocks.settings.orderSettings.cancelOrderStatus.contains(widget.order.status))
            OutlinedButton(onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CancelOrder(order: widget.order);
              }));
              widget.ordersBloc.getOrders();
            }, child: Text(widget.appStateModel.blocks.localeText.cancel)),
          if(widget.order.deliveryBoy.phone.isNotEmpty)
            OutlinedButton(onPressed: () {
              launchUrl(Uri.parse('tel:'+widget.order.deliveryBoy.phone));
            }, child: Text(widget.appStateModel.blocks.localeText.callDeliveryBoy))
        ],
      ),
    );

    return list;
  }

  TextStyle _subtitleTextStyle(ThemeData theme, ListTileThemeData tileTheme) {
    final TextStyle? style = theme.textTheme.bodyText2;
    final Color? color = theme.textTheme.caption!.color;
    return style!.copyWith(color: color);
  }

  buildTotalDetails(BuildContext context, NumberFormat formatter) {

    List<Widget> feeWidgets = [];

    for (var fee in widget.order.feeLines) {
      feeWidgets.add(Column(
        children: [
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(fee.name),
              ),
              Text(formatter.format((double.parse('${fee.amount}')))),
            ],
          ),
        ],
      ));
    }

    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Divider(),
        SizedBox(height: 10.0),
        Text(
          widget.appStateModel.blocks.localeText.total.toUpperCase(),
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(widget.appStateModel.blocks.localeText.shipping,),
            ),
            Text(formatter.format((double.parse('${widget.order.shippingTotal}')))),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(widget.appStateModel.blocks.localeText.tax,),
            ),
            Text(formatter.format((double.parse('${widget.order.totalTax}')))),
          ],
        ),
        Column(
          children: feeWidgets,
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(widget.appStateModel.blocks.localeText.discount),
            ),
            Text(formatter.format((double.parse('${widget.order.discountTotal}')))),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                widget.appStateModel.blocks.localeText.total,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Text(
              formatter.format(
                double.parse(widget.order.total),
              ),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ]),
    );
  }
}


