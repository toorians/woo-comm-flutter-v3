import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/resources/get_icon.dart';
import 'package:app/src/ui/accounts/account/account_floating_button.dart';
import 'package:app/src/ui/blocks/banners/on_click.dart';
import 'package:app/src/ui/widgets/colored_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tinycolor2/tinycolor2.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
      return Scaffold(
          floatingActionButton: AccountFloatingButton(page: 'account'),
          body: CustomScrollView(slivers: _buildList(model))
      );
    });
  }

  _buildList(AppStateModel model) {
    List<Widget> list = [];

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    //Color? iconColor = isDark ? Theme.of(context).iconTheme.color : model.blocks.settings.accountTheme.light.hintColor;
    Color headerColor = model.blocks.settings.accountTheme.light.disabledColor;


    list.add(SliverAppBar(
        //automaticallyImplyLeading: false,
        pinned: true,
        floating: false,
        expandedHeight: model.blocks.settings.accountBackgroundImage.isNotEmpty ? 150.0 : 0,
        stretch: true,
        elevation: 0,
        title: model.blocks.settings.accountBackgroundImage.isEmpty ? Text(model.blocks.localeText.account) : null,
        flexibleSpace: model.blocks.settings.accountBackgroundImage.isNotEmpty
            ? FlexibleSpaceBar(
          stretchModes: [StretchMode.zoomBackground],
          background: CachedNetworkImage(
            imageUrl: model.blocks.settings.accountBackgroundImage,
            placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
            errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
            fit: BoxFit.cover,
          ),
        ) : null));

    model.blocks.settings.accountGroup.forEach((accountGroup) {

      if(accountGroup.showTitle) {
        list.add(
          SliverToBoxAdapter(
           child: ListTile(
             subtitle: Text(accountGroup.title, style: Theme.of(context).textTheme.headline6),
           ),
          )
        );
      } else list.add(SliverToBoxAdapter(child: SizedBox(height: 16)));

      list.add(SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (['vendorProducts', 'vendorOrders', 'vendorWebView'].contains(accountGroup.menuItems[index].linkType) &&
                    !model.isVendor.contains(model.user.role)) {
                  return Container();
                } else if (accountGroup.menuItems[index].linkType == 'login' &&
                    model.user.id != 0) {
                  return Container();
                } else if (accountGroup.menuItems[index].linkType == 'logout' &&
                    model.user.id == 0) {
                  return Container();
                } else
                return Column(
            children: [
              ListTile(
                onTap: () {
                  onItemClick(accountGroup.menuItems[index], context);
                },
                leading: accountGroup.menuItems[index].leading.isNotEmpty
                    ? ColoredIcon(item: accountGroup.menuItems[index])
                    : null,
                trailing: accountGroup.menuItems[index].trailing.isNotEmpty
                    ? Icon(baoIconList.firstWhere((element) => element.label == accountGroup.menuItems[index].trailing).icon/*, color: iconColor*/)
                    : null,
                title: Text(accountGroup.menuItems[index].title),
                subtitle: accountGroup.menuItems[index].description.isNotEmpty ? Text(accountGroup.menuItems[index].description) : null,
              ),
              Divider(height: 0)
            ],
          );
              },
          childCount: accountGroup.menuItems.length,
        ),
      ));
    });

    if(model.blocks.settings.accountSocialLink) {
      list.add(SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
          height: 60,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(model.blocks.settings.socialLink.facebook.isNotEmpty)
                  IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                    icon: Icon(FontAwesomeIcons.facebookF),
                    iconSize: 15,
                    color: Color(0xff4267B2),
                    onPressed: (){
                      launchUrl(Uri.parse(model.blocks.settings.socialLink.facebook), mode: LaunchMode.externalApplication);
                    },
                  ),
                if(model.blocks.settings.socialLink.twitter.isNotEmpty)
                  IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                    icon: Icon(FontAwesomeIcons.twitter),
                    iconSize: 15,
                    color: Color(0xff1DA1F2),
                    onPressed: () {
                      launchUrl(Uri.parse(model.blocks.settings.socialLink.twitter), mode: LaunchMode.externalApplication);
                    },
                  ),
                if(model.blocks.settings.socialLink.linkedIn.isNotEmpty)
                  IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                    icon: Icon(FontAwesomeIcons.linkedinIn),
                    iconSize: 15,
                    color: Color(0xff0e76a8),
                    onPressed: () {
                      launchUrl(Uri.parse(model.blocks.settings.socialLink.linkedIn), mode: LaunchMode.externalApplication);
                    },
                  ),
                if(model.blocks.settings.socialLink.instagram.isNotEmpty)
                  IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                    icon: Icon(FontAwesomeIcons.instagram),
                    iconSize: 15,
                    color: Color(0xfffb3958),
                    onPressed: () {
                      launchUrl(Uri.parse(model.blocks.settings.socialLink.instagram), mode: LaunchMode.externalApplication);
                    },
                  ),
                if(model.blocks.settings.socialLink.whatsapp.isNotEmpty)
                  IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                    icon: Icon(FontAwesomeIcons.whatsapp),
                    iconSize: 15,
                    color: Color(0xff128C7E),
                    onPressed: () {
                      launchUrl(Uri.parse(model.blocks.settings.socialLink.whatsapp), mode: LaunchMode.externalApplication);
                    },
                  )
              ],
            ),
          ) ,
        ),
      ));
    } else {
      list.add(SliverToBoxAdapter(
        child: SizedBox(height: 16),
      ));
    }


    if(model.blocks.settings.socialLink.bottomText.isNotEmpty)
    list.add(SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
          child: TextButton(
            child: Text(model.blocks.settings.socialLink.bottomText),
            onPressed: () async {
              if(model.blocks.settings.socialLink.bottomText.contains('@') && model.blocks.settings.socialLink.bottomText.contains('.'))
                launchUrl(Uri.parse('mailto:' + model.blocks.settings.socialLink.bottomText));
              else {
                await canLaunch(model.blocks.settings.socialLink.bottomText) ? await launch(model.blocks.settings.socialLink.bottomText) : throw 'Could not launch ${model.blocks.settings.socialLink.bottomText}';
              }
            },
          ),
        ),
      ),
    ));

    list.add(SliverToBoxAdapter(
      child: SizedBox(height: 40),
    ));

    return list;
  }
}
