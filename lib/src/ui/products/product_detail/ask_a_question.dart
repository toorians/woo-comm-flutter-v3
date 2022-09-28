import 'package:app/src/models/app_state_model.dart';
import 'package:flutter/material.dart';
import './../../../resources/api_provider.dart';
import './../../../blocs/order_summary_bloc.dart';
import './../../../models/orders_model.dart';
import '../../color_override.dart';
import './../../../ui/widgets/buttons/button_text.dart';

class AskAQuestion extends StatefulWidget {
  final String productId;
  final String vendorId;
  AskAQuestion({Key? key, required this.productId, required this.vendorId}) : super(key: key);
  @override
  _AskAQuestionState createState() => _AskAQuestionState();
}

class _AskAQuestionState extends State<AskAQuestion> {
  var data = new Map<String, String>();
  bool loading = false;

  AppStateModel model = AppStateModel();

  @override
  void initState() {
    data['action'] = 'wcfm_ajax_controller';
    data['controller'] = 'wcfm-enquiry-tab';
    data['status'] = 'submit';
    data['product_id'] = widget.productId;
    data['vendor_id'] = widget.vendorId;
    data['wcfm_nonce'] = model.blocks.nonce.wcfmEnquiry;
    data['wcfm_ajax_nonce'] = model.blocks.nonce.wcfmAjaxNonce;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.blocks.localeText.askAQuestion),
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
                if(model.user.id == 0)
                  Column(
                    children: [
                      PrimaryColorOverride(
                        child: TextFormField(
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: model.blocks.localeText.name,
                            errorMaxLines: 1,
                          ),
                          onChanged: (value) {
                            data['customer_name'] = value;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      PrimaryColorOverride(
                        child: TextFormField(
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: model.blocks.localeText.email,
                            errorMaxLines: 1,
                          ),
                          onChanged: (value) {
                            data['customer_email'] = value;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                PrimaryColorOverride(
                  child: TextFormField(
                    maxLength: 1000,
                    maxLines: 8,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: model.blocks.localeText.askAQuestion,
                      errorMaxLines: 1,
                    ),
                    onChanged: (value) {
                      data['enquiry'] = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                    child: ButtonText(isLoading: loading, text: model.blocks.localeText.submit),
                    onPressed: () {
                      _submitSupportRequest(context);
                    }
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _submitSupportRequest(BuildContext context) async {
      data['wcfm_enquiry_tab_form'] = getQueryString(data);
      setState(() {
        loading = true;
      });
      final response = await ApiProvider().adminAjax(data);
      StatusModel status = statusModelFromJson(response.body);
      if (status.message.isNotEmpty) {
        final snackBar = SnackBar(
          content: Text(status.message),
          backgroundColor: status.status ? Colors.green : Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      setState(() {
        loading = false;
      });
      if(status.status) {
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(context).pop();
      }
    }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}