import 'package:app/src/models/blocks_model.dart';
import 'package:app/src/ui/blocks/banners/banner_title.dart';
import 'package:app/src/ui/blocks/banners/on_click.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BannerPresets extends StatefulWidget {
  final Block block;
  const BannerPresets({Key? key, required this.block}) : super(key: key);
  @override
  _BannerPresetsState createState() => _BannerPresetsState();
}

class _BannerPresetsState extends State<BannerPresets> {

  @override
  Widget build(BuildContext context) {
    return _buildPreset1(widget.block);
  }

  Widget _buildPreset1(Block block) {

    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;

    double titlePaddingLeft = widget.block.blockPadding.left > 8.0 ? widget.block.blockPadding.left : 16.0;
    double titlePaddingRight = widget.block.blockPadding.left > 8.0 ?widget.block.blockPadding.right : 16.0;

    if(block.style == 'STYLE1')
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.fromLTRB(block.blockMargin.left, block.blockMargin.top, block.blockMargin.right, block.blockMargin.bottom),
          child: Container(
            color: isDark ? Colors.transparent : block.backgroundColor,
            padding: EdgeInsets.only(top: block.blockPadding.top, bottom: block.blockPadding.bottom),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(left: titlePaddingLeft, right: titlePaddingRight),
                    child: BannerTitle(block: widget.block)),
                Container(
                  height: block.childHeight,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          //width: MediaQuery.of(context).size.width / 2,
                          child: ListView.separated(
                              padding: EdgeInsets.all(0),
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: block.mainAxisSpacing,
                                );
                              },
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: block.children.length - 1,
                              itemBuilder: (BuildContext context,int index){
                                return Container(
                                  height: block.childHeight / (block.children.length - 1),
                                  child: Center(
                                      child: Card(
                                        color: Colors.transparent,
                                        clipBehavior: Clip.antiAlias,
                                        margin: EdgeInsets.all(0),
                                        elevation: block.elevation,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(block.borderRadius),
                                        ),
                                        child: InkWell(
                                          radius: block.borderRadius,
                                          onTap: () async {
                                            onItemClick(block.children[index], context);
                                          },
                                          child: Container(
                                            height: double.infinity,
                                            width: double.infinity,
                                            child: CachedNetworkImage(
                                              imageUrl: block.children[index].image,
                                              placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                              errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                );
                              }
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(width: block.mainAxisSpacing),
                          Container(
                            width: block.childWidth - block.mainAxisSpacing,
                            child: Center(
                                child: Card(
                                  color: Colors.transparent,
                                  clipBehavior: Clip.antiAlias,
                                  margin: EdgeInsets.all(0),
                                  elevation: block.elevation,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(block.borderRadius),
                                  ),
                                  child: InkWell(
                                    radius: block.borderRadius,
                                    onTap: () async {
                                      onItemClick(block.children.last, context);
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: block.children.last.image,
                                        placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                        errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),

          ),
        ),
      );
    else if(block.style == 'STYLE2')
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.fromLTRB(block.blockMargin.left, block.blockMargin.top, block.blockMargin.right, block.blockMargin.bottom),
          child: Container(
            color: isDark ? Colors.transparent : block.backgroundColor,
            padding: EdgeInsets.only(top: block.blockPadding.top, bottom: block.blockPadding.bottom),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(left: titlePaddingLeft, right: titlePaddingRight),
                    child: BannerTitle(block: widget.block)),
                Container(
                  height: block.childHeight,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: block.childWidth - block.mainAxisSpacing,
                            child: Center(
                                child: Card(
                                  color: Colors.transparent,
                                  clipBehavior: Clip.antiAlias,
                                  margin: EdgeInsets.all(0),
                                  elevation: block.elevation,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(block.borderRadius),
                                  ),
                                  child: InkWell(
                                    radius: block.borderRadius,
                                    onTap: () async {
                                      onItemClick(block.children.first, context);
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: block.children.first.image,
                                        placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                        errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ),
                          Container(width: block.mainAxisSpacing),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          //width: MediaQuery.of(context).size.width / 2,
                          child: ListView.separated(
                              padding: EdgeInsets.all(0),
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: block.mainAxisSpacing,
                                );
                              },
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: block.children.length - 1,
                              itemBuilder: (BuildContext context,int index){
                                return Container(
                                  height: block.childHeight / (block.children.length - 1),
                                  child: Center(
                                      child: Card(
                                        color: Colors.transparent,
                                        clipBehavior: Clip.antiAlias,
                                        margin: EdgeInsets.all(0),
                                        elevation: block.elevation,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(block.borderRadius),
                                        ),
                                        child: InkWell(
                                          radius: block.borderRadius,
                                          onTap: () async {
                                            onItemClick(block.children[index + 1], context);
                                          },
                                          child: Container(
                                            height: double.infinity,
                                            width: double.infinity,
                                            child: CachedNetworkImage(
                                              imageUrl: block.children[index + 1].image,
                                              placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                              errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                );
                              }
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),

          ),
        ),
      );
    else if(block.style == 'STYLE3' && block.children.length == 4)
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.fromLTRB(block.blockMargin.left, block.blockMargin.top, block.blockMargin.right, block.blockMargin.bottom),
          child: Container(
            color: isDark ? Colors.transparent : block.backgroundColor,
            padding: EdgeInsets.only(top: block.blockPadding.top, bottom: block.blockPadding.bottom),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(left: titlePaddingLeft, right: titlePaddingRight),
                    child: BannerTitle(block: widget.block)),
                Container(
                  height: block.childHeight,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: block.childWidth - block.mainAxisSpacing,
                            child: Center(
                                child: Card(
                                  color: Colors.transparent,
                                  clipBehavior: Clip.antiAlias,
                                  margin: EdgeInsets.all(0),
                                  elevation: block.elevation,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(block.borderRadius),
                                  ),
                                  child: InkWell(
                                    radius: block.borderRadius,
                                    onTap: () async {
                                      onItemClick(block.children.first, context);
                                    },
                                    child: Container(
                                      height: ( block.childHeight / 3 ) * 2 - block.mainAxisSpacing,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: block.children.first.image,
                                        placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                        errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ),
                          Container(height: block.mainAxisSpacing),
                          Container(
                            width: block.childWidth - block.mainAxisSpacing,
                            child: Center(
                                child: Card(
                                  color: Colors.transparent,
                                  clipBehavior: Clip.antiAlias,
                                  margin: EdgeInsets.all(0),
                                  elevation: block.elevation,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(block.borderRadius),
                                  ),
                                  child: InkWell(
                                    radius: block.borderRadius,
                                    onTap: () async {
                                      onItemClick(block.children[1], context);
                                    },
                                    child: Container(
                                      height: ( block.childHeight / 3 ) * 1,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: block.children[1].image,
                                        placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                        errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ),
                        ],
                      ),
                      Container(width: block.mainAxisSpacing),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              //width: block.childWidth - block.mainAxisSpacing,
                              child: Center(
                                  child: Card(
                                    color: Colors.transparent,
                                    clipBehavior: Clip.antiAlias,
                                    margin: EdgeInsets.all(0),
                                    elevation: block.elevation,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(block.borderRadius),
                                    ),
                                    child: InkWell(
                                      radius: block.borderRadius,
                                      onTap: () async {
                                        onItemClick(block.children[2], context);
                                      },
                                      child: Container(
                                        height: ( block.childHeight / 3 ) * 1,
                                        width: double.infinity,
                                        child: CachedNetworkImage(
                                          imageUrl: block.children[2].image,
                                          placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                          errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            Container(height: block.mainAxisSpacing),
                            Container(
                              width: block.childWidth - block.mainAxisSpacing,
                              child: Center(
                                  child: Card(
                                    color: Colors.transparent,
                                    clipBehavior: Clip.antiAlias,
                                    margin: EdgeInsets.all(0),
                                    elevation: block.elevation,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(block.borderRadius),
                                    ),
                                    child: InkWell(
                                      radius: block.borderRadius,
                                      onTap: () async {
                                        onItemClick(block.children.last, context);
                                      },
                                      child: Container(
                                        height: ( block.childHeight / 3 ) * 2 - block.mainAxisSpacing,
                                        width: double.infinity,
                                        child: CachedNetworkImage(
                                          imageUrl: block.children.last.image,
                                          placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                          errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ),
        ),
      );
    else if(block.style == 'STYLE4' && block.children.length == 4)
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.fromLTRB(block.blockMargin.left, block.blockMargin.top, block.blockMargin.right, block.blockMargin.bottom),
          child: Container(
            color: isDark ? Colors.transparent : block.backgroundColor,
            padding: EdgeInsets.only(top: block.blockPadding.top, bottom: block.blockPadding.bottom),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(left: titlePaddingLeft, right: titlePaddingRight),
                    child: BannerTitle(block: widget.block)),
                Container(
                  height: block.childHeight,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              //width: block.childWidth - block.mainAxisSpacing,
                              child: Center(
                                  child: Card(
                                    color: Colors.transparent,
                                    clipBehavior: Clip.antiAlias,
                                    margin: EdgeInsets.all(0),
                                    elevation: block.elevation,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(block.borderRadius),
                                    ),
                                    child: InkWell(
                                      radius: block.borderRadius,
                                      onTap: () async {
                                        onItemClick(block.children.first, context);
                                      },
                                      child: Container(
                                        height: ( block.childHeight / 3 ) * 1,
                                        width: double.infinity,
                                        child: CachedNetworkImage(
                                          imageUrl: block.children.first.image,
                                          placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                          errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            Container(height: block.mainAxisSpacing),
                            Container(
                              width: block.childWidth - block.mainAxisSpacing,
                              child: Center(
                                  child: Card(
                                    color: Colors.transparent,
                                    clipBehavior: Clip.antiAlias,
                                    margin: EdgeInsets.all(0),
                                    elevation: block.elevation,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(block.borderRadius),
                                    ),
                                    child: InkWell(
                                      radius: block.borderRadius,
                                      onTap: () async {
                                        onItemClick(block.children[1], context);
                                      },
                                      child: Container(
                                        height: ( block.childHeight / 3 ) * 2 - block.mainAxisSpacing,
                                        width: double.infinity,
                                        child: CachedNetworkImage(
                                          imageUrl: block.children[1].image,
                                          placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                          errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: block.mainAxisSpacing),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: block.childWidth - block.mainAxisSpacing,
                            child: Center(
                                child: Card(
                                  color: Colors.transparent,
                                  clipBehavior: Clip.antiAlias,
                                  margin: EdgeInsets.all(0),
                                  elevation: block.elevation,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(block.borderRadius),
                                  ),
                                  child: InkWell(
                                    radius: block.borderRadius,
                                    onTap: () async {
                                      onItemClick(block.children[2], context);
                                    },
                                    child: Container(
                                      height: ( block.childHeight / 3 ) * 2 - block.mainAxisSpacing,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: block.children[2].image,
                                        placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                        errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ),
                          Container(height: block.mainAxisSpacing),
                          Container(
                            width: block.childWidth - block.mainAxisSpacing,
                            child: Center(
                                child: Card(
                                  color: Colors.transparent,
                                  clipBehavior: Clip.antiAlias,
                                  margin: EdgeInsets.all(0),
                                  elevation: block.elevation,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(block.borderRadius),
                                  ),
                                  child: InkWell(
                                    radius: block.borderRadius,
                                    onTap: () async {
                                      onItemClick(block.children.last, context);
                                    },
                                    child: Container(
                                      height: ( block.childHeight / 3 ) * 1,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: block.children.last.image,
                                        placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                        errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ),
        ),
      );
    else return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(block.blockMargin.left, block.blockMargin.top, block.blockMargin.right, block.blockMargin.bottom),
        child: Container(
          color: isDark ? Colors.transparent : block.backgroundColor,
          padding: EdgeInsets.only(top: block.blockPadding.top, bottom: block.blockPadding.bottom),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(left: titlePaddingLeft, right: titlePaddingRight),
                  child: BannerTitle(block: widget.block)),
              Container(
                height: block.childHeight,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        //width: MediaQuery.of(context).size.width / 2,
                        child: ListView.separated(
                            separatorBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                height: block.mainAxisSpacing,
                              );
                            },
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: block.children.length - 1,
                            itemBuilder: (BuildContext context,int index){
                              return Container(
                                height: block.childHeight / (block.children.length - 1),
                                child: Center(
                                    child: Card(
                                      color: Colors.transparent,
                                      clipBehavior: Clip.antiAlias,
                                      margin: EdgeInsets.all(0),
                                      elevation: block.elevation,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(block.borderRadius),
                                      ),
                                      child: InkWell(
                                        radius: block.borderRadius,
                                        onTap: () async {
                                          onItemClick(block.children[index], context);
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          child: CachedNetworkImage(
                                            imageUrl: block.children[index].image,
                                            placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                            errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              );
                            }
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(width: block.mainAxisSpacing),
                        Container(
                          width: block.childWidth - block.mainAxisSpacing,
                          child: Center(
                              child: Card(
                                color: Colors.transparent,
                                clipBehavior: Clip.antiAlias,
                                margin: EdgeInsets.all(0),
                                elevation: block.elevation,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(block.borderRadius),
                                ),
                                child: InkWell(
                                  radius: block.borderRadius,
                                  onTap: () async {
                                    onItemClick(block.children.last, context);
                                  },
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: CachedNetworkImage(
                                      imageUrl: block.children.last.image,
                                      placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                      errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}
