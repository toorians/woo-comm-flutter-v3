import 'package:app/src/models/app_state_model.dart';

import './../../../blocs/order_summary_bloc.dart';
import './../../../models/orders_model.dart';
import 'package:flutter/material.dart';
import '../../color_override.dart';
import './../../../ui/widgets/buttons/button_text.dart';

class SupportOrder extends StatefulWidget {
  final Order order;
  final OrderSummaryBloc orderSummary = OrderSummaryBloc();
  SupportOrder({Key? key, required this.order}) : super(key: key);
  @override
  _SupportOrderState createState() => _SupportOrderState();
}

class _SupportOrderState extends State<SupportOrder> {
  var data = new Map<String, String>();
  AppStateModel model = AppStateModel();
  //'General query', 'Suggestion', 'Delivery issue', 'Damage item received', 'Wrong item received'
  //<String>['normal', 'low', 'medium', 'high', 'urgent', 'critical']
  List<String> supportReasons = [];
  List<String> priority = [];
  bool loading = false;


  @override
  void initState() {
    supportReasons = [
      model.blocks.localeText.generalQuery,
      model.blocks.localeText.suggestion,
      model.blocks.localeText.deliveryIssue,
      model.blocks.localeText.damageItemReceived,
      model.blocks.localeText.wrongItemReceived,
    ];
    priority = [
      model.blocks.localeText.normal,
      model.blocks.localeText.low,
      model.blocks.localeText.medium,
      model.blocks.localeText.high,
      model.blocks.localeText.urgent,
      model.blocks.localeText.critical,
    ];
    data['action'] = 'wcfm_ajax_controller';
    data['controller'] = 'wcfm-support-form';
    data['wcfm_support_category'] = '0';
    data['wcfm_support_priority'] = 'normal';
    data['wcfm_support_product'] = widget.order.lineItems.first.id.toString();
    data['wcfm_support_query'] = '';
    data['wcfm_support_order_id'] = widget.order.id.toString();
    data['wcfm_ajax_nonce'] = model.blocks.nonce.wcfmAjaxNonce;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.blocks.localeText.support),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0 , 0),
            child: ListView(
              children: [
                SizedBox(
                  height: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.blocks.localeText.category,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    DropdownButton<String>(
                      value: data['wcfm_support_category'],
                      iconSize: 24,
                      elevation: 16,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if(newValue != null)
                        setState(() {
                          data['wcfm_support_category'] = newValue;
                        });
                      },
                      items: supportReasons.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: supportReasons.indexOf(value).toString(),
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.blocks.localeText.priority,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    DropdownButton<String>(
                      value: data['wcfm_support_priority'],
                      iconSize: 24,
                      elevation: 16,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if(newValue != null)
                        setState(() {
                          data['wcfm_support_priority'] = newValue;
                        });
                      },
                      items: priority.map<DropdownMenuItem<String>>((String value) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.blocks.localeText.product,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    DropdownButton<String>(
                      value: data['wcfm_support_product'],
                      iconSize: 24,
                      elevation: 16,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if(newValue != null)
                        setState(() {
                          data['wcfm_support_product'] = newValue;
                        });
                      },
                      items: widget.order.lineItems
                          .map<DropdownMenuItem<String>>((LineItem value) {
                        return DropdownMenuItem<String>(
                          value: value.id.toString(),
                          child: Text(value.name),
                        );
                      }).toList(),
                    ),
                  ],
                ),
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
                              labelText: model.blocks.localeText.message,
                              errorMaxLines: 1,
                            ),
                            onChanged: (value) {
                              data['wcfm_support_query'] = value;
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
                        _submitSupportRequest(context);
                        Navigator.of(context).pop();
                      }
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

  _submitSupportRequest(BuildContext context) async {
    data['wcfm_support_form'] = getQueryString(data);
    setState(() {
      loading = true;
    });
    StatusModel status = await widget.orderSummary.submitSupportRequest(data);
    setState(() {
      loading = false;
    });
    data.remove('wcfm_support_form');
    if (status.message.isNotEmpty) {
      final snackBar = SnackBar(
        content: Text(status.message),
        backgroundColor: status.status ? Colors.green : Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}