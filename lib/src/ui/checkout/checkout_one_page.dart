import 'package:app/src/blocs/payment/paystack_bloc.dart';
import 'package:app/src/blocs/payment/razorpay_bloc.dart';
import 'package:app/src/config.dart';
import 'package:app/src/models/cart/cart_model.dart';
import 'package:app/src/models/payment/payment_verification_response.dart';
import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/src/ui/checkout/inappwebview.dart';
import 'package:app/src/ui/checkout/payment/card_payment.dart';
import 'package:app/src/ui/checkout/payment/stripe_payment.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../models/checkout_data_model.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../blocs/checkout_form_bloc.dart';
import '../../models/orders_model.dart';
import '../widgets/buttons/button_text.dart';
import '../../functions.dart';
import '../../models/app_state_model.dart';
import '../../models/checkout/order_result_model.dart';
import '../../models/checkout/order_review_model.dart';
import '../../ui/checkout/webview.dart';
import '../color_override.dart';
import 'order_summary.dart';
import 'payment/webview_submit.dart';
import 'package:intl/intl.dart';

class CheckoutOnePage extends StatefulWidget {
  final CheckoutFormBloc checkoutFormBloc;
  final appStateModel = AppStateModel();
  CheckoutOnePage({required this.checkoutFormBloc});
  @override
  _CheckoutOnePageState createState() => _CheckoutOnePageState();
}

