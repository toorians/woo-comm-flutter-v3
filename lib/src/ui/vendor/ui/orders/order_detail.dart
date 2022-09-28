import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../blocs/vendor/vendor_bloc.dart';
import '../../../../models/app_state_model.dart';
import '../../../../models/orders_model.dart';
import 'edit_order.dart';

class OrderDetail extends StatefulWidget {
  final Order order;
  final VendorBloc vendorBloc;
  final appStateModel = AppStateModel();
  OrderDetail({required this.order, required this.vendorBloc});

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {

  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.currency(
        decimalDigits: widget.order.decimals,
        locale: Localizations.localeOf(context).toString(),
        name: widget.order.currency);
    return Scaffold(
      appBar: AppBar(
        title: Text("Order"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => widget.vendorBloc.deleteOrder(widget.order),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
        child: CustomScrollView(
          slivers: <Widget>[
            buildOrderDetails(context, formatter),
            buildItemDetails(context, formatter),
            buildTotalDetails(context, formatter),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditOrder(
                    vendorBloc: widget.vendorBloc,
                    order: widget.order,
                  )),
        ),
        tooltip: 'Edit',
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget buildOrderDetails(BuildContext context, NumberFormat formatter) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0),
            Text(
              "Order" + ' - ' + widget.order.id.toString(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Divider(),
            SizedBox(height: 10.0),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Billing",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                      '''${widget.order.billing.firstName} ${widget.order.billing.lastName} ${widget.order.billing.address1} ${widget.order.billing.address2} ${widget.order.billing.city} ${widget.order.billing.country} ${widget.order.billing.postcode}'''),
                ]),
            Divider(),
            SizedBox(height: 10.0),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Shipping",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                      '''${widget.order.shipping.firstName} ${widget.order.shipping.lastName} ${widget.order.shipping.address1} ${widget.order.shipping.address2} ${widget.order.shipping.city} ${widget.order.shipping.country} ${widget.order.shipping.postcode}'''),
                ]),
            Divider(),
            SizedBox(height: 10.0),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Payment",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(widget.order.paymentMethodTitle),
                ]),
            Divider(),
            SizedBox(height: 10.0),
            widget.order.lineItems != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        Text(
                          "Items",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ])
                : Container(),
          ],
        ),
      )
    ]));
  }

  buildTotalDetails(BuildContext context, NumberFormat formatter) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Container(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Divider(),
          SizedBox(height: 10.0),
          Text(
            "Total",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text("Shipping"),
              ),
              Text(formatter.format((double.parse('${widget.order.shippingTotal}')))),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.appStateModel.blocks.localeText.tax,
                ),
              ),
              Text(formatter.format((double.parse('${widget.order.totalTax}')))),
            ],
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
      )
    ]));
  }

  buildItemDetails(BuildContext context, NumberFormat formatter) {
    List<LineItem> lineItems = [];

    widget.order.lineItems.forEach((item) {
      lineItems.add(item);
      /*item.metaData.forEach((meta) {
        if(widget.appStateModel.blocks.settings.vendorType == 'wcfm' && meta.key == '_vendor_id' && meta.value == widget.appStateModel.user.id.toString()) {
          lineItems.add(item);
        }
      });*/
    });

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(lineItems[index].name +
                              ' x ' +
                              lineItems[index].quantity.toString()),
                        ),
                        Text(formatter.format(
                            (double.parse('${lineItems[index].total}')))),
                      ],
                    ),
                    height: 50),
              ],
            );
          },
          childCount: lineItems.length,
        ),
      ),
    );
  }
}
