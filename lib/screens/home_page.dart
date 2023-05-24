import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personal_accountant/screens/reminder_page.dart';

import '../controllers/hive_controller.dart';
import '../model/reminder_model.dart';
import '../utils/helpers.dart';
import '../widgets/empty_page.dart';
import '../widgets/reaminder_card.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ReminderBox reminderBox = ReminderBox();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: reminderBox.box.listenable(),
              builder: (context, Box<Reminder> reminders, widget) {
                List<Reminder> listFromBox = reminders.values.toList();
                //reversing the list to show new items on top
                List<Reminder> remindersList = listFromBox.reversed.toList();
                if (remindersList.isNotEmpty) {
                  return ListView.builder(
                    padding: EdgeInsets.all(12.0),
                    physics: const BouncingScrollPhysics(),
                    itemCount: remindersList.length,
                    itemBuilder: (context, index) {
                      var reminder = remindersList[index];
                      return ReminderCard(reminder);
                    },
                  );
                } else {
                  return EmptyPage();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab',
        child: Icon(EvaIcons.plus),
        onPressed: () => toPage(context, ReminderPage(isEdit: false)),
      ),
    );
  }
}
