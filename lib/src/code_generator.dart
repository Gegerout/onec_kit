import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'models.dart';

class CodeGenerator {
  static Widget generateHomeScreen(HomeScreenConfig config) {
    final TabController tabController = TabController(
        length: config.tabs.length, vsync: TestTickerProviderStateMixin());

    return Scaffold(
      appBar: AppBar(
        title: Text(config.appBarTitle),
        bottom: TabBar(
          controller: tabController,
          tabs: config.tabs
              .map((tab) => Tab(icon: Icon(tab.iconData), text: tab.name))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: config.tabs.map((tab) => generateHomeTab(tab)).toList(),
      ),
    );
  }

  static Widget generateHomeTab(HomeTabConfig config) {
    final TabController tabController = TabController(
        length: config.children.length, vsync: TestTickerProviderStateMixin());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: TabBar(
            controller: tabController,
            tabs: config.children
                .map((tab) => Tab(
                      text: tab.name,
                    ))
                .toList()),
      ),
      body: TabBarView(
          controller: tabController,
          children:
              config.children.map((tab) => generateObjectTab(tab)).toList()),
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
