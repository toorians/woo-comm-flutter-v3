import '../../pages/webview.dart';
import './../../../models/app_state_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import './../../../blocs/order_notes_bloc.dart';
import './../../../models/order_notes_model.dart';
import './../../../models/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:html/dom.dart' as dom;

class OrderNotes extends StatefulWidget {
  final Order order;
  final orderNotes = OrderNotesBloc();
  OrderNotes({Key? key, required this.order}) : super(key: key);
  @override
  _OrderNotesState createState() => _OrderNotesState();
}

class _OrderNotesState extends State<OrderNotes> {
  ScrollController _scrollController = new ScrollController();
  AppStateModel appStateModel = AppStateModel();
  bool hasMoreOrders = false;

  @override
  void initState() {
    widget.orderNotes.orderId = widget.order.id.toString();
    widget.orderNotes.filter['type'] = 'customer';
    widget.orderNotes.fetchItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.orderNotes.fetchItems();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appStateModel.blocks.localeText.orderNote),
      ),
      body: StreamBuilder(
          stream: widget.orderNotes.allNotes,
          builder: (context, AsyncSnapshot<List<OrderNote>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.length == 0) {
                return Center(child: Container());
              } else {
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    buildList(snapshot),
                  ],
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  buildList(AsyncSnapshot<List<OrderNote>> snapshot) {
    var formatter1 = new DateFormat('yyyy-MM-dd  hh:mm a');
    return SliverPadding(
      padding: EdgeInsets.all(0.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
              padding: const EdgeInsets.all(0.0),
              child: Card(
                  elevation: 0.5,
                  margin: EdgeInsets.all(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    ListTile(
                        title: Container(
                            child: Html(
                              data: snapshot.data![index].note,
                                onLinkTap: (String? url, RenderContext renderContext, Map<String, String> attributes, dom.Element? element) {
                                  //TODO ADD Whatsapp lancunc if url contains https://wa.me
                                  if(url != null)
                                    _launchUrl(url, context);
                                },
                                onImageTap: (String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) {
                                  //print(url);
                                }
                            ),//Text(parseHtmlString(snapshot.data[index].note))
                        ),
                        subtitle: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(formatter1.format(snapshot.data![index].dateCreated)),
                            ],
                          ),
                        )),
                  )),
            );
          },
          childCount: snapshot.data!.length,
        ),
      ),
    );
  }

  void _launchUrl(String url, BuildContext context) {
    if(url.contains('https://wa.me/') || url.contains('mailto:') || url.contains('sms:') || url.contains('tel:') || url.contains('https://m.me/')) {
      launchUrl(Uri.parse(url));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WebViewPage(url: url)));
    }
  }
}
