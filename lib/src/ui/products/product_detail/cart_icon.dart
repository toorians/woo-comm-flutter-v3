import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/src/ui/checkout/cart/cart4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            CupertinoIcons.bag,
            semanticLabel: 'Cart',
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => CartPage(),
                ));
          },
        ),
        Positioned(
          top: 2,
          right: 2.0,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => CartPage(),
                  ));
            },
            child: context.select((ShoppingCart c) => c.count) != 0 ? Card(
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                shape: StadiumBorder(),
                color: Colors.red,
                child: Container(
                    padding: EdgeInsets.all(2),
                    constraints: BoxConstraints(minWidth: 20.0),
                    child: Center(
                        child: Text(
                          context.read<ShoppingCart>().count.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                        )))) : Container(),
          ),
        )
      ],
    );
  }
}