import 'package:app/src/blocs/blocks_bloc.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/blocks_model.dart';
import 'package:app/src/ui/blocks/blocks.dart';
import 'package:flutter/material.dart';

class BlockPage extends StatefulWidget {
  final Child child;
  final blocksBloc = BlocksBloc();

  BlockPage({Key? key, required this.child}) : super(key: key);
  @override
  _BlockPageState createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {

  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    widget.blocksBloc.getBlocks(widget.child.linkId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.child.title),
      ),
      body: StreamBuilder<List<Block>>(
        stream: widget.blocksBloc.allBlocks,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.length > 0) {
            return CustomScrollView(
              slivers: [
                for (var i = 0; i < snapshot.data!.length; i++)
                  SliverBlock(block: snapshot.data![i]),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}




