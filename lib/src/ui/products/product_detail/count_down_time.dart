import 'dart:async';
import 'package:flutter/material.dart';

class CountDownTime extends StatefulWidget {
  final DateTime saleEndDate;
  const CountDownTime({Key? key, required this.saleEndDate}) : super(key: key);
  @override
  _CountDownTimeState createState() => _CountDownTimeState();
}

class _CountDownTimeState extends State<CountDownTime> {

  var dateFrom;
  var difference;
  var boxWidth = 28.0;

  @override
  void initState() {
    dateFrom = DateTime.now();
    difference = widget.saleEndDate.difference(dateFrom).inSeconds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.bodyText1!.copyWith();
    Color boxColor = Theme.of(context).primaryColorLight;
    return !difference.isNegative ? SliverToBoxAdapter(
      child: Countdown(
        duration: Duration(seconds: difference),
    builder: (BuildContext ctx, Duration remaining) {
        return Container(
          height: 30,
          width: MediaQuery.of(context).size.width,
          color: Colors.pinkAccent.withOpacity(.1) ,
          child: Center(
            child: Text(
                'Time Left: ${remaining.inDays.clamp(0, 99)}d:${remaining.inHours.clamp(0, 99)}h:${remaining.inMinutes.remainder(60)}m:${remaining.inSeconds.remainder(60)}s',
                style: TextStyle(
                    fontWeight: FontWeight.w500
                )
            ),
          ),
        );
      })
    ) : SliverToBoxAdapter();
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

