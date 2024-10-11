import 'package:calculation_ocr/core/themes/green_theme.dart';
import 'package:calculation_ocr/core/themes/red_theme.dart';
import 'package:calculation_ocr/routes/my_router.dart';
import 'package:flutter/material.dart';

import 'flavors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: MyRouter().router,
      title: F.title,
      theme: F.theme == FlavorTheme.green ? greenTheme : redTheme,
    );
  }
}
