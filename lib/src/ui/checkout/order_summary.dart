import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import '../../../src/models/app_state_model.dart';
import '../../blocs/order_summary_bloc.dart';
import '../../models/orders_model.dart';

class OrderSummary extends StatefulWidget {
  final String id;
  final appStateModel = AppStateModel();
  final OrderSummaryBloc orderSummary = OrderSummaryBloc();

  OrderSummary({Key? key, required this.id}) : super(key: key);

  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {

  @override
  void initState(){
    super.initState();
    widget.orderSummary.getOrder(widget.id);
    context.read<ShoppingCart>().clearCart();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: StreamBuilder<Order>(
            stream: widget.orderSummary.order,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final NumberFormat formatter = NumberFormat.currency(
                    decimalDigits: snapshot.data!.decimals, name: snapshot.data!.currency);
                return buildOrderStatusScreen(snapshot.data!, width, height, context);
              } else {
                return Center(child: CircularProgressIndicator(),);
              }
            }
        ));
  }

  Container buildOrderStatusScreen(Order order, double width, double height, BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end:
            Alignment(0.9, 0.9),
            colors:  <Color>[
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.secondaryVariant
            ],
          )
      ),
      child: Stack(
        children: [
          Positioned(
              left: width *.25,
              top: height * .05,
              child: Icon(Icons.star_border,size: 30,color: Colors.lime,)
          ),
          Positioned(
              right: width * -.12,
              top: height * .01,
              child: Icon(Icons.ac_unit_outlined,size: 100,color: Colors.white24,)
          ),
          Positioned(
              right: width *.25,
              top: height * .15,
              child: Icon(Icons.star_border,size: 15,color: Colors.lime,)
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center ,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Icon(Icons.check_circle_rounded, size: 144, color: Colors.white),
                SizedBox(height: 16),
                Text(widget.appStateModel.blocks.localeText.youOrderHaveBeenReceived,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w800,
                    //letterSpacing: 1
                  ),),
                SizedBox(height: 4),
                Text(widget.appStateModel.blocks.localeText.status.toUpperCase() + ': ' + order.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w800,
                    //letterSpacing: 1
                  ),),
                SizedBox(height: 4),
                Text('ID' + ': ' + order.number.toUpperCase(),
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w800,
                    //letterSpacing: 1
                  ),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                  child: Text(widget.appStateModel.blocks.localeText.thankYouForShoppingWithUs,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      //letterSpacing: 1
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: ElevatedButton(
                    onPressed: () {
                      widget.orderSummary.thankYou(order);
                      context.read<ShoppingCart>().getCart();
                      Navigator.of(context).pop();
                      Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.onSecondary,
                      onPrimary: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Text(widget.appStateModel.blocks.localeText.localeTextContinue),
                  ),
                )
              ],
            ),
          ),
        ],
      ) ,
    );
  }
}