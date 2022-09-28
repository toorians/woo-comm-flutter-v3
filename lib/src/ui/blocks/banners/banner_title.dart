import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/ui/blocks/category/all_brnads.dart';

import './../../../ui/products/products/products.dart';
import './../../../ui/vendor/ui/stores/stores.dart';
import './../../../models/blocks_model.dart';
import 'package:flutter/material.dart';
import 'count_down_time.dart';

class BannerTitle extends StatelessWidget {
  final Block block;
  const BannerTitle({Key? key, required this.block}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.headline6!.copyWith(
        color: Theme.of(context).brightness == Brightness.light ? block.titleColor : null
    );

    var dateTo = DateTime.parse(block.saleEndDate);
    var dateFrom = DateTime.now();
    var difference = dateTo.difference(dateFrom).inSeconds;
    bool showCounter = !difference.isNegative && block.flashSale == true;

    if(showCounter) {
      if(block.headerAlign == 'top_left') {
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              block.showTitle == true ? Text(
                block.title,
                style: titleStyle,
              ) : Container(),
              block.showTitle == true ? SizedBox(width: 8) : SizedBox(width: 0),
              CountDownTime(saleEndDate: block.saleEndDate, block: block),
            ],
          ),
        );
      } else if(block.headerAlign == 'top_right') {
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CountDownTime(saleEndDate: block.saleEndDate, block: block),
              block.showTitle == true ? SizedBox(width: 8) : SizedBox(width: 0),
              block.showTitle == true ? Text(
                block.title,
                style: titleStyle,
              ) : Container(),
            ],
          ),
        );
      } else if(block.headerAlign == 'top_center') {
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              block.showTitle == true ? Text(
                block.title,
                style: titleStyle,
              ) : Container(),
              block.showTitle == true ? SizedBox(width: 8) : SizedBox(width: 0),
              CountDownTime(saleEndDate: block.saleEndDate, block: block),
            ],
          ),
        );
      } else return Container();
    } else if(block.showTitle == false) {
      return Container();
    } else {
      var filter = _getFilter();
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16.0),
        child: block.headerAlign != 'top_left' || filter == null ? Align(
          alignment: block.headerAlign == 'top_left' ? Alignment.centerLeft : block.headerAlign == 'top_right' ? Alignment.centerRight : Alignment.center,
          child: Text(block.title,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  color:  Theme.of(context).brightness == Brightness.light ? block.titleColor : null
              )),
        ) : ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(block.title, style: Theme.of(context).textTheme.headline6!.copyWith(color:  Theme.of(context).brightness == Brightness.light ? block.titleColor : null)),
              (block.blockType == BlockType.storeList || block.blockType == BlockType.storeSlider || block.blockType == BlockType.storeListTile || block.blockType == BlockType.storeScroll || block.blockType == BlockType.productGrid || block.blockType == BlockType.productScroll || block.blockType == BlockType.productSlider || block.blockType == BlockType.productList ||
                  block.blockType == BlockType.brandGrid || block.blockType == BlockType.brandList || block.blockType == BlockType.brandListTile || block.blockType == BlockType.brandPresets || block.blockType == BlockType.brandScroll || block.blockType == BlockType.brandSlider) ?  TextButton(
                onPressed: () => _onClickViewAll(context, filter),
                child: Text(AppStateModel().blocks.localeText.viewAll),
              ) : Container(),
            ],
          ),
          subtitle: block.description != null ? Text(block.description!, style: Theme.of(context).textTheme.bodyMedium) : null,
        ),
      );
    }
  }

  _getFilter() {
    var filter = new Map<String, dynamic>();
    if(block.blockType == BlockType.productGrid || block.blockType == BlockType.productScroll || block.blockType == BlockType.productSlider || block.blockType == BlockType.productList) {
      if(block.linkType == 'product_cat') {
        filter['id'] = block.linkId.toString();
        return filter;
      } else if (block.linkType == 'product_cat') {
        filter['featured'] = '1';
        return filter;
      } else if (block.linkType == 'onSale') {
        filter['on_sale'] = '1';
        return filter;
      } else if (block.linkType == 'featured') {
        filter['best_selling'] = '1';
        return filter;
      } else if (block.linkType == 'newArrivals') {
        filter['new_arrivals'] = '1';
        return filter;
      } else if (block.linkType == 'bestSelling') {
        filter['best_selling'] = '1';
        return filter;
      } else return null;
    } else if(block.blockType == BlockType.storeList || block.blockType == BlockType.storeSlider || block.blockType == BlockType.storeListTile || block.blockType == BlockType.storeScroll) {
      var filter = new Map<String, dynamic>();
      filter['stores'] = '1';
      filter['id'] = block.linkId.toString();;
      return filter;
    } else if(block.blockType == BlockType.brandGrid || block.blockType == BlockType.brandList || block.blockType == BlockType.brandListTile || block.blockType == BlockType.brandPresets || block.blockType == BlockType.brandScroll || block.blockType == BlockType.brandSlider) {
      return filter;
    } return null;
  }

  _onClickViewAll(BuildContext context, filter) {
    if(block.blockType == BlockType.productGrid || block.blockType == BlockType.productScroll || block.blockType == BlockType.productSlider || block.blockType == BlockType.productList) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductsWidget(
                  filter: filter,
                  name: block.title)));
    }
    else if(block.blockType == BlockType.storeList || block.blockType == BlockType.storeSlider || block.blockType == BlockType.storeListTile || block.blockType == BlockType.storeScroll) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StoreListPage(
                  filter: filter,
                  block: block)));
    }
    else if(block.blockType == BlockType.brandGrid || block.blockType == BlockType.brandList || block.blockType == BlockType.brandListTile || block.blockType == BlockType.brandPresets || block.blockType == BlockType.brandScroll || block.blockType == BlockType.brandSlider) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AllBrands(title: block.title)));
    }
  }
}



