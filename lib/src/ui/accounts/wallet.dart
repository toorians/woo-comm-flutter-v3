import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:flex_color_scheme/src/flex_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../blocs/wallet_bloc.dart';
import '../../models/WalletModel.dart';
import '../../models/app_state_model.dart';
import '../../ui/checkout/cart/cart4.dart';
import '../widgets/buttons/button_text.dart';

class Wallet extends StatefulWidget {
  final walletBloc = WalletBloc();
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  ScrollController _scrollController = new ScrollController();
  DateFormat dateFormatter = DateFormat('dd-MMM-yyyy');
  final appStateModel = AppStateModel();
  
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _balanceAmountController = new TextEditingController();
  late NumberFormat formatter;

  @override
  void initState() {
    super.initState();
    widget.walletBloc.load();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.walletBloc.loadMore();
      }
    });

    formatter = NumberFormat.simpleCurrency(
        decimalDigits: appStateModel.blocks.siteSettings.priceDecimal,
        name: appStateModel.blocks.siteSettings.currency);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle menuTextStyle = Theme.of(context).textTheme.bodyText1!;
    Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    Color headerBackgroundColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
        body: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                leading: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: onPrimaryColor,
                  ),
                ),
                //brightness: Brightness.light,
                floating: false,
                pinned: true,
                snap: false,
                expandedHeight: 150.0,
                centerTitle: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarBrightness: Theme.of(context).colorScheme.primary.isDark ? Brightness.dark : Brightness.light,
                ),
                flexibleSpace: FlexibleSpaceBar(
                    title: StreamBuilder(
                        stream: widget.walletBloc.allTransactions,
                        builder: (context,
                            AsyncSnapshot<List<WalletModel>> snapshot) {
                          if (snapshot.hasData && snapshot.data!.length > 0) {
                              return Container(
                                  child: Text(
                                      appStateModel.blocks.localeText.balance + ' ' + formatter.format(double.parse(snapshot.data![0].balance)),
                                    style: TextStyle(color: onPrimaryColor),
                                  ));
                          } else {
                            double balance = 0;
                            return Container(
                                child: Text(
                                  appStateModel.blocks.localeText.balance + ' ' +
                                      formatter.format(balance),
                                  style: TextStyle(color: onPrimaryColor),
                                ));
                          }

                        }),
                    background: buildAccountBackground2()),
                backgroundColor: headerBackgroundColor,
              ),
              StreamBuilder(
                  stream: widget.walletBloc.allTransactions,
                  builder:
                      (context, AsyncSnapshot<List<WalletModel>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length == 0) {
                        double balance = 0;
                        return SliverToBoxAdapter(
                          child: Container(
                            height: MediaQuery.of(context).size.height - 225,
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _addBalance(context, balance);
                                },
                                  child: Text(appStateModel.blocks.localeText.addBalance)
                              ),
                            ),
                          ),
                        );
                      } else {
                        return buildList(snapshot);
                      }
                    } else {
                      return SliverToBoxAdapter(
                          child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 4),
                              child:
                                  Center(child: CircularProgressIndicator())));
                    }
                  })
            ],
          );
        }),
        floatingActionButton: StreamBuilder(
            stream: widget.walletBloc.allTransactions,
            builder: (context,
                AsyncSnapshot<List<WalletModel>> snapshot) {
              double balance = 0;
              if(snapshot.hasData && snapshot.data!.length > 0) {
                balance = double.parse(snapshot.data![0].balance);
              }

            return FloatingActionButton(
              onPressed: () => _addBalance(context, balance),
              child: Icon(Icons.add),
            );
          }
        ));
  }

  Widget buildList(AsyncSnapshot<List<WalletModel>> snapshot) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.all(16),
            dense: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(snapshot.data![index].type.toUpperCase()),
                    SizedBox(width: 8),
                    Text(formatter
                        .format(double.parse(snapshot.data![index].amount))),
                  ],
                ),
                Text(formatter
                    .format(double.parse(snapshot.data![index].balance))),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(snapshot.data![index].details),
                SizedBox(height: 4),
                Text(dateFormatter.format(snapshot.data![index].date)),
              ],
            ),
            /*trailing: Text(formatter
                .format(double.parse(snapshot.data![index].balance))),*/
          );
        },
        childCount: snapshot.data!.length,
      ),
    );
  }

  void _addBalance(BuildContext context, balance) {

    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: appStateModel.blocks.siteSettings.priceDecimal,
        name: appStateModel.blocks.siteSettings.currency);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, setState) {
                return Container(
                  height: 550,
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 80,
                                child: Text(
                                    appStateModel.blocks.localeText.balance + ' ' +
                                      formatter.format(balance),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.close,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: _balanceAmountController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return appStateModel.blocks.localeText.pleaseEnterRechargeAmount;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: appStateModel.blocks.localeText.enterRechargeAmount,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var data = new Map<String, dynamic>();
                                data['woo_wallet_balance_to_add'] =
                                    _balanceAmountController.text;
                                data['woo_wallet_topup'] = appStateModel
                                    .blocks
                                    .nonce
                                    .wooWalletTopup; // Replace with nonce
                                data['_wp_http_referer'] =
                                    '/my-account/woo-wallet/add/';
                                data['woo_add_to_wallet'] = 'Add';
                                setState(() {
                                  isLoading = true;
                                });
                                bool status =
                                    await widget.walletBloc.addBalance(data);
                                await context.read<ShoppingCart>().getCartAfterAddingBalanceToCart();
                                setState(() {
                                  isLoading = false;
                                });
                                if (status) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CartPage(),
                                        fullscreenDialog: true,
                                      ));
                                }
                              }
                            },
                            child: ButtonText(
                                isLoading: isLoading, text: appStateModel.blocks.localeText.addBalance),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget buildAccountBackground2() {
    return Stack(
      children: [
        Positioned(
          top: 10,
          left: 80,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme
                  .of(context)
                  .primaryColorLight
                  .withOpacity(0.3),
            ),
            height: 60,
            width: 60,
          ),
        ),
        Positioned(
          top: 0,
          left: -5,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme
                  .of(context)
                  .primaryColorLight
                  .withOpacity(0.3),
            ),
            height: 35,
            width: 90,
          ),
        ),
        Positioned(
          bottom: 62,
          right: -40,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme
                  .of(context)
                  .primaryColorLight
                  .withOpacity(0.3),
            ),
            height: 100,
            width: 100,
          ),
        ),
        Positioned(
          bottom: -40,
          right: 60,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme
                  .of(context)
                  .primaryColorLight
                  .withOpacity(0.3),
            ),
            height: 80,
            width: 80,
          ),
        )
      ],
    );
  }

  _addAmount() async {}

  void _navigateToCart() {}
}
