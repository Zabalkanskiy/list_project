import 'package:flutter/material.dart';
import 'package:list_project/App.dart';
import 'package:list_project/core/di/service_locator.dart';

void main() {
  ///dependency injection
  setupLocator();
  runApp(const App());
}


