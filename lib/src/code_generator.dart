import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'models.dart';

class CodeGenerator {
  static Widget generateHomeScreen(HomeScreenConfig config) {
    final TabController tabController =
        TabController(length: config.tabs.length, vsync: TickerProviderMixin());

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
        length: config.children.length, vsync: TickerProviderMixin());

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

  static Widget generateObjectScreen(ObjectScreenConfig config) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton(
                  onPressed: config.addFunc,
                  child: Text('Добавить ${config.name}'),
                ),
                TextButton(
                  onPressed: config.deleteAllFunc,
                  child: const Text(
                    'Удалить все',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: config.loadFunc,
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Ошибка: ${snapshot.error}');
              } else {
                List<dynamic> eventTypes = snapshot.data ?? [];
                return Expanded(
                    child: ListView(
                  children: [
                    DataTable(
                        showCheckboxColumn: false,
                        columns: config.dataColumns
                            .map((e) => DataColumn(label: Text(e)))
                            .toList(),
                        rows: eventTypes.map((e) {
                          return DataRow(cells: config.getDataCells(e));
                        }).toList()),
                  ],
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}

class TickerProviderMixin implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
