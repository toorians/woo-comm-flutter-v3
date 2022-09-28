import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/ui/accounts/account/account.dart';
import 'package:app/src/ui/accounts/login/login.dart';
import 'package:app/src/ui/accounts/wallet.dart';
import 'package:app/src/ui/accounts/wishlist.dart';
import 'package:app/src/ui/categories/categories.dart';
import 'package:app/src/ui/checkout/cart/cart4.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ShapeIcons extends StatelessWidget {

  const ShapeIcons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
        return SliverToBoxAdapter(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: new Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Account()));
                            },
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    new ClipPath(
                                      clipper: new CustomTopHalfCircleClipper(),
                                      child: new Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: new BoxDecoration(color: Colors.blue.withOpacity(0.8), borderRadius: BorderRadius.circular(25.0) ),
                                      ),
                                    ),
                                    ClipPath(
                                      clipper: new CustomBottomHalfCircleClipper(),
                                      child: new Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: new BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(25.0) ),
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: Icon(
                                        Icons.account_circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8,),
                                Text(model.blocks.localeText.account, style: Theme.of(context).textTheme.caption)
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: new Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Categories()));
                            },
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    new ClipPath(
                                      clipper: new CustomTopHalfCircleClipper(),
                                      child: new Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: new BoxDecoration(color: Colors.red.withOpacity(0.8), borderRadius: BorderRadius.circular(25.0) ),
                                      ),
                                    ),
                                    ClipPath(
                                      clipper: new CustomBottomHalfCircleClipper(),
                                      child: new Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: new BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(25.0) ),
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: Icon(
                                        Icons.view_list,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8,),
                                Text(model.blocks.localeText.category, style: Theme.of(context).textTheme.caption)
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: new Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (AppStateModel().user.id > 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WishList()));
                              } else Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    new ClipPath(
                                      clipper: new CustomTopHalfCircleClipper(),
                                      child: new Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: new BoxDecoration(color: Colors.green.withOpacity(0.8), borderRadius: BorderRadius.circular(25.0) ),
                                      ),
                                    ),
                                    ClipPath(
                                      clipper: new CustomBottomHalfCircleClipper(),
                                      child: new Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: new BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(25.0) ),
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8,),
                                Text(model.blocks.localeText.wishlist, style: Theme.of(context).textTheme.caption)
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: new Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CartPage()));
                            },
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    new ClipPath(
                                      clipper: new CustomTopHalfCircleClipper(),
                                      child: new Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: new BoxDecoration(color: Colors.orange.withOpacity(0.8), borderRadius: BorderRadius.circular(25.0) ),
                                      ),
                                    ),
                                    ClipPath(
                                      clipper: new CustomBottomHalfCircleClipper(),
                                      child: new Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: new BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(25.0) ),
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: Icon(
                                        Icons.shopping_basket,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(model.blocks.localeText.cart, style: Theme.of(context).textTheme.caption)
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: new Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (AppStateModel().user.id > 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Wallet()));
                              } else Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    new ClipPath(
                                      clipper: new CustomTopHalfCircleClipper(),
                                      child: new Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: new BoxDecoration(color: Colors.purple.withOpacity(0.8), borderRadius: BorderRadius.circular(25.0) ),
                                      ),
                                    ),
                                    ClipPath(
                                      clipper: new CustomBottomHalfCircleClipper(),
                                      child: new Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: new BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(25.0) ),
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: Icon(
                                        Icons.wallet,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(model.blocks.localeText.wallet, style: Theme.of(context).textTheme.caption)
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class CustomTopHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = new Path();
    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CustomBottomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = new Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height /2);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}