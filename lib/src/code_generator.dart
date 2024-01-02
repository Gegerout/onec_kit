import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'models.dart';

class CodeGenerator {
  static Widget generateHomeScreen(HomeScreenConfig config) {
    return Scaffold(
      appBar: AppBar(
        title: Text(config.appBarTitle),
        bottom: TabBar(
          controller: TabController(
              length: config.tabs.length,
              vsync: TestTickerProviderStateMixin()),
          tabs: config.tabs
              .map((tab) => Tab(icon: Icon(tab.iconData), text: tab.name))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: TabController(
            length: config.tabs.length, vsync: TestTickerProviderStateMixin()),
        children: config.tabs.map((tab) => generateHomeTab(tab)).toList(),
      ),
    );
  }

  static Widget generateHomeTab(HomeTabConfig config) {
    return Column(
      children: config.children
          .map((objectTab) => generateObjectTab(objectTab))
          .toList(),
    );
  }

  static Widget generateObjectTab(ObjectTabConfig config) {
    return config.screen;
  }
}

class TestTickerProviderStateMixin implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}