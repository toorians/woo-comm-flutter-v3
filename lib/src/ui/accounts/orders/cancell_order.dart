import 'package:app/src/blocs/order_summary_bloc.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/orders_model.dart';
import 'package:app/src/ui/widgets/buttons/button_text.dart';
import 'package:flutter/material.dart';

import '../../color_override.dart';

class CancelOrder extends StatefulWidget {
  final Order order;
  final OrderSummaryBloc orderSummary = OrderSummaryBloc();
  CancelOrder({Key? key, required this.order}) : super(key: key);
  @override
  _CancelOrderState createState() => _CancelOrderState();
}

class _CancelOrderState extends State<CancelOrder> {

  AppStateModel appStateModel = AppStateModel();
  var data = new Map<String, String>();
  bool loading = false;

  @override
  void initState() {
    data['action'] = 'pi_cancellation_request';
    data['order_id'] = widget.order.id.toString();
    data['order_cancel_reason'] = '';
    data['order_key'] = widget.order.orderKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appStateModel.blocks.localeText.cancel),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: PrimaryColorOverride(
                          child: TextFormField(
                            maxLength: 1000,
                            maxLines: 8,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              labelText: appStateModel.blocks.localeText.requestReason,
                              errorMaxLines: 1,
                            ),
                            onChanged: (value) {
                              data['order_cancel_reason'] = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      child: ButtonText(isLoading: loading, text: appStateModel.blocks.localeText.submit),
                      onPressed: () => _submitCancelRequest(context),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _submitCancelRequest(BuildContext context) async {
    setState(() {
      loading = true;
    });
    bool status = await widget.orderSummary.submitCancelRequest(data, context);
    setState(() {
      loading = false;
    });
    if(status) {
      final snackBar = SnackBar(
        content: Text(appStateModel.blocks.localeText.yourRequestSubmitted + ' #' + widget.order.number),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pop();
    }
  }
}
