import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Custom Search input field, showing the search and clear icons.
class SearchInput extends StatefulWidget {
  final ValueChanged<String> onSearchInput;

  SearchInput(this.onSearchInput);

  @override
  State<StatefulWidget> createState() => SearchInputState();
}

class SearchInputState extends State<SearchInput> {
  TextEditingController editController = TextEditingController();

  Timer? debouncer;

  bool hasSearchEntry = false;
  Color? fillColor;

  OutlineInputBorder border = OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.all(Radius.circular(48.0)),
      borderSide: BorderSide(width: 0, color: Colors.transparent));

  @override
  void initState() {
    super.initState();
    this.editController.addListener(this.onSearchInputChange);
  }

  @override
  void dispose() {
    this.editController.removeListener(this.onSearchInputChange);
    this.editController.dispose();

    super.dispose();
  }

  void onSearchInputChange() {
    if (this.editController.text.isEmpty) {
      this.debouncer?.cancel();
      widget.onSearchInput(this.editController.text);
      return;
    }

    if (this.debouncer?.isActive ?? false) {
      this.debouncer!.cancel();
    }

    this.debouncer = Timer(Duration(milliseconds: 500), () {
      widget.onSearchInput(this.editController.text);
    });
  }

  @override
  Widget build(BuildContext context) {

    if(Theme.of(context).appBarTheme.backgroundColor != null) {
      fillColor = Theme.of(context).appBarTheme.backgroundColor.toString().substring(Theme.of(context).appBarTheme.backgroundColor.toString().length - 7) == 'ffffff)' ? null : Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
    } else fillColor = Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black12;

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 24, 0),
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            hintText: "Search place",
            focusedBorder: border,
            border: border,
            enabledBorder: border,
            errorBorder: border,
            focusedErrorBorder: border,
            fillColor: fillColor,
            filled: true,
            prefixIcon: Icon(CupertinoIcons.search),
            suffixIcon: this.hasSearchEntry ? InkWell(
                onTap: () {
                  this.editController.clear();
                  setState(() {
                    this.hasSearchEntry = false;
                  });
                },
                child: Icon(Icons.clear)) : null
        ),
        controller: this.editController,
        autofocus: true,
        onChanged: (value) {
          setState(() {
            this.hasSearchEntry = value.isNotEmpty;
          });
        },
      ),
    );
  }
}
