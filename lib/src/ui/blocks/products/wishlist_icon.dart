import 'dart:convert';

import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/resources/api_provider.dart';
import 'package:app/src/ui/accounts/login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class WishListIconPositioned extends StatefulWidget {
  final int id;
  const WishListIconPositioned({Key? key, required this.id}) : super(key: key);

  @override
  State<WishListIconPositioned> createState() => _WishListIconPositionedState();
}

class _WishListIconPositionedState extends State<WishListIconPositioned> {
  @override
  Widget build(BuildContext context) {
    return AppStateModel().blocks.settings.wishlist ? Positioned(
      top: 0.0,
      right: 0.0,
      child: IconButton(
          icon: context.watch<Favourites>().wishListIds.contains(widget.id) ? Icon(Icons.favorite, color: Theme.of(context).colorScheme.secondary) :
          Icon(Icons.favorite_border, color: Colors.black87),
          onPressed: () {
            if (AppStateModel().user.id == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Login()));
            } else {
              context.read<Favourites>().updateWishList(widget.id);
              setState(() {});
            }
          }
      ),
    ) : Container();
  }
}

class WishListIcon extends StatefulWidget {
  final int id;
  const WishListIcon({Key? key, required this.id}) : super(key: key);

  @override
  State<WishListIcon> createState() => _WishListIconState();
}

class _WishListIconState extends State<WishListIcon> {
  @override
  Widget build(BuildContext context) {
    return AppStateModel().blocks.settings.wishlist ? IconButton(
        icon: context.watch<Favourites>().wishListIds.contains(widget.id) ? Icon(Icons.favorite, color: Theme.of(context).colorScheme.secondary) :
        Icon(Icons.favorite_border, color: Colors.black87),
        onPressed: () {
          if (AppStateModel().user.id == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Login()));
          } else {
            context.read<Favourites>().updateWishList(widget.id);
            setState(() {});
          }
        }
    ) : Container();
  }
}

class Favourites with ChangeNotifier {

  Favourites() {
    getWishListWithCookies();
  }

  List<int> wishListIds = [];
  final apiProvider = ApiProvider();
  
  void getWishList() async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=build-app-online-wishlistids', Map());
    if (response.statusCode == 200) {
      wishListIds = List<int>.from(json.decode(response.body).map((x) => x));
      notifyListeners();
    }
  }

  void clear() async {
    wishListIds = [];
    notifyListeners();
  }

  void getWishListWithCookies() async {
    final response = await apiProvider.postWithCookies('/wp-admin/admin-ajax.php?action=build-app-online-wishlistids', Map());
    if (response.statusCode == 200) {
      wishListIds = List<int>.from(json.decode(response.body).map((x) => x));
      notifyListeners();
    }
  }

  updateWishList(int id) {
    if(wishListIds.contains(id)) {
      wishListIds.remove(id);
    } else {
      wishListIds.add(id);
    }
    apiProvider.postWithCookies('/wp-admin/admin-ajax.php?action=build-app-online-update_wishlist', {'id': id.toString()});
  }

  removeFromWishList(int id) {
    wishListIds.remove(id);
    apiProvider.postWithCookies('/wp-admin/admin-ajax.php?action=build-app-online-update_wishlist', {'id': id.toString()});
  }
}

class WishListAppBarIcon extends StatefulWidget {
  final int id;
  const WishListAppBarIcon({Key? key, required this.id}) : super(key: key);

  @override
  State<WishListAppBarIcon> createState() => _WishListAppBarIconState();
}

class _WishListAppBarIconState extends State<WishListAppBarIcon> {
  @override
  Widget build(BuildContext context) {
    return AppStateModel().blocks.settings.wishlist ? IconButton(
        icon: context.watch<Favourites>().wishListIds.contains(widget.id) ? Icon(Icons.favorite) :
        Icon(Icons.favorite_border),
        onPressed: () {
          if (AppStateModel().user.id == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Login()));
          } else {
            context.read<Favourites>().updateWishList(widget.id);
            setState(() {});
          }
        }
    ) : Container();
  }
}
