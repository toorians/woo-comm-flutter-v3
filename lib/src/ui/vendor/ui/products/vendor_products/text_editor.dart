import 'package:flutter/material.dart';

class TextEditorPage extends StatefulWidget {
  final String text;

  const TextEditorPage({Key? key, required this.text}) : super(key: key);
  @override
  _TextEditorPageState createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<TextEditorPage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: TextFormField(
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                  hintText: 'Type your text here'
              ),
              controller: textEditingController,
              maxLines: null,
            ),
          ),
          SafeArea(
            child: Container(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(textEditingController.text);
                },
                child: Text('Save'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
