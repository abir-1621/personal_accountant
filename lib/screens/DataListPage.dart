import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../database/DatabaseHelper.dart';
import '../main.dart';
import '../model/DebtData.dart';

class DebtListPage extends StatefulWidget {
  @override
  _DebtListPageState createState() => _DebtListPageState();
}

class _DebtListPageState extends State<DebtListPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? selectedType;
  List<String> types = ['All'];
  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid
            // , iOS: initializationSettingsIOS
            );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _getTypesFromDatabase();
  }
  Future<void> _getTypesFromDatabase() async {
    final List<String> fetchedTypes = await DatabaseHelper.instance.getTypes();
    setState(() {
      types.addAll(fetchedTypes) ;
    });
  }

  Future<void> _showReminder(DateTime oweDate, String debtName) async {
    var scheduledNotificationDateTime = oweDate.subtract(Duration(days: 1, minutes: 5));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      enableLights: true,
      ledColor: Colors.blue,
      ledOnMs: 200,
      ledOffMs: 200,
    );

    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Reminder',
      'You owe $debtName',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debt List'),
      ),
      body: Column(
        children: [
          DropdownButtonFormField<String>(
            value: selectedType,
            onChanged: (value) {
              setState(() {
                selectedType = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Select Type',
            ),
            items: types
                .map((type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
          ),
          Expanded(
            child: FutureBuilder<List<DebtData>>(
              future: _getFilteredDebtList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final debtList = snapshot.data!;
                  return ListView.builder(
                    itemCount: debtList.length,
                    itemBuilder: (context, index) {
                      final debt = debtList[index];
                      return ListTile(
                        title: Text(debt.name),
                        subtitle: Text(
                            'Amount: ${debt.amount}\nDebt Taken: ${DateFormat.yMd().format(debt.debtTakenDate)}\nOwe Date: ${DateFormat.yMd().format(debt.oweDate)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.alarm),
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                _showReminder(selectedDate, debt.name);
                              });
                            }



                          },
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<DebtData>> _getFilteredDebtList() async {
    final allDebtList = await DatabaseHelper.instance.queryData();

    if (selectedType == null || selectedType == 'All') {
      return allDebtList;
    } else{

      return allDebtList.where((debt) => debt.type == selectedType).toList();
  }
    return [];
}



}
