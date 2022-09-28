import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarField extends StatefulWidget {
  final Function(String)? onChanged;
  final bool autofocus;
  final TextEditingController searchTextController;
  final String hintText;
  const SearchBarField({Key? key, required this.onChanged, required this.searchTextController, required this.hintText, required this.autofocus}) : super(key: key);
  @override
  _SearchBarFieldState createState() => _SearchBarFieldState();
}

class _SearchBarFieldState extends State<SearchBarField> {

  Color? fillColor;

  final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      borderSide: BorderSide(color: Colors.transparent));

  @override
  Widget build(BuildContext context) {

    if(Theme.of(context).appBarTheme.backgroundColor != null) {
      fillColor = Theme.of(context).appBarTheme.backgroundColor.toString().substring(Theme.of(context).appBarTheme.backgroundColor.toString().length - 7) == 'ffffff)' ? null : Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
    } else fillColor = Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black12;

    return SizedBox(
      height: 38,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 24, 0),
        child: TextFormField(
          controller: widget.searchTextController,
          onChanged: widget.onChanged,
          autofocus: widget.autofocus,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 16,
            ),
            fillColor: fillColor,
            filled: true,
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            errorBorder: border,
            focusedErrorBorder: border,
            disabledBorder: border,
            contentPadding: EdgeInsets.all(4),
            prefixIcon: Icon(
              CupertinoIcons.search,
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
      ),
    );
  }
}