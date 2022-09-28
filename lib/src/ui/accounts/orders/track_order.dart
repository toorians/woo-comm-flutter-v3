import 'package:app/src/functions.dart';

import './../../../models/app_state_model.dart';
import 'package:flutter/material.dart';
import './../../../models/orders_model.dart';

class TrackOrder extends StatefulWidget {
  final Order order;

  const TrackOrder({Key? key, required this.order}) : super(key: key);
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {

  AppStateModel appStateModel = AppStateModel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: _buildTrack(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: _buildSttaus(),
          ),
        )
      ],
    );
  }

  _buildSttaus() {
    Color color = Colors.green;
    String status = 'Confirmed';
    List<Widget> list = [];
    list.add(timelineStatus(appStateModel.blocks.localeText.ordered));
    if(widget.order.status == 'cancelled' || widget.order.status == 'on-hold' || widget.order.status == 'failed' || widget.order.status == 'refunded' ||  widget.order.status == 'pending') {
      color = Colors.grey;
      status = widget.order.status;
    }
    list.add(timelineStatus(status));
    list.add(timelineStatus(appStateModel.blocks.localeText.processing));
    if(widget.order.status != 'completed') {
      color = Colors.grey;
    }
    list.add(timelineStatus(appStateModel.blocks.localeText.shipped));
    list.add(timelineStatus(appStateModel.blocks.localeText.delivered));
    return list;
  }

  _buildTrack() {
    Color color = Colors.green;
    Color dotColor = Colors.green;
    String status = 'Confirmed';
    List<Widget> list = [];
    list.add(timelineFirstRow(appStateModel.blocks.localeText.ordered));
    if(widget.order.status == 'cancelled' || widget.order.status == 'on-hold' || widget.order.status == 'failed' || widget.order.status == 'refunded' ||  widget.order.status == 'pending') {
      dotColor = _getDotColor(widget.order.status);
      list.add(timelineRow(color, dotColor, widget.order.status));
      color = Colors.grey;
      dotColor = Colors.grey;
    } else {
      list.add(timelineRow(color, dotColor, status));
    }
    list.add(timelineRow(color, dotColor, appStateModel.blocks.localeText.processing));
    if(widget.order.status != 'completed') {
      color = Colors.grey;
      dotColor = Colors.grey;
    }
    if(widget.order.status == 'shipped') {
      color = Colors.green;
      dotColor = Colors.green;
    }
    list.add(timelineRow(color, dotColor, appStateModel.blocks.localeText.shipped));
    if(widget.order.status != 'completed') {
      color = Colors.grey;
      dotColor = Colors.grey;
    }
    list.add(timelineRow(color, dotColor, appStateModel.blocks.localeText.delivered));
    return list;
  }

  Widget timelineFirstRow(String status) {
    final width = MediaQuery.of(context).size.width * .20;
    return Column(
      children: [
        Container(
          height: 18,
          width: width * .3,
          decoration: new BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget timelineRow(Color color, Color dotColor, String status) {
    final width = MediaQuery.of(context).size.width * .20;
    return Expanded(
      child: Container(
       // width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 3,
                decoration: new BoxDecoration(
                  color: color,
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            Container(
              height: 18,
              width: width * .3,
              decoration: new BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timelineStatus(String status) {
   return Expanded(
      child: Text(getOrderStatusText(status, appStateModel.blocks.localeText), textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 12
        ),
      ),
    );
  }

  Color _getDotColor(String status) {
    switch (status) {
      case "on-hold":
        return Colors.amber;
      case "pending":
        return Colors.amber;
      case "refunded":
        return Colors.amber;
      case "cancelled":
        return Color(0xffeba3a3);
      case "failed":
        return Color(0xffeba3a3);
      default:
        return Colors.grey;
    }
  }


}
