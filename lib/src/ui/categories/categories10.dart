import 'package:app/src/functions.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/category_model.dart';
import 'package:app/src/ui/blocks/banners/on_click.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Categories10 extends StatefulWidget {
  @override
  _Categories10State createState() => _Categories10State();
}

class _Categories10State extends State<Categories10> {
  AppStateModel appStateModel = AppStateModel();
  late List<Category> mainCategories;

  late ScrollController scrollController;

  late List<bool> isCardOpen;

  static const int _nrOfCards = 22;

  double scrollPos = 0;
  int columns = 1;
  int prevColumns = 0;

  bool showAllBlends = false;

  void _scrollPosition() {
    scrollPos = scrollController.position.pixels;
  }

  @override
  void didChangeDependencies() {
    if (prevColumns != columns) {
      prevColumns = columns;
      if (scrollController.hasClients) scrollController.jumpTo(scrollPos);
    }
    super.didChangeDependencies();
  }

  void toggleCard(int index) {
    setState(() {
      isCardOpen[index] = !isCardOpen[index];
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollPosition);
    mainCategories = appStateModel.blocks.categories.where((cat) => cat.parent == 0).toList();
    isCardOpen = List<bool>.generate(mainCategories.length, (int i) => false);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appStateModel.blocks.localeText.categories),),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            columns = constraints.maxWidth ~/ 810 + 1;
            showAllBlends = constraints.maxWidth / columns > 445;
            double margins = 8;
            return StaggeredGridView.countBuilder(
              key: ValueKey<int>(columns),
              controller: scrollController,
              crossAxisCount: columns,
              mainAxisSpacing: margins,
              crossAxisSpacing: margins,
              padding: EdgeInsets.fromLTRB(
                margins,
                margins,
                margins,
                margins,
              ),
              staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              itemBuilder: (BuildContext context, int index) => Card(
                child: MaincategoryCard(
                  isOpen: isCardOpen[index],
                  onTap: () {
                    toggleCard(index);
                  },
                  title: Text(parseHtmlString(mainCategories[index].name)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        BuildCategoryGrid(categories: appStateModel.blocks.categories.where((element) => element.parent == mainCategories[index].id).toList(),),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
              itemCount: mainCategories.length,
            );
          }),
    );
  }
}

class BuildCategoryGrid extends StatelessWidget {
  final List<Category> categories;
  BuildCategoryGrid({
    Key? key,
    required this.categories
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 0.7
        ),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              onCategoryClick(categories[index], context);
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    //height: 80,
                    child: CachedNetworkImage(
                      imageUrl: categories[index].image.isNotEmpty ? categories[index].image : '',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(parseHtmlString(categories[index].name), style: TextStyle(fontSize: 12), maxLines: 1),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}




class MaincategoryCard extends StatelessWidget {
  const MaincategoryCard({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.margin = EdgeInsets.zero,
    this.headerPadding,
    this.enabled = true,
    this.isOpen = true,
    required this.onTap,
    this.duration = const Duration(milliseconds: 200),
    this.color,
    this.boldTitle = true,
    this.child,
  }) : super(key: key);
  
  final Widget? leading;

  final Widget? title;

  final Widget? subtitle;

  final EdgeInsetsGeometry margin;

  final EdgeInsetsGeometry? headerPadding;

  final bool enabled;

  final bool isOpen;

  final VoidCallback onTap;

  final Duration duration;

  final Color? color;

  final bool boldTitle;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    final bool isDark = theme.brightness == Brightness.dark;
    final int blendFactor = isDark ? 3 : 2;

    Color cardColor = theme.cardColor;
    Color headerColor =
    Color.alphaBlend(scheme.primary.withAlpha(5 * blendFactor), cardColor);
    if (cardColor == theme.scaffoldBackgroundColor ||
        headerColor == theme.scaffoldBackgroundColor) {
      cardColor = Color.alphaBlend(
          scheme.primary.withAlpha(4 * blendFactor), cardColor);
      headerColor = Color.alphaBlend(
          scheme.primary.withAlpha(4 * blendFactor), headerColor);
    }
    if (cardColor == theme.scaffoldBackgroundColor) {
      cardColor = Color.alphaBlend(
          scheme.primary.withAlpha(2 * blendFactor), cardColor);
    }

    Widget? _title = title;
    if (_title != null && _title is Text && boldTitle) {
      final Text textTitle = _title;
      final TextStyle? _style = _title.style;
      final String _text = textTitle.data ?? '';
      _title = Text(
        _text,
        style: _style?.copyWith(fontWeight: FontWeight.bold) ??
            const TextStyle(fontWeight: FontWeight.bold),
      );
    }

    if (color != null) cardColor = color!;

    return Card(
      margin: margin,
      color: cardColor,
      child: Column(
        children: <Widget>[
          Theme(
            data: theme.copyWith(cardColor: headerColor),
            child: Material(
              type: MaterialType.card,
              child: ListTile(
                contentPadding: headerPadding,
                leading: leading,
                title: _title,
                trailing: ExpandIcon(
                  size: 32,
                  isExpanded: isOpen,
                  padding: EdgeInsets.zero,
                  onPressed: (_) {
                    onTap();
                  },
                ),
                onTap: onTap,
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: duration,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: child,
              );
            },
            child: (isOpen && child != null) ? child : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

