import 'package:app/src/blocs/reward_points_bloc.dart';
import 'package:app/src/functions.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/reward_points.dart';
import 'package:flex_color_scheme/src/flex_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RewardPoints extends StatefulWidget {
  final rewardPointsBloc = RewardPointsBloc();
  @override
  State<RewardPoints> createState() => _RewardPointsState();
}

class _RewardPointsState extends State<RewardPoints> {

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    widget.rewardPointsBloc.getRewardPoints();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.rewardPointsBloc.loadMoreRewardPoints();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RewardPointsModel>(
        stream: widget.rewardPointsBloc.RewardPointsData,
        builder: (context, AsyncSnapshot<RewardPointsModel> snapshot) {
          return snapshot.hasData && snapshot.data != null ? Scaffold(
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  leading: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarBrightness: Theme.of(context).colorScheme.primary.isDark ? Brightness.dark : Brightness.light,
                  ),
                  pinned: true,
                  snap: false,
                  floating: false,
                  expandedHeight: 120.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(AppStateModel().blocks.localeText.total + ' ' +
                        snapshot.data!.points.toString()),
                    background: buildAccountBackground2(),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context,
                      int index) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.all(16),
                          trailing: Text(snapshot.data!.items[index].points,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline6),
                          title: Text(parseHtmlString(snapshot.data!.items[index]
                              .description)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(snapshot.data!.items[index].dateDisplay),
                              SizedBox(height: 4),
                              Text(snapshot.data!.items[index].type.toUpperCase()),
                            ],
                          ),//Text(snapshot.data!.items[index].dateDisplay),
                        ),
                        Divider(height: 0,)
                      ],
                    );
                  },
                    childCount: snapshot.data!.items.length,
                  ),
                )
              ],
            ),
          ) : Scaffold(appBar: AppBar(),
              body: Center(child: CircularProgressIndicator()));
        }
    );
  }

  Widget buildAccountBackground2() {
    return Stack(
      children: [
        Positioned(
          top: 10,
          left: 80,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme
                  .of(context)
                  .primaryColorLight
                  .withOpacity(0.3),
            ),
            height: 60,
            width: 60,
          ),
        ),
        Positioned(
          top: 0,
          left: -5,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme
                  .of(context)
                  .primaryColorLight
                  .withOpacity(0.3),
            ),
            height: 35,
            width: 90,
          ),
        ),
        Positioned(
          bottom: 62,
          right: -40,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme
                  .of(context)
                  .primaryColorLight
                  .withOpacity(0.3),
            ),
            height: 100,
            width: 100,
          ),
        ),
        Positioned(
          bottom: -40,
          right: 60,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme
                  .of(context)
                  .primaryColorLight
                  .withOpacity(0.3),
            ),
            height: 80,
            width: 80,
          ),
        )
      ],
    );
  }
}

