import 'package:app/src/models/app_state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductRating extends StatelessWidget {
  const ProductRating({
    Key? key,
    required this.averageRating,
    required this.ratingCount,
  }) : super(key: key);

  final String averageRating;
  final int ratingCount;

  @override
  Widget build(BuildContext context) {
    return AppStateModel().blocks.settings.productRatings ? Column(
      children: [
        Row(
          children: [
            RatingBar.builder(
              initialRating: double.parse(averageRating),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              ignoreGestures: true,
              itemCount: 5,
              itemSize: 12,
              itemPadding:
              EdgeInsets.symmetric(horizontal: 0.0),
              unratedColor: Theme.of(context).textTheme.caption!.color!.withOpacity(0.3),
              onRatingUpdate: (value) {},
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
                size: 4,
              ),
            ),
            if(ratingCount > 0)
              Text( ' ' + ratingCount.toString() + ' ' + AppStateModel().blocks.localeText.reviews, style: Theme.of(context).textTheme.caption),
          ],
        ),
        SizedBox(height: 8),
      ],
    ) : Container();
  }
}
