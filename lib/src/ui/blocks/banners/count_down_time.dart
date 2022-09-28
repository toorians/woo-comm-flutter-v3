import 'dart:async';
import './../../../models/blocks_model.dart';
import 'package:flutter/material.dart';

class CountDownTime extends StatefulWidget {
  final String saleEndDate;
  final Block block;
  const CountDownTime({Key? key, required this.saleEndDate, required this.block}) : super(key: key);
  @override
  _CountDownTimeState createState() => _CountDownTimeState();
}

class _CountDownTimeState extends State<CountDownTime> {

  var dateTo;
  var dateFrom;
  var difference;
  var boxWidth = 28.0;

  @override
  void initState() {
    dateTo = DateTime.parse(widget.saleEndDate);
    dateFrom = DateTime.now();
    difference = dateTo.difference(dateFrom).inSeconds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    TextStyle titleStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
        color: isDark ? Colors.black : widget.block.backgroundColor
    );
    Color boxColor = isDark ? Colors.white : widget.block.titleColor;
    return !difference.isNegative ? Countdown(
      duration: Duration(seconds: difference),
      builder: (BuildContext ctx, Duration remaining) {
        return Row(
            children: [
              Container(
                width: boxWidth,
                height: boxWidth,
                decoration: new BoxDecoration(
                    color: boxColor,
                    borderRadius:
                    new BorderRadius.all(Radius.circular(2.0))),
                margin: EdgeInsets.all(4),
                child: Center(
                    child: Text('${remaining.inHours.clamp(0, 99)}',
                        maxLines: 1,
                        style: titleStyle)),
              ),
              Container(
                width: boxWidth,
                height: boxWidth,
                margin: EdgeInsets.all(4),
                decoration: new BoxDecoration(
                    color: boxColor,
                    borderRadius:
                    new BorderRadius.all(Radius.circular(2.0))),
                child: Center(
                    child: Text(
                        '${remaining.inMinutes.remainder(60)}',
                        style: titleStyle)),
              ),
              Container(
                width: boxWidth,
                height: boxWidth,
                decoration: new BoxDecoration(
                    color: boxColor,
                    borderRadius:
                    new BorderRadius.all(Radius.circular(2.0))),
                margin: EdgeInsets.all(4),
                child: Center(
                    child: Text(
                        '${remaining.inSeconds.remainder(60)}',
                        style: titleStyle)),
              ),
            ]);
      },
    ) : Container();
  }
}

class Countdown extends StatefulWidget {
  const Countdown({
    Key? key,
    required this.duration,
    required this.builder,
    this.onFinish,
    this.interval = const Duration(seconds: 1),
  }) : super(key: key);

  final Duration duration;
  final Duration interval;
  final void Function()? onFinish;
  final Widget Function(BuildContext context, Duration remaining) builder;
  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer? _timer;
  late Duration _duration;
  @override
  void initState() {
    _duration = widget.duration;
    startTimer();

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(widget.interval, timerCallback);
  }

  void timerCallback(Timer timer) {
    setState(() {
      if (_duration.inSeconds == 0) {
        timer.cancel();
        if (widget.onFinish != null) widget.onFinish!();
      } else {
        _duration = Duration(seconds: _duration.inSeconds - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _duration);
  }
}

class CountdownFormatted extends StatelessWidget {
  const CountdownFormatted({
    Key? key,
    required this.duration,
    required this.builder,
    this.onFinish,
    this.interval = const Duration(seconds: 1),
    this.formatter,
  }) : super(key: key);

  final Duration duration;
  final Duration interval;
  final void Function()? onFinish;

  /// An function to format the remaining time
  final String Function(Duration)? formatter;

  final Widget Function(BuildContext context, String remaining) builder;

  Function(Duration) _formatter() {
    if (formatter != null) return formatter!;
    if (duration.inHours >= 1) return formatByHours;
    if (duration.inMinutes >= 1) return formatByMinutes;

    return formatBySeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Countdown(
      interval: interval,
      onFinish: onFinish,
      duration: duration,
      builder: (BuildContext ctx, Duration remaining) {
        return builder(ctx, _formatter()(remaining));
      },
    );
  }
}

String twoDigits(int n) {
  if (n >= 10) return '$n';
  return '0$n';
}

String formatBySeconds(Duration duration) =>
    twoDigits(duration.inSeconds.remainder(60));

String formatByMinutes(Duration duration) {
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return '$twoDigitMinutes:${formatBySeconds(duration)}';
}

String formatByHours(Duration duration) {
  return '${twoDigits(duration.inHours)}:${formatByMinutes(duration)}';
}

