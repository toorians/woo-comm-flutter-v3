import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/src/blocs/coupon_bloc.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/coupon.dart';
import 'package:app/src/ui/accounts/account/account1.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

class CouponsPage extends StatefulWidget {
  final couponBloc = CouponBloc();
  @override
  _CouponsPageState createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  final appStateModel = AppStateModel();

  var formatter1 = new DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    widget.couponBloc.fetchCoupons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appStateModel.blocks.localeText.coupons),
      ),
      body: StreamBuilder<List<CouponModel>>(
          stream: widget.couponBloc.allCoupons,
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null
                ? ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(snapshot.data![index].code.toUpperCase(), style: Theme.of(context).textTheme.headline6,),
                          TextButton(
                              onPressed: () {
                                context.read<ShoppingCart>().applyCoupon(snapshot.data![index].code, context);
                              },
                              child: Text(appStateModel.blocks.localeText.apply.toUpperCase())
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(snapshot.data![index].description.isNotEmpty)
                            Text(snapshot.data![index].description),
                          if(snapshot.data![index].dateExpiresGmt != null)
                            Text("Expires on " +formatter1.format(snapshot.data![index].dateExpiresGmt!)),
                        ],
                      ),
                    ),
                  );
                })
                : Container(
              child: Center(child: CircularProgressIndicator()),
            );
          }),
    );
  }
}
