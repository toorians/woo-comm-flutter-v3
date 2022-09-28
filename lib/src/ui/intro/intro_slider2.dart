import 'package:flex_color_scheme/src/flex_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_slider/intro_slider.dart';

class IntroScreen2 extends StatefulWidget {
  final Function onFinish;
  IntroScreen2({Key? key, required this.onFinish}) : super(key: key);

  @override
  IntroScreen2State createState() => new IntroScreen2State();
}

class IntroScreen2State extends State<IntroScreen2> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();
  }

  void onDonePress() {
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).colorScheme.primary.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: new IntroSlider(
        backgroundColorAllSlides: Theme.of(context).colorScheme.primary,
        colorDot: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
        colorActiveDot: Theme.of(context).colorScheme.onPrimary,
        slides: [
          Slide(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: "Online Shopping",
            styleTitle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
            description:
            "Shop Electronics, Mobile, Men Clothing, Women Clothing, Home appliances & Kitchen appliances online now.",
            styleDescription: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20.0,
                fontStyle: FontStyle.italic),
            pathImage: "assets/images/intro/intro1.png",
          ),
          Slide(
            title: "Get best offers always",
            backgroundColor: Theme.of(context).colorScheme.primary,
            styleTitle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
            description:
            "Avail offers on most products. Get Great Offers, Discounts and Deals",
            styleDescription: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20.0,
                fontStyle: FontStyle.italic),
            pathImage: "assets/images/intro/intro2.png",
          ),
          Slide(
            title: "Handpicked Products",
            backgroundColor: Theme.of(context).colorScheme.primary,
            styleTitle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
            description:
            "Handpicked products at a discounted price. Save on wide range of categories",
            styleDescription: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20.0,
                fontStyle: FontStyle.italic),
            pathImage: "assets/images/intro/intro3.png",
          )
        ],
        onDonePress: this.onDonePress,
      ),
    );
  }
}