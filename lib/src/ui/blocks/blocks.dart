import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/blocks_model.dart';
import 'package:app/src/models/category_model.dart';
import 'package:app/src/ui/blocks/banners/banner_grid.dart';
import 'package:app/src/ui/blocks/banners/banner_list.dart';
import 'package:app/src/ui/blocks/banners/banner_presets.dart';
import 'package:app/src/ui/blocks/banners/banner_scroll.dart';
import 'package:app/src/ui/blocks/banners/banner_slider.dart';
import 'package:app/src/ui/blocks/category/category_grid.dart';
import 'package:app/src/ui/blocks/category/category_list.dart';
import 'package:app/src/ui/blocks/category/category_list_tile.dart';
import 'package:app/src/ui/blocks/category/category_presets.dart';
import 'package:app/src/ui/blocks/category/category_scroll.dart';
import 'package:app/src/ui/blocks/category/category_slider.dart';
import 'package:app/src/ui/blocks/html/html_list.dart';
import 'package:app/src/ui/blocks/posts/post_card_list.dart';
import 'package:app/src/ui/blocks/posts/post_card_scroll.dart';
import 'package:app/src/ui/blocks/posts/post_list.dart';
import 'package:app/src/ui/blocks/posts/post_slider.dart';
import 'package:app/src/ui/blocks/products/product_grid.dart';
import 'package:app/src/ui/blocks/products/product_list.dart';
import 'package:app/src/ui/blocks/products/product_scroll.dart';
import 'package:app/src/ui/blocks/products/product_slider.dart';
import 'package:app/src/ui/blocks/stores/store_card_scroll.dart';
import 'package:app/src/ui/blocks/stores/store_slider.dart';
import 'package:app/src/ui/blocks/text/text_list.dart';
import 'package:app/src/ui/blocks/video/vedio_list.dart';
import 'package:app/src/ui/vendor/ui/stores/store_list/store_card_list.dart';
import 'package:app/src/ui/vendor/ui/stores/store_list/store_list.dart';
import 'package:flutter/material.dart';

class SliverBlock extends StatelessWidget {
  final Block block;
  SliverBlock({Key? key, required this.block}) : super(key: key);

  final appStateModel = AppStateModel();

  @override
  Widget build(BuildContext context) {
    switch (block.blockType) {
      case BlockType.bannerGrid:
        return BannerGrid(block: block);
      case BlockType.bannerList:
        return BannerList(block: block);
      case BlockType.bannerScroll:
        return BannerScroll(block: block);
      case BlockType.bannerSlider:
        return BannerSlider(block: block);
      case BlockType.bannerPresets:
        return BannerPresets(block: block);
      case BlockType.textList:
        return TextList(block: block);
      case BlockType.htmlList:
        return HtmlTextList(block: block);
      case BlockType.videoList:
        return VideoList(block: block);
      case BlockType.videoListWithController:
        return VideoList(block: block);
      case BlockType.youTubeVideo:
        return VideoList(block: block);
      case BlockType.categoryGrid:
        List<Category> categories = appStateModel.blocks.categories.where((cat) => cat.parent == block.linkId).toList();
        return CategoryGrid(block: block, categories: categories);
      case BlockType.categoryList:
        List<Category> categories = appStateModel.blocks.categories.where((cat) => cat.parent == block.linkId).toList();
        return CategoryList(block: block, categories: categories);
      case BlockType.categoryScroll:
        List<Category> categories = appStateModel.blocks.categories.where((cat) => cat.parent == block.linkId).toList();
        return CategoryScroll(block: block, categories: categories);
      case BlockType.categorySlider:
        List<Category> categories = appStateModel.blocks.categories.where((cat) => cat.parent == block.linkId).toList();
        return CategorySlider(block: block, categories: categories);
      case BlockType.categoryListTile:
        List<Category> categories = appStateModel.blocks.categories.where((cat) => cat.parent == block.linkId).toList();
        return CategoryListTile(block: block, categories: categories);
      case BlockType.categoryPresets:
        List<Category> categories = appStateModel.blocks.categories.where((cat) => cat.parent == block.linkId).toList();
        return CategoryPresets(block: block, categories: categories);
      case BlockType.brandGrid:
        List<Category> categories = appStateModel.blocks.brands.where((cat) => cat.parent == block.linkId).toList();
        return CategoryGrid(block: block, categories: categories, type: 'brand');
      case BlockType.brandList:
        List<Category> categories = appStateModel.blocks.brands.where((cat) => cat.parent == block.linkId).toList();
        return CategoryList(block: block, categories: categories, type: 'brand');
      case BlockType.brandScroll:
        List<Category> categories = appStateModel.blocks.brands.where((cat) => cat.parent == block.linkId).toList();
        return CategoryScroll(block: block, categories: categories, type: 'brand');
      case BlockType.brandSlider:
        List<Category> categories = appStateModel.blocks.brands.where((cat) => cat.parent == block.linkId).toList();
        return CategorySlider(block: block, categories: categories, type: 'brand');
      case BlockType.brandListTile:
        List<Category> categories = appStateModel.blocks.brands.where((cat) => cat.parent == block.linkId).toList();
        return CategoryListTile(block: block, categories: categories, type: 'brand');
      case BlockType.brandPresets:
        List<Category> categories = appStateModel.blocks.brands.where((cat) => cat.parent == block.linkId).toList();
        return CategoryPresets(block: block, categories: categories, type: 'brand');


      case BlockType.productGrid:
        if(block.products.length > 0) {
          return ProductBlockGrid(products: block.products, block: block);
        } else {
          return SliverToBoxAdapter();
        }
      case BlockType.productList:
        if(block.products.length > 0) {
          return ProductList(products: block.products, block: block);
        } else {
          return SliverToBoxAdapter();
        }
      case BlockType.productScroll:
        if(block.products.length > 0) {
          return ProductCardScroll(products: block.products, block: block);
        } else {
          return SliverToBoxAdapter();
        }
      case BlockType.productSlider:
        if(block.products.length > 0) {
          return ProductSlider(products: block.products, block: block);
        } else {
          return SliverToBoxAdapter();
        }
      case BlockType.storeList:
        if(block.stores.length > 0) {
          return StoreCard(stores: block.stores, block: block);
        } else {
          return SliverToBoxAdapter();
        }
      case BlockType.storeListTile:
        if(block.stores.length > 0) {
          return StoreList(stores: block.stores, block: block);
        } else {
          return SliverToBoxAdapter();
        }
      case BlockType.storeScroll:
        if(block.stores.length > 0) {
          return StoreCardScroll(stores: block.stores, block: block);
        } else {
          return SliverToBoxAdapter();
        }
      case BlockType.storeSlider:
        if(block.stores.length > 0) {
          return StoreSlider(stores: block.stores, block: block);
        } else {
          return SliverToBoxAdapter();
        }
      case BlockType.postList:
        if(block.posts.length > 0) {
          return PostCard(posts: block.posts, block: block);
        } else {
          return SliverToBoxAdapter();
        }
      case BlockType.postListTile:
        if(block.posts.length > 0) {
          return PostList(posts: block.posts, block: block);
        } else {
          return SliverToBoxAdapter();
        }
      case BlockType.postScroll:
        if(block.posts.length > 0) {
          return PostCardScroll(posts: block.posts, block: block);
        } else {
          return SliverToBoxAdapter();
        }
      case BlockType.postSlider:
        if(block.posts.length > 0) {
          return PostSlider(posts: block.posts, block: block);
        } else {
          return SliverToBoxAdapter();
        }
      default:
        return SliverToBoxAdapter();
    }
  }
}
