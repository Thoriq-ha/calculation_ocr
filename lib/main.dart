import 'dart:async';
import 'package:calculation_ocr/dependency_injection.dart';
import 'package:calculation_ocr/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  Bloc.observer = MyObserver();

  runApp(const App());
}
