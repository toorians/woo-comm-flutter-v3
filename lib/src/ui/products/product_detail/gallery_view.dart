import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import './../../../models/product_model.dart';

class GalleryView extends StatefulWidget {
  final List<Mage> images;

  const GalleryView({Key? key, required this.images}) : super(key: key);
  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  @override
  Widget build(BuildContext context) {

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Theme(
        data: Theme.of(context).copyWith(
            appBarTheme: AppBarTheme(
              color: Colors.black,
              iconTheme: Theme.of(context).primaryIconTheme.copyWith(
                  color: Colors.white
              )
            ),
        ),
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            brightness: Brightness.dark,
          ),
          body: Stack(
            children: [
              Container(
                  child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(widget.images[index].src),
                        initialScale: PhotoViewComputedScale.contained * 0.8,
                        //heroAttributes: HeroAttributes(tag: images[index].id),
                      );
                    },
                    itemCount: widget.images.length,
                    loadingBuilder: (context, event) => Center(
                      child: Container(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          value: event == null
                              ? 0
                              : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                        ),
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
