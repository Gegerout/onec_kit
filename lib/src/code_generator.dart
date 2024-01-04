import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'models.dart';

class YourStatefulWidget extends StatefulWidget {
  final ObjectScreenConfig config;

  const YourStatefulWidget({Key? key, required this.config}) : super(key: key);

  @override
  _YourStatefulWidgetState createState() => _YourStatefulWidgetState();
}

class _YourStatefulWidgetState extends State<YourStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return generateObjectScreen(widget.config, () {
      widget.config.addFunc();
      setState(() {

      });
    });
  }
}

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

Widget generateObjectScreen(ObjectScreenConfig config, VoidCallback onPressedCallback) {
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
              ElevatedButton(
                onPressed: onPressedCallback,
                child: const Text('Add Event Type'),
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
              return Expanded(
                child: ListView.builder(
                  itemCount: eventTypes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(eventTypes[index].name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          config.deleteFunc();
                        },
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    ),
  );
}

class TestTickerProviderStateMixin implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
