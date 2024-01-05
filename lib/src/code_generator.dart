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

  static Widget generateObjectScreen(ObjectScreenConfig config) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(labelText: 'Event Type Name'),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: config.addFunc,
                      child: const Text('Add Event Type'),
                    ),
                    ElevatedButton(
                      onPressed: config.deleteAllFunc,
                      child: const Text('Delete All'),
                    ),
                  ],
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
                return Text('Error: ${snapshot.error}');
              } else {
                List<dynamic> eventTypes = snapshot.data ?? [];
                // return Expanded(
                //   child: ListView.builder(
                //     itemCount: eventTypes.length,
                //     itemBuilder: (context, index) {
                //       return ListTile(
                //         title: Text(eventTypes[index].name),
                //         trailing: Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             IconButton(
                //               icon: const Icon(Icons.delete),
                //               onPressed: () async {
                //                 config.modifyFunc(eventTypes[index].id);
                //               },
                //             ),
                //             IconButton(
                //               icon: const Icon(Icons.delete),
                //               onPressed: () async {
                //                 config.deleteFunc(eventTypes[index].id);
                //               },
                //             ),
                //           ],
                //         ),
                //       );
                //     },
                //   ),
                // );
                return Expanded(
                    child: ListView(
                  children: [
                    DataTable(
                        showCheckboxColumn: false,
                        columns: config.dataColumns
                            .map((e) => DataColumn(label: Text(e)))
                            .toList(),
                        rows: eventTypes.map((e) {
                          return DataRow(
                            // cells: [
                            //   DataCell(Text(e.id.toString())),
                            //   DataCell(Row(
                            //     children: [
                            //       Text(e.name, overflow: TextOverflow.ellipsis),
                            //       const Spacer(),
                            //       IconButton(
                            //           onPressed: () {
                            //             config.modifyFunc(e.id);
                            //           },
                            //           icon: const Icon(Icons.edit)),
                            //       IconButton(
                            //           onPressed: () {
                            //             config.deleteFunc(e.id);
                            //           },
                            //           icon: const Icon(Icons.delete)),
                            //     ],
                            //   )
                            //   )
                            // ],
                            cells: config.getDataCells(eventTypes)
                          );
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

class TestTickerProviderStateMixin implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
