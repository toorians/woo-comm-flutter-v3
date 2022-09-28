import 'dart:convert';
import 'package:app/src/blocs/checkout_form_bloc.dart';
import 'package:app/src/functions.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/checkout/order_result_model.dart';
import 'package:app/src/models/checkout/order_review_model.dart';
import 'package:app/src/models/checkout/paymongo_card.dart';
import 'package:app/src/ui/checkout/order_summary.dart';
import 'package:app/src/ui/checkout/payment/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CardPayment extends StatefulWidget {
  final OrderReviewModel orderReviewModel;
  final CheckoutFormBloc checkoutFormBloc;
  const CardPayment(
      {Key? key,
      required this.orderReviewModel,
      required this.checkoutFormBloc})
      : super(key: key);
  @override
  _CardPaymentState createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment> {

  late String authorizationKey;
  CardFieldInputDetails? _card;
  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    if(widget.orderReviewModel.paymentMethods
        .any((method) => method.id == 'paymongo')) {
      final str = widget.orderReviewModel.paymentMethods
          .singleWhere((method) => method.id == 'paymongo')
          .secretKey;
      final bytes = utf8.encode(str);
      authorizationKey = base64.encode(bytes);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        CardField(
          dangerouslyGetFullCardDetails: true,
          onCardChanged: (card) async {
            if(card != null) {
              setState(() {
                _card = card;
              });
            }
          },
        ),
        SizedBox(height: 16),
        LoadingButton(
            text: appStateModel.blocks.localeText.localeTextContinue,
            onPressed: _card?.complete == true ? _processCardPayment : null),
      ],
    );
  }

  Future<void> _processCardPayment() async {
    if(widget.checkoutFormBloc.formData['payment_method'] == 'nuvei') {
      await _processNuveiCardPayment();
    } else if(widget.checkoutFormBloc.formData['payment_method'] == 'paymongo') {
      await _processPayMongoCardPayment();
    }
  }

  Future<void> _processNuveiCardPayment() async {

    if(_card != null && _card!.complete) {

      String expMonth = _card!.expiryMonth.toString().padLeft(2, '0');

      if(widget.checkoutFormBloc.formData['billing_last_name'] != null) {
        widget.checkoutFormBloc.formData['nuvei-card-name'] = widget.checkoutFormBloc.formData['billing_first_name'] + widget.checkoutFormBloc.formData['billing_last_name']!;
        widget.checkoutFormBloc.formData['card-name'] = widget.checkoutFormBloc.formData['billing_first_name'] + widget.checkoutFormBloc.formData['billing_last_name']!;
      } else if(widget.checkoutFormBloc.formData['billing_first_name'] != null) {
        widget.checkoutFormBloc.formData['nuvei-card-name'] = widget.checkoutFormBloc.formData['billing_first_name']!;
        widget.checkoutFormBloc.formData['card-name'] = widget.checkoutFormBloc.formData['billing_first_name']!;
      }
      if(widget.orderReviewModel.csrfToken != null) {
        widget.checkoutFormBloc.formData['csrf-token'] = widget.orderReviewModel.csrfToken!;
      }

      widget.checkoutFormBloc.formData['nuvei-card-number'] = _card!.number!;//'4444 3333 2222 1111';//
      widget.checkoutFormBloc.formData['nuvei-card-expiry'] = expMonth + ' / '+ _card!.expiryYear!.toString();
      widget.checkoutFormBloc.formData['nuvei-card-cvc'] = _card!.cvc!;
      widget.checkoutFormBloc.formData['card-number'] = _card!.number!;//
      widget.checkoutFormBloc.formData['card-expiry'] = expMonth + _card!.expiryYear!.toString();
      widget.checkoutFormBloc.formData['cvc'] = _card!.cvc!;


      OrderResult orderResult = await widget.checkoutFormBloc.placeOrder();

      if (orderResult.result != 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
            Text(parseHtmlString(orderResult.messages))));
        return;
      } else {
        orderDetails(orderResult);
      }

    }
  }

  void orderDetails(OrderResult orderResult) {
    if (orderResult.result == 'success' && orderResult.redirect != null) {
      var orderId = getOrderIdFromUrl(orderResult.redirect!);
      if(orderId != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderSummary(
                  id: orderId,
                )));
      }
    }
  }

  Future<void>  _processPayMongoCardPayment() async {
    if(_card != null && _card!.complete) {

      PayMongoCardModel payMongoCardModel = PayMongoCardModel(
          data: PyaMongoData(
              id: '',
              attributes: PyaMongAttributes(
                  details: PyaMongDetails(
                      expMonth: _card!.expiryMonth!,
                      cvc: _card!.cvc!.toString(),
                      cardNumber: _card!.number!,
                      expYear: _card!.expiryYear!,
                  ),
                  type: 'card',
                  billing: PyaMongBilling(
                      email: widget.checkoutFormBloc.formData['billing_email'],
                      name: widget.checkoutFormBloc.formData['billing_last_name'],
                      phone: widget.checkoutFormBloc.formData['billing_phone'],
                      address: PyaMongAddress(
                          line1: widget.checkoutFormBloc.formData['billing_address_1'],
                          postalCode: widget.checkoutFormBloc.formData['billing_postcode'],
                          state: widget.checkoutFormBloc.formData['billing_state'],
                          city: widget.checkoutFormBloc.formData['billing_city'],
                          country: widget.checkoutFormBloc.formData['billing_country']
                      )
                  ),
              )
          ),
      );

      PayMongoCardModel newPayMongoCardModel = await widget.checkoutFormBloc.getPayMongoToken(payMongoCardModel, authorizationKey);
      if(newPayMongoCardModel.data.id.isNotEmpty) {
        widget.checkoutFormBloc.formData['cynder_paymongo_method_id'] = newPayMongoCardModel.data.id;
        OrderResult orderResult = await widget.checkoutFormBloc.placeOrder();
        if (orderResult.result != 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
              Text(parseHtmlString(orderResult.messages))));
          return;
        } else {
          orderDetails(orderResult);
        }
      }
      return;
    }
  }
}
