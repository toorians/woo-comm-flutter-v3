import '../../../../src/blocs/downloads_bloc.dart';
import '../../../../src/models/downloads_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/app_state_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';


class DownloadsPage extends StatefulWidget {
  AppStateModel appStateModel = AppStateModel();

  final downloadsBloc = DownloadsBloc();
  DownloadsPage({Key? key}) : super(key: key);
  @override
  _DownloadsPageState createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    widget.downloadsBloc.getDownloads();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(widget.appStateModel.blocks.localeText.downloads  ),
      ),
      body: StreamBuilder(
          stream: widget.downloadsBloc.allDownloads,
          builder: (context, AsyncSnapshot<List<DownloadsModel>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.length == 0) {
                return Center(
                    child:
                        Text(widget.appStateModel.blocks.localeText.no + ' ' + widget.appStateModel.blocks.localeText.downloads));
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

  buildList(AsyncSnapshot<List<DownloadsModel>> snapshot) {
    var formatter1 = new DateFormat('yyyy-MM-dd  hh:mm a');
    return SliverPadding(
      padding: EdgeInsets.all(0.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  ListTile(
                      tileColor: Theme.of(context).cardColor,
                      contentPadding: EdgeInsets.all(16),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(snapshot.data![index].productName),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 4),
                          Text(snapshot.data![index].downloadName),
                          SizedBox(height: 4),
                          Text('Expires - ' + formatter1.format(snapshot.data![index].accessExpires)),
                          SizedBox(height: 4),
                          SizedBox(height: 4),
                          Text('Download remaining - ' + snapshot.data![index].downloadsRemaining),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () async => await canLaunch(snapshot.data![index].downloadUrl) ? await launch(snapshot.data![index].downloadUrl) : throw 'Could not launch $snapshot.data[index].downloadUrl',
                                icon: Icon(Icons.download_rounded),
                              )
                            ],
                          ),
                        ],
                      )),
                  Divider(height: 0)
                ],
              ),
            );
          },
          childCount: snapshot.data!.length,
        ),
      ),
    );
  }
}