class _CheckoutOnePageState extends State<CheckoutOnePage> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late Razorpay _razorpay;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    //Only for payzah Payment
    widget.checkoutFormBloc.formData['payzah_transaction_type'] = '1';
    widget.checkoutFormBloc.updateOrderReview2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.appStateModel.blocks.localeText.checkout),
      ),
      body: SafeArea(
        child: StreamBuilder<OrderReviewModel>(
            stream: widget.checkoutFormBloc.orderReview,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? _buildCheckoutForm(snapshot, context)
                  : Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  Widget _buildCheckoutForm(
      AsyncSnapshot<OrderReviewModel> snapshot, BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          return CustomScrollView(
            slivers: slivers(snapshot, context, model),
          );
        });
  }

  List<Widget> slivers(AsyncSnapshot<OrderReviewModel> snapshot,
      BuildContext context, AppStateModel model) {

    TextStyle subhead = Theme.of(context).textTheme.headline6!;

    List<Widget> list = [];

    if (snapshot.data!.shipping.length > 0) {
      for (var i = 0; i < snapshot.data!.shipping.length; i++) {
        if (snapshot.data!.shipping[i].shippingMethods.length > 0) {
          list.add(SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
                child: Text(
                  parseHtmlString(snapshot.data!.shipping[i].packageName),
                  style: subhead,
                ),
              )));

          list.add(_buildShippingList(snapshot, i));
        }
      }

      list.add(SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
            child: Divider(
              color: Theme.of(context).dividerColor,
              height: 10.0,
            ),
          )));
    }

    if(model.deliveryDate.bookableDates.isNotEmpty && model.deliveryDate.bookableDates.length > 0) {
      list.add(
          _buildDeliveryDate(model)
      );

      if(model.deliverySlot.isNotEmpty && model.deliverySlot[model.selectedDate]?.slots != null) {
        list.add(
            _buildDeliveryTimeSlot(model)
        );
      } else {
        list.add(
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
        );
      }
    }

    if(snapshot.data!.paymentMethods.length > 0) {
      list.add(SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
            child: Text(
              widget.appStateModel.blocks.localeText.paymentMethod,
              style: subhead,
            ),
          )));

      list.add(_buildPaymentList(snapshot));
    }

    if(['dear_eko_wmbp_eko','dear_paym_wmbp_paym','dear_pesa_wmbp_pesa', 'mpesa'].contains(widget.checkoutFormBloc.formData['payment_method'])) {
      list.add(_dearPesaPayament());
    }

    if(['woo_bkash','woo_nagad','woo_rocket','softtech_rocket','softtech_nagad','softtech_bkash'].contains(widget.checkoutFormBloc.formData['payment_method'])) {
      list.add(_banglaPayament());
    }

    if(widget.checkoutFormBloc.formData['payment_method'] == 'wc-upi') {
      list.add(_buildWCUPIForm());
    }

    if(widget.checkoutFormBloc.formData['payment_method'] == 'payzah') {
      list.add(_buildPayzahForm());
    }

    list.add(SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
          child: Text(
            widget.appStateModel.blocks.localeText.order,
            style: subhead,
          ),
        )));

    list.add(_buildOrderList(snapshot));
    list.add(SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (widget.checkoutFormBloc.formData['payment_method'] == 'stripe' || widget.checkoutFormBloc.formData['payment_method'] == 'stripe_cc' || widget.checkoutFormBloc.formData['payment_method'] == 'nuvei' || widget.checkoutFormBloc.formData['payment_method'] == 'paymongo')
              Container()
            else ElevatedButton(
              child: ButtonText(isLoading: isLoading, text: widget.appStateModel.blocks.localeText.localeTextContinue),
              onPressed: () => isLoading ? null : _placeOrder(context, snapshot),
            ),
            StreamBuilder<OrderResult>(
                stream: widget.checkoutFormBloc.orderResult,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.result == "failure") {
                    return Center(
                      child: Container(
                          padding: EdgeInsets.all(16),
                          child: Html(data: snapshot.data!.messages, style: {
                            "*": Style(color: Theme.of(context).errorColor),
                            //"p": Style(color: Theme.of(context).hintColor),
                          }))
                    );
                  } else if (snapshot.hasData &&
                      snapshot.data!.result == "success") {
                    return Container();
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    ));

    return list;
  }

  _buildShippingList(AsyncSnapshot<OrderReviewModel> snapshot, int i) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return RadioListTile<String>(
            selected: snapshot.data!.shipping[i].shippingMethods[index].id == snapshot.data!.shipping[i].chosenMethod,
            value: snapshot.data!.shipping[i].shippingMethods[index].id,
            groupValue: snapshot.data!.shipping[i].chosenMethod,
            onChanged: (String? value) {
              if(value != null) {
                setState(() {
                  snapshot.data!.shipping[i].chosenMethod = value;
                });
                widget.checkoutFormBloc.updateOrderReview2();
              }
            },
            title: Text(parseHtmlString(snapshot.data!.shipping[i].shippingMethods[index].label) +
                ' ' +
                parseHtmlString(
                    snapshot.data!.shipping[i].shippingMethods[index].cost)),
          );
        },
        childCount: snapshot.data!.shipping[i].shippingMethods.length,
      ),
    );
  }

  _buildDeliveryDate(AppStateModel model) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(8),
        height: 100.0,
        width: 120.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: model.deliveryDate.bookableDates.length,
          itemBuilder: (context, index) {
            List<String> str =
            model.deliveryDate.bookableDates[index].split('/');
            DateTime now = new DateTime(
                int.parse(str[2]), int.parse(str[1]), int.parse(str[0]));
            final DateFormat formatter = DateFormat('EEEE, dd MMM');
            final String formatted = formatter.format(now);
            // DateFormat.yMMMEd().format(dt);
            //final String formatted = DateFormat.MMMEd().format(now);
            String date = str[2] + str[1] + str[0];
            return Container(
              width: MediaQuery.of(context).size.width * 0.32,
              child: GestureDetector(
                child: Card(
                  color: model.selectedDate == date
                      ? Theme.of(context).colorScheme.secondary
                      : null,
                  child: InkWell(
                    highlightColor: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(4.0),
                    onTap: () async {
                      setState(() {
                        isLoading = false;
                      });
                      model.setDate(date, model.deliveryDate.bookableDates[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ListTile(
                        //title: Text(widget.appStateModel.blocks.localeText.address, style: Theme.of(context).textTheme.subtitle),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              child: Text(
                                formatted,
                                style: TextStyle(
                                  color: model.selectedDate ==
                                      date
                                      ? Theme.of(context).colorScheme.onSecondary
                                      : null,
                                ),
                              )),
                        ),
                      ),

                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _buildDeliveryTimeSlot(AppStateModel model) {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return RadioListTile(
            selected: model
                .deliverySlot[model.selectedDate]!
                .slots[index]
                .value == model.selectedTime,
            value: model
                .deliverySlot[model.selectedDate]!
                .slots[index]
                .value,
            groupValue: model.selectedTime,
            onChanged: (String? value) {
              setState(() {
                isLoading = false;
              });
              if(value != null)
              model.setDeliveryTime(value);
            },
            title: Container(
                width: cWidth,
                child: Text(model
                    .deliverySlot[model.selectedDate]!
                    .slots[index]
                    .formatted)),
          );
        },
        childCount: model
            .deliverySlot[model.selectedDate]!
            .slots
            .length,
      ),
    );
  }

  _buildPaymentList(AsyncSnapshot<OrderReviewModel> snapshot) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          Widget paymentTitle = snapshot.data!.paymentMethods[index].id == 'wallet' ? Row(
            children: [
              Text(parseHtmlString(snapshot.data!.paymentMethods[index].title)),
              SizedBox(width: 8),
              Text(parseHtmlString(snapshot.data!.balanceFormatted))
            ],
          ) : Text(parseHtmlString(snapshot.data!.paymentMethods[index].title));
          return RadioListTile<String>(
            selected: snapshot.data!.paymentMethods[index].id == widget.checkoutFormBloc.formData['payment_method'],
            value: snapshot.data!.paymentMethods[index].id,
            groupValue: widget.checkoutFormBloc.formData['payment_method'],
            onChanged: (String? value) {
              if(value != null) {
                setState(() {
                  isLoading = false;
                  widget.checkoutFormBloc.formData['payment_method'] = value;
                });
                widget.checkoutFormBloc.updateOrderReview2();
              }
            },
            title: paymentTitle,
            subtitle: snapshot.data!.paymentMethods[index].description.isNotEmpty && snapshot.data!.paymentMethods[index].description.isNotEmpty ? Text(parseHtmlString(snapshot.data!.paymentMethods[index].description)) : null,
          );
        },
        childCount: snapshot.data!.paymentMethods.length,
      ),
    );
  }

  _buildOrderList(AsyncSnapshot<OrderReviewModel> snapshot) {
    final smallAmountStyle = Theme.of(context).textTheme.bodyText1;
    final largeAmountStyle = Theme.of(context).textTheme.headline6;

    CartModel cart = context.read<ShoppingCart>().cart;

    List<Widget> feeWidgets = [];

    for (var fee in cart.cartFees) {
      feeWidgets.add(Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Text(fee.name, style: smallAmountStyle,),
              ),
              Text(
                parseHtmlString(fee.total.toString()),
                style: smallAmountStyle,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
        ],
      ));
    }

    List<Widget> couponsWidgets = [];
    for (var item in cart.coupons) {
      couponsWidgets.add(Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    Text(item.label, style: smallAmountStyle,),
                    SizedBox(
                      width: 6,
                    ),
                    GestureDetector(
                        onTap: () => context.read<ShoppingCart>().removeCoupon(item.code),
                        child: Text(
                          widget.appStateModel.blocks.localeText.remove,
                          style: TextStyle(color: Colors.red),
                        )),
                  ],
                ),
              ),
              Text(
                parseHtmlString(item.amount.toString()),
                style: smallAmountStyle,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
        ],
      ));
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                      widget.appStateModel.blocks.localeText.subtotal + ':'),
                ),
                Text(
                  parseHtmlString(snapshot.data!.totals.subtotal),
                  style: smallAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                      widget.appStateModel.blocks.localeText.shipping + ':'),
                ),
                Text(
                  parseHtmlString(snapshot.data!.totals.shippingTotal),
                  style: smallAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              children: [
                Expanded(
                  child: Text(widget.appStateModel.blocks.localeText.tax + ':'),
                ),
                Text(
                  parseHtmlString(snapshot.data!.totals.totalTax),
                  style: smallAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(widget.appStateModel.blocks.localeText.discount),
                ),
                Text(
                  parseHtmlString(snapshot.data!.totals.discountTotal),
                  style: smallAmountStyle,
                ),
              ],
            ),
            feeWidgets.length > 0
                ? Column(
              children: [
                const SizedBox(height: 6.0),
                Column(
                  children: feeWidgets,
                ),
              ],
            ) : Container(),
            couponsWidgets.length > 0
                ? Column(
              children: [
                const SizedBox(height: 6.0),
                Column(
                  children: couponsWidgets,
                ),
              ],
            ) : Container(),
            const SizedBox(height: 6.0),
            const SizedBox(height: 6.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.appStateModel.blocks.localeText.total,
                    style: largeAmountStyle,
                  ),
                ),
                Text(
                  parseHtmlString(snapshot.data!.totals.total),
                  style: largeAmountStyle,
                ),
              ],
            ),
            StreamBuilder<CheckoutFormData>(
                stream: widget.checkoutFormBloc.checkoutForm,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Widget orderNoteBox = Container();
                    if(snapshot.data!.fieldgroups.order != null)
                      snapshot.data!.fieldgroups.order.forEach((element) {
                        if(element.key == 'order_comments')
                        orderNoteBox  = Column(
                          children: [
                            const SizedBox(height: 6.0),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: PrimaryColorOverride(
                                      child: TextFormField(
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          alignLabelWithHint: true,
                                          labelText: element.label,
                                          hintText: element.placeholder,
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          errorMaxLines: 2,
                                          hintMaxLines: 2,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 0.5),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          widget.checkoutFormBloc
                                              .formData['order_comments'] = value;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                    return orderNoteBox;
                  } else {
                    return Container();
                  }
                }
            ),
            if (widget.checkoutFormBloc.formData['payment_method'] == 'stripe' || widget.checkoutFormBloc.formData['payment_method'] == 'stripe_cc')
            StripePayment(orderReviewModel: snapshot.data!, checkoutFormBloc: widget.checkoutFormBloc),
            if (widget.checkoutFormBloc.formData['payment_method'] == 'nuvei' || widget.checkoutFormBloc.formData['payment_method'] == 'paymongo')
              CardPayment(orderReviewModel: snapshot.data!, checkoutFormBloc: widget.checkoutFormBloc),
          ],
        ),
      ),
    );
  }

  openWebView(String url)  async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewPage(
                url: url,
                selectedPaymentMethod: widget.checkoutFormBloc.formData['payment_method']!)));
    setState(() {
      isLoading = false;
    });
  }

  webViewSubmit()  async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewSubmit(checkoutBloc: widget.checkoutFormBloc)));
    setState(() {
      isLoading = false;
    });
  }

  void orderDetails(OrderResult orderResult) {
    if(orderResult.result == 'success' && orderResult.redirect != null) {
      var orderId = getOrderIdFromUrl(orderResult.redirect!);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderSummary(
                id: orderId,
              )));
    }
  }

  _placeOrder(BuildContext context, AsyncSnapshot<OrderReviewModel> snapshot) async {

    setState(() {
      isLoading = true;
    });

    //if(widget.homeBloc.formData['payment_method'] == 'eh_stripe_checkout') {
    //webViewSubmit();
    //}

    OrderResult orderResult = await widget.checkoutFormBloc.placeOrder();
    if (orderResult.result == 'success') {
      if (widget.checkoutFormBloc.formData['payment_method'] == 'cod' ||
          widget.checkoutFormBloc.formData['payment_method'] == 'wallet' ||
          widget.checkoutFormBloc.formData['payment_method'] == 'cheque' ||
          widget.checkoutFormBloc.formData['payment_method'] == 'bacs' ||
          widget.checkoutFormBloc.formData['payment_method'] == 'paypalpro') {
        orderDetails(orderResult);
        setState(() {
          isLoading = false;
        });
      } else if (widget.checkoutFormBloc.formData['payment_method'] == 'payuindia' ||
          widget.checkoutFormBloc.formData['payment_method'] == 'paytm' && orderResult.redirect != null) {
        openWebView(orderResult.redirect!);
        setState(() {
          isLoading = false;
        });
        //Navigator.push(context, MaterialPageRoute(builder: (context) => PaytmPage()));
      } else if (widget.checkoutFormBloc.formData['payment_method'] == 'woo_mpgs' && orderResult.redirect != null) {
        bool status = await widget.checkoutFormBloc
            .processCredimaxPayment(orderResult.redirect!);
        openWebView(orderResult.redirect!);
        setState(() {
          isLoading = false;
        });
      } else if (widget.checkoutFormBloc.formData['payment_method'] == 'razorpay' && orderResult.redirect != null) {
        //openWebView(orderResult.redirect!);
        processRazorPay(context, snapshot, orderResult); // Uncomment this for SDK Payment
      } else if (widget.checkoutFormBloc.formData['payment_method'] == 'paystack') {
        if('redirect' == snapshot.data!.paymentMethods
            .singleWhere((method) => method.id == 'paystack')
            .paymentPage) {
          openWebView(orderResult.redirect!);
        } else {
          processPayStack(context, snapshot, orderResult);
        }
      } else if(orderResult.redirect != null) {
        openWebView(orderResult.redirect!);
        setState(() {
          isLoading = false;
        });
      } else if(orderResult.orderId != null) {
        Order order = await widget.checkoutFormBloc.getNewOrder(orderResult.orderId.toString());
        String url = Config().url + '/checkout/order-pay/' + orderResult.orderId.toString() + '/?pay_for_order=true&key=' + order.orderKey;
        openWebView(url);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      // Order result is faliure
    }
  }

  /// PayStack Payment.
  Future<void> processPayStack(BuildContext context, AsyncSnapshot<OrderReviewModel> snapshot, OrderResult orderResult) async {
    PaymentVerificationResponse paymentStatus = await PayStackPaymentBloc().processPayStack(context, widget.checkoutFormBloc.formData['billing_email']!, snapshot.data!, orderResult);
    setState(() => isLoading = false);
    if(paymentStatus.status == true) {
      orderDetails(orderResult);
    } else {
      showSnackBarError(context, paymentStatus.message);
    }
  }

  /// RazorPay Payment.
  Future<void>? processRazorPay(BuildContext context, AsyncSnapshot<OrderReviewModel> snapshot, OrderResult orderResult) async {


    var orderId = getOrderIdFromUrl(orderResult.redirect!);

    var uri = Uri.dataFromString(orderResult.redirect!);
    Map<String, String> params = uri.queryParameters;
    String orderKey = params['key']!;

    Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {

      //redirect URL
      //https://apps.buildapp.online/woocommerce/checkout/order-pay/3609/?key=wc_order_JcgqzUyfQR84e
      //https://apps.buildapp.online/woocommerce/?wc-api=razorpay
      var data = new Map<String, dynamic>();
      data['razorpay_payment_id'] = response.paymentId;
      if(response.signature != null)
      data['razorpay_signature'] = response.signature;
      if(response.orderId != null)
      data['razorpay_order_id'] = response.orderId;
      data['razorpay_wc_form_submit'] = '1';
      widget.checkoutFormBloc.apiProvider.postWithCookies('/?wc-api=razorpay&order_key=' + orderKey, data);
      //await widget.checkoutFormBloc.apiProvider.getRazorPay('/checkout/order-received/'+orderId+'/?key=' + orderKey);
      _razorpay.clear();
      setState(() {
        isLoading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderSummary(
                id: orderId,
              )));
      //Redirect to Order Success Page
      //Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId, timeInSecForIos: 4);
    }

    void _handlePaymentError(PaymentFailureResponse response) {
      setState(() {
        isLoading = false;
      });
      _razorpay.clear();
      //TODO Display Error Messages
      //Fluttertoast.showToast(msg: "ERROR: " + response.code.toString() + " - " + response.message, timeInSecForIos: 4);
    }

    void _handleExternalWallet(ExternalWalletResponse response) {
      setState(() {
        isLoading = false;
      });
      _razorpay.clear();
      //TODO Display Error Messages
      //print("response" + response.toString());
      //Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
    }

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    String keyId = snapshot.data!.paymentMethods
        .singleWhere((method) => method.id == 'razorpay')
        .settings.keyId;

    //TODO get razorPay order id before proceeding
    String rzOrderId =  await widget.checkoutFormBloc.getRzOrderId(orderId);


    //TODO Put real data here
    var options = {
      'key': keyId,
      'amount': snapshot.data!.totalsUnformatted.total,
      'name': widget.checkoutFormBloc.formData['billing_firstname'],
      'order_id': rzOrderId,
      'description': 'Order',
      'prefill': {'contact': widget.checkoutFormBloc.formData['billing_phone'], 'email': widget.checkoutFormBloc.formData['email']},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      //debugPrint(e);
    }
  }

  Widget _dearPesaPayament() {
    switch (widget.checkoutFormBloc.formData['payment_method']) {
      case 'dear_eko_wmbp_eko':
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How to pay', style: Theme.of(context).textTheme.headline6,),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1. Dial *150*01#'),
                      Text('2. Select 5 – Pay Merchant'),
                      Text('3. Select 2 – Pay Masterpass QR Merchant'),
                      //REPLACE MERCHANT NUMBER WITH ACTUAL
                      Text('4. Enter 8-digit Merchant Number “'+widget.appStateModel.blocks.settings.phoneNumber+'”'),
                      Text('5. Enter Amount'),
                      Text('6. Enter PIN to confirm'),
                      Text('7. You will receive confirmation SMS'),
                      Text('8. Fill Up The Form Below'),
                    ],
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Type Your Tigo-Pesa Number Used To Pay<',
                        hintText: 'e.g 0712XXXXXX'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['wmbp_eko_number']  = value;
                      });
                    },
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Type the TransID from the SMS sent to your Mobile No. Used To Pay',
                        hintText: 'e.g 1D2345X67BZ'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['wmbp_eko_transaction_id']  = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      case 'dear_paym_wmbp_paym':
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How to pay', style: Theme.of(context).textTheme.headline6,),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1. Dial *150*60#'),
                      Text('2. Select 5 – Make Payments'),
                      Text('3. Select 1 – Merchant Payments'),
                      Text('4. Select 1 – Pay with SelcomPay/Masterpass'),
                      Text('6. Enter Amount'),
                      //REPLACE MERCHANT NUMBER WITH ACTUAL
                      Text('6. Enter Merchant Number “'+widget.appStateModel.blocks.settings.phoneNumber+'”'),
                      Text('7. Enter PIN to confirm'),
                      Text('8. You will receive confirmation SMS'),
                      Text('9. Fill Up The Form Below'),
                    ],
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Type Your Airtel Number Used To Pay',
                        hintText: 'e.g 078XXXXXXX'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['wmbp_paym_number']  = value;
                      });
                    },
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Type the TransID from the SMS sent to your Airtel No. Used To Pay',
                        hintText: 'e.g 123BX456X12BZ'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['wmbp_paym_transaction_id']  = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      case 'dear_pesa_wmbp_pesa':
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How to pay', style: Theme.of(context).textTheme.headline6,),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1. Dial *150*00#'),
                      Text('2. Choose 4 – Lipa by M-Pesa'),
                      Text('3. Choose 4 – Enter Business Number'),
                      Text('4. Enter “123123” (As Selcom Pay/Masterpass Number)'),
                      //REPLACE MERCHANT NUMBER WITH ACTUAL
                      Text('5. Enter Reference Number “'+widget.appStateModel.blocks.settings.phoneNumber+'”'),
                      Text('6. Enter Amount'),
                      Text('7. Enter PIN to confirm'),
                      Text('8. You will receive confirmation SMS'),
                      Text('9. Fill Up The Form Below'),
                    ],
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Type Your M-Pesa No. Used To Pay',
                        hintText: 'e.g 0752XXXXXX'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['wmbp_pesa_number']  = value;
                      });
                    },
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Type the TransID from the SMS sent to your Mobile No. Used To Pay',
                        hintText: 'e.g 6D4256X68BZ'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['wmbp_pesa_transaction_id']  = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      case 'mpesa':
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Confirm M-PESA Phone Number',
                        //hintText: '',
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['billing_mpesa_phone']  = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return SliverToBoxAdapter();
    }
  }

  Widget _banglaPayament() {
    switch (widget.checkoutFormBloc.formData['payment_method']) {
      case 'woo_bkash':
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How to pay', style: Theme.of(context).textTheme.headline6,),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1. Go to your bKash app or Dial *247#'),
                      Text('2. Choose “Send Money”'),
                      Text('3. Enter bKash Account Number: “'+widget.appStateModel.blocks.settings.phoneNumber+'”'),
                      Text('4. Enter total amount'),
                      Text('5. Now enter your bKash Account PIN to confirm the transaction'),
                      Text('6. Copy Transaction ID from payment confirmation message and paste that Transaction ID below'),
                    ],
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Your bKash Account Number',
                        hintText: 'e.g 0712XXXXXXX'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['bKash_acc_no']  = value;
                      });
                    },
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'bKash Transaction ID',
                        hintText: 'e.g 2M7A5'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['bKash_trans_id']  = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      case 'woo_nagad':
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How to pay', style: Theme.of(context).textTheme.headline6,),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1. Go to your Nagad app or Dial *167#'),
                      Text('2. Choose “Send Money”'),
                      Text('3. Enter Nagad Account Number: “'+widget.appStateModel.blocks.settings.phoneNumber+'”'),
                      Text('4. Enter total amount'),
                      Text('5. Now enter your Nagad Account PIN to confirm the transaction'),
                      Text('6. Copy Transaction ID from payment confirmation message and paste that Transaction ID below'),
                    ],
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Your Nagad Account Number',
                        hintText: 'e.g 0712XXXXXXX'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['nagad_acc_no']  = value;
                      });
                    },
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Nagad Transaction ID',
                        hintText: 'e.g 2M7A5'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['nagad_trans_id']  = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      case 'woo_rocket':
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How to pay', style: Theme.of(context).textTheme.headline6,),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1. Dial *150*00#'),
                      Text('2. Choose 4 – Lipa by M-Pesa'),
                      Text('3. Choose 4 – Enter Business Number'),
                      Text('4. Enter “123123” (As Selcom Pay/Masterpass Number)'),
                      //REPLACE MERCHANT NUMBER WITH ACTUAL
                      Text('5. Enter Reference Number “'+widget.appStateModel.blocks.settings.phoneNumber+'”'),
                      Text('6. Enter Amount'),
                      Text('7. Enter PIN to confirm'),
                      Text('8. You will receive confirmation SMS'),
                      Text('9. Fill Up The Form Below'),
                    ],
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Type Your M-Pesa No. Used To Pay',
                        hintText: 'e.g 0752XXXXXX'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['wmbp_pesa_number']  = value;
                      });
                    },
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Type the TransID from the SMS sent to your Mobile No. Used To Pay',
                        hintText: 'e.g 2M7A5'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['wmbp_pesa_transaction_id']  = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      case 'softtech_rocket':
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Rocket Number',
                        hintText: 'e.g 0752XXXXXX'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['rocket_transaction_id']  = value;
                      });
                    },
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Your Rocket Transaction ID',
                        hintText: 'e.g 8N7A6D5E'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['rocket_transaction_id']  = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      case 'softtech_nagad':
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Your Nagad Number',
                        hintText: 'e.g 0712XXXXXXX'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['nagad_number']  = value;
                      });
                    },
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Nagad Transaction ID',
                        hintText: 'e.g 8N7A6D5E',
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['nagad_transaction_id']  = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      case 'softtech_bkash':
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Your bKash Number',
                        hintText: 'e.g 0712XXXXXXX'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['bkash_number']  = value;
                      });
                    },
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'bKash Transaction ID',
                        hintText: 'e.g 8N7A6D5E'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['bkash_transaction_id']  = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How to pay', style: Theme.of(context).textTheme.headline6,),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1. Go to your Rocket app or Dial *167#'),
                      Text('2. Choose “Send Money”'),
                      Text('3. Enter Rocket Account Number: “'+widget.appStateModel.blocks.settings.phoneNumber+'”'),
                      Text('4. Enter total amount'),
                      Text('5. Now enter your Rocket Account PIN to confirm the transaction'),
                      Text('6. Copy Transaction ID from payment confirmation message and paste that Transaction ID below'),
                    ],
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Your Rocket Account Number',
                        hintText: 'e.g 0712XXXXXXX'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['rocket_acc_no']  = value;
                      });
                    },
                  ),
                ),
                PrimaryColorOverride(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Rocket Transaction ID',
                        hintText: 'e.g 2M7A5'
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.checkoutFormBloc.formData['rocket_trans_id']  = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildWCUPIForm() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
        child: Column(
          children: [
            PrimaryColorOverride(
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'UPI Address',
                    hintText: 'e.g Mobile Number'
                ),
                onChanged: (value) {
                  setState(() {
                    widget.checkoutFormBloc.formData['customer_upiwc_address']  = value;
                  });
                },
              ),
            ),
            DropdownButton<String>(
              value: widget.checkoutFormBloc.formData['customer_upiwc_handle'],
              hint: Text('UPI Handle`Z                      '),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Theme.of(context).dividerColor,
              ),
              onChanged: (String? newValue) {
                if(newValue != null)
                setState(() {
                  widget.checkoutFormBloc.formData['customer_upiwc_handle'] = newValue;
                });
              },
              items: UPI_Handle.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: value != null ? Text(value) : Container(),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  //nuvei
  Widget _buildNuveiForm() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
        child: Row(
          children: [
            Row(
              children: [
                Radio<String>(
                  value: '1',
                  groupValue: widget.checkoutFormBloc.formData['payzah_transaction_type'],
                  onChanged: (String? value) {
                    setState(() {
                      widget.checkoutFormBloc.formData['payzah_transaction_type'] = '1';
                    });
                  },
                ),
                Text('Knet')
              ],
            ),
            Row(
              children: [
                Radio<String>(
                  value: '2',
                  groupValue: widget.checkoutFormBloc.formData['payzah_transaction_type'],
                  onChanged: (String? value) {
                    setState(() {
                      widget.checkoutFormBloc.formData['payzah_transaction_type'] = '2';
                    });
                  },
                ),
                Text('Credit Card')
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPayzahForm() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
        child: Row(
          children: [
            Row(
              children: [
                Radio<String>(
                  value: '1',
                  groupValue: widget.checkoutFormBloc.formData['payzah_transaction_type'],
                  onChanged: (String? value) {
                    setState(() {
                      widget.checkoutFormBloc.formData['payzah_transaction_type'] = '1';
                    });
                  },
                ),
                Text('Knet')
              ],
            ),
            Row(
              children: [
                Radio<String>(
                  value: '2',
                  groupValue: widget.checkoutFormBloc.formData['payzah_transaction_type'],
                  onChanged: (String? value) {
                    setState(() {
                      widget.checkoutFormBloc.formData['payzah_transaction_type'] = '2';
                    });
                  },
                ),
                Text('Credit Card')
              ],
            )
          ],
        ),
      ),
    );
  }
}

List<String> UPI_Handle = [
"@abfspay",
"@airtel",
"@airtelpaymentsbank",
"@albk",
"@allahabadbank",
"@allbank",
"@andb",
"@apb",
"@apl",
"@axis",
"@axisb",
"@axisbank",
"@axisgo",
"@barodampay",
"@barodapay",
"@boi",
"@cbin",
"@cboi",
"@centralbank",
"@cmsidfc",
"@cnrb",
"@csbcash",
"@csbpay",
"@cub",
"@dbs",
"@dcb",
"@dcbbank",
"@denabank",
"@eazypay",
"@equitas",
"@ezeepay",
"@fbl",
"@federal",
"@finobank",
"@hdfcbank",
"@hsbc",
"@icici",
"@idbi",
"@idbibank",
"@idfc",
"@idfcbank",
"@idfcnetc",
"@ikwik",
"@imobile",
"@indbank",
"@indianbank",
"@indianbk",
"@indus",
"@indusind",
"@iob",
"@jkb",
"@jsbp",
"@karb",
"@karurvysyabank",
"@kaypay",
"@kbl",
"@kbl052",
"@kmb",
"@kmbl",
"@kotak",
"@kvb",
"@kvbank",
"@lvb",
"@lvbank",
"@myicici",
"@obc",
"@okaxis",
"@okhdfcbank",
"@okicici",
"@oksbi",
"@paytm",
"@payzapp",
"@pingpay",
"@pnb",
"@pockets",
"@psb",
"@rajgovhdfcbank",
"@rbl",
"@sbi",
"@sc",
"@scb",
"@scbl",
"@scmobile",
"@sib",
"@srcb",
"@synd",
"@syndbank",
"@syndicate",
"@tjsb",
"@ubi",
"@uboi",
"@uco",
"@unionbank",
"@unionbankofindia",
"@united",
"@upi",
"@utbi",
"@vijayabank",
"@vijb",
"@vjb",
"@ybl",
"@yesbank",
"@yesbankltd",
];
