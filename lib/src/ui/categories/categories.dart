import 'package:app/src/ui/categories/categories11.dart';
import 'package:app/src/ui/categories/categories12.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../src/models/app_state_model.dart';
import 'categories1.dart';
import 'categories10.dart';
import 'categories2.dart';
import 'categories3.dart';
import 'categories4.dart';
import 'categories5.dart';
import 'categories6.dart';
import 'categories7.dart';
import 'categories8.dart';
import 'categories9.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
         // return Categories12();
          //return Categories10();
          //print(model.blocks.settings.pageLayout.category);
         // return Categories11();
         // return Categories11();
      if (model.blocks.settings.pageLayout.category == 'layout1') {
        return Categories1();
      } else if (model.blocks.settings.pageLayout.category == 'layout2') {
        return Categories2();
      } else if (model.blocks.settings.pageLayout.category == 'layout3') {
        return Categories3();
      } else if (model.blocks.settings.pageLayout.category == 'layout4') {
        return Categories4();
      } else if (model.blocks.settings.pageLayout.category == 'layout5') {
        return Categories5();
      } else if (model.blocks.settings.pageLayout.category == 'layout6') {
        return Categories6();
      } else if (model.blocks.settings.pageLayout.category == 'layout7') {
        return Categories7();
      } else if (model.blocks.settings.pageLayout.category == 'layout8') {
        return Categories8();
      } else if (model.blocks.settings.pageLayout.category == 'layout9') {
        return Categories9();
      } else if (model.blocks.settings.pageLayout.category == 'layout10') {
        return Categories10();
      } else if (model.blocks.settings.pageLayout.category == 'layout11') {
        return Categories11();
      } else if (model.blocks.settings.pageLayout.category == 'layout12') {
        return Categories12();
      } else {
        return Categories7();
      }
    });
  }
}
