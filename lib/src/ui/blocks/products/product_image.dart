import 'package:app/src/app.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductCachedImage extends StatelessWidget {
  final String imageUrl;
  const ProductCachedImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
      errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
      fit: AppStateModel().blocks.settings.productSettings.imageFit,
    );
  }
}
