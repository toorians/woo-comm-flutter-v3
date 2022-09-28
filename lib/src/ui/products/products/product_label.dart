import 'package:flutter/material.dart';
import '../../../models/app_state_model.dart';

class ProductLabel extends StatelessWidget {
  ProductLabel(this.tags);
  final List<String> tags;
  @override
  Widget build(BuildContext context) {

    List<String> output = tags.where((element) => AppStateModel().blocks.settings.labels.contains(element.toString())).toList();
    return output.length > 0 ? Row(
      children: [
        Container(
          height: 15,
          padding: const EdgeInsets.all(2.0),
          color: Colors.pink.withOpacity(.6),
          child: Text(output[0],
            style: TextStyle(
              fontSize: 9,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          child: Stack(
            children: [
              ClipPath(
                clipper: RectangleClipper(),
                child: Container(
                  height: 15,
                  width: 10,
                  color: Colors.pink.withOpacity(.5),
                ),
              ),
              ClipPath(
                clipper: TriangleClipper(),
                child: Container(
                  height: 15,
                  width: 10,
                  color: Colors.pink.withOpacity(.2),
                ),
              )
            ],
          ),
        ),
      ],
    ) : Container();
  }
}


class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width/2, size.height/2);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
class RectangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height/2);
    path.lineTo(size.width , size.height);
    path.lineTo(0 , size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(RectangleClipper oldClipper) => false;
}