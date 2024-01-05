import 'package:flutter/material.dart';

class HomeScreenConfig {
  final String appBarTitle;
  final List<HomeTabConfig> tabs;

  HomeScreenConfig({required this.appBarTitle, required this.tabs});
}

class HomeTabConfig {
  final String name;
  final IconData iconData;
  final List<ObjectTabConfig> children;

  HomeTabConfig(
      {required this.name, required this.iconData, required this.children});
}

class ObjectTabConfig {
  final String name;
  final Widget screen;

  ObjectTabConfig({required this.name, required this.screen});
}

class ObjectScreenConfig {
  final String name;
  final VoidCallback deleteAllFunc;
  final VoidCallback addFunc;
  final Future<List<dynamic>> loadFunc;
  final List dataColumns;
  final List<DataCell> Function(dynamic data) getDataCells;

  ObjectScreenConfig(
      {required this.name,
      required this.deleteAllFunc,
      required this.addFunc,
      required this.loadFunc,
      required this.dataColumns,
      required this.getDataCells});
}
