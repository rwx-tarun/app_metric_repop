import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:untitled/utils.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AppUsageInfo> app_data = [];
  List<dynamic> pie_chart_data = [];
  DateTime date = DateTime.now();
  int pie_chart_size = 5;
  Duration total_time = const Duration();

  @override
  void initState() {
    getUsageStats();
    super.initState();
  }

  List<Application> app = [];
  getApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true);
    setState(() {
      app = apps;
    });
  }

  Future<void> getUsageStats() async {
    try {
      DateTime startDate = DateTime(date.year, date.month, date.day - 1);
      DateTime endDate = DateTime(date.year, date.month, date.day);
      // DateTime startDate = DateTime(2018, 01, 01);
      // DateTime endDate = new DateTime.now();
      List<AppUsageInfo> infos = await AppUsage.getAppUsage(startDate, endDate);
      List<Application> apps = await DeviceApps.getInstalledApplications(
          onlyAppsWithLaunchIntent: true,
          includeAppIcons: true,
          includeSystemApps: true);

      if (infos != null || infos.isEmpty) {
        infos.forEach((element) {
          total_time = total_time + element.usage;
        });
        setState(() {
          app_data = infos;
          app = apps;
          app_data.sort((a, b) => b.usage.compareTo(a.usage));
        });
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text("A P P   M E T R I C"),
        )),
      ),
      body: pie_chart_data == null && pie_chart_data.isEmpty
          ? Container(
              child: const Text(
                "No data",
                style: TextStyle(color: Colors.orange),
              ),
            )
          : Center(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: showDate,
                    child: Card(
                      color: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child:
                            Text(DateFormat.yMMMMd().format(date).toString()),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${Utils().formatDuration(total_time)}",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SfCircularChart(
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: [
                          DoughnutSeries(
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside,
                            ),
                            innerRadius: "98",
                            dataSource: app_data != null && app_data.isNotEmpty
                                ? app_data.sublist(0, 4)
                                : [],
                            xValueMapper: (dynamic app, _) =>
                                app.appName.toString().capitalize(),
                            yValueMapper: (dynamic app, _) =>
                                app.usage.inMinutes,
                            dataLabelMapper: (dynamic app, _) =>
                                app.appName.toString().capitalize(),
                          )
                        ],
                      )
                    ],
                  ),
                  buildBody(),
                ],
              ),
            ),
    );
  }

  buildBody() {
    List<AppUsageInfo> app_data_list =
        app_data.where((element) => element.usage.inSeconds >= 60).toList();

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: app_data_list.length,
        itemBuilder: (BuildContext context, int idx) {
          var app_name = "";
          CircleAvatar cv = const CircleAvatar(
            child: Icon(Icons.widgets),
            backgroundColor: Colors.white,
          );

          if (app != null && app.isNotEmpty) {
            app.forEach((element) {
              if (element.packageName == app_data_list[idx].packageName) {
                app_name = element.appName;
                if (element is ApplicationWithIcon) {
                  cv = CircleAvatar(
                    backgroundImage: MemoryImage(element.icon),
                    backgroundColor: Colors.white,
                  );
                }
              }
            });
          }
          return Column(
            children: [
              ListTile(
                leading: cv,
                title: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(app_name != null && app_name.isNotEmpty
                      ? app_name.capitalize()
                      : app_data_list[idx].appName.capitalize()),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(Utils().formatDuration(app_data_list[idx].usage)),
                ),
              ),
              const Divider(
                thickness: 4,
              )
            ],
          );
        },
      ),
    );
  }

  showDate() {
    return showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(DateTime.now().year - 100),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        date = value!;
        total_time = Duration();
      });
      getUsageStats();
    });
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
