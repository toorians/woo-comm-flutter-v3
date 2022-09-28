import 'package:app/src/models/app_state_model.dart';

import './../../../blocs/order_summary_bloc.dart';
import './../../../models/orders_model.dart';
import 'package:flutter/material.dart';
import '../../color_override.dart';
import './../../../ui/widgets/buttons/button_text.dart';

class RefundOrder extends StatefulWidget {
  final Order order;
  final OrderSummaryBloc orderSummary = OrderSummaryBloc();
  RefundOrder({Key? key, required this.order}) : super(key: key);
  @override
  _RefundOrderState createState() => _RefundOrderState();
}

class _RefundOrderState extends State<RefundOrder> {

  var data = new Map<String, String>();
  List<String> refundType = ['full', 'partial'];
  bool loading = false;
  List<RefundItem> refundItem = List<RefundItem>.generate(30, (index) => RefundItem(), growable: true);
  final _formKey = GlobalKey<FormState>();
  AppStateModel model = AppStateModel();

  @override
  void initState() {
    data['action'] = 'wcfm_ajax_controller';
    data['controller'] = 'wcfm-refund-requests-form';
    data['wcfm_refund_request'] = 'full';
    data['wcfm_refund_reason'] = '';
    data['wcfm_refund_order_id'] = widget.order.id.toString();
    data['wcfm_ajax_nonce'] = model.blocks.nonce.wcfmAjaxNonce;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(model.blocks.localeText.refund),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: ListView(
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.blocks.localeText.type,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      DropdownButton<String>(
                        value: data['wcfm_refund_request'],
                        iconSize: 24,
                        elevation: 16,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          if(newValue != null)
                          setState(() {
                            data['wcfm_refund_request'] = newValue;
                          });
                        },
                        items: refundType.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.capitalize()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  data['wcfm_refund_request'] == 'partial' ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.order.lineItems.length, itemBuilder: (context,index){
                    return  Container(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.order.lineItems[index].name, style: Theme.of(context).textTheme.subtitle2,),
                          Container(
                              child: PrimaryColorOverride(
                                child: PrimaryColorOverride(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value != null && value.isNotEmpty && int.parse(value) > widget.order.lineItems[index].quantity) {
                                        return model.blocks.localeText.valueNotMoreThan + ' ' + widget.order.lineItems[index].quantity.toString();
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: model.blocks.localeText.qty,
                                        suffix: Text(widget.order.lineItems[index].quantity.toString())
                                    ),
                                    keyboardType: TextInputType.number,
                                    onSaved: (value) {
                                      if(value != null) {
                                        refundItem[index].id = widget.order.lineItems[index].id.toString();
                                        refundItem[index].qty = value;
                                      }
                                    },
                                  ),
                                ),
                              ),
                          ),
                          Container(
                            child: PrimaryColorOverride(
                              child: PrimaryColorOverride(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty && double.parse(value) > double.parse(widget.order.lineItems[index].total)) {
                                      return model.blocks.localeText.valueNotMoreThan + ' ' + widget.order.lineItems[index].total;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      suffix: Text(widget.order.lineItems[index].total.toString()),
                                      labelText: model.blocks.localeText.amount
                                  ),
                                  keyboardType: TextInputType.number,
                                  onSaved: (value) {
                                    refundItem[index].total = value.toString();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }) : Container(),
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
                                labelText: model.blocks.localeText.requestReason,
                                errorMaxLines: 1,
                              ),
                              onSaved: (value) {
                                if(value != null)
                                data['wcfm_refund_reason'] = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return model.blocks.localeText.requestReason + ' ' + model.blocks.localeText.isRequired;
                                }
                                return null;
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
                        child: ButtonText(isLoading: loading, text: model.blocks.localeText.submit),
                        onPressed: () {
                          if(_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _submitSupportRequest(context);
                          }
                        }
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _submitSupportRequest(BuildContext context) async {
    data['wcfm_refund_requests_form'] = getQueryString(data);
    if(refundItem.isEmpty && data['wcfm_refund_request'] != 'full') {
      final snackBar = SnackBar(
        content: Text('Please enter details'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if(data['wcfm_refund_request'] == 'full') {
        String str = '';
        widget.order.lineItems.forEach((element) {
          str = str + '&wcfm_refund_input%5B' + element.id.toString() + '%5D%5Bqty%5D=';
          str = str + '&wcfm_refund_input%5B' + element.id.toString() + '%5D%5Bitem%5D=' + element.id.toString();
          str = str + '&wcfm_refund_input%5B' + element.id.toString() + '%5D%5Btotal%5D=';
          data['wcfm_refund_requests_form'] = 'wcfm_refund_request=full&wcfm_refund_reason=' + data['wcfm_refund_reason']! + '&wcfm_refund_order_id=' + data['wcfm_refund_order_id']! + str;
        });
      } else {
        if(refundItem.isNotEmpty) {
          String str = '';
          refundItem.forEach((element) {
            if(element.id != null && element.qty != null) {
              str = str + '&wcfm_refund_input%5B' + element.id.toString() + '%5D%5Bqty%5D=' + element.qty;
              str = str + '&wcfm_refund_input%5B' + element.id.toString() + '%5D%5Bitem%5D=' + element.id;
              str = str + '&wcfm_refund_input%5B' + element.id.toString() + '%5D%5Btotal%5D=' + element.total;
              data['wcfm_refund_requests_form'] = 'wcfm_refund_request=partial&wcfm_refund_reason=' + data['wcfm_refund_reason']! + '&wcfm_refund_order_id=' + data['wcfm_refund_order_id']! + str;
            }
          });
        }
      }
      setState(() {
        loading = true;
      });
      StatusModel status = await widget.orderSummary.submitRefundRequest(data);
      setState(() {
        loading = false;
      });
      data.remove('wcfm_refund_requests_form');
      if (status.message != null) {
        final snackBar = SnackBar(
          content: Text(status.message),
          backgroundColor: status.status ? Colors.green : Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      if(status.status) {
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(context).pop();
      }
    }
  }
}

class RefundItem {
  late String id;
  late String qty;
  late String total;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}