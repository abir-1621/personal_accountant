import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personal_accountant/providers/reminder_provider.dart';
import 'package:personal_accountant/screens/HomePage.dart';
import 'package:personal_accountant/screens/home_page.dart';
import 'package:personal_accountant/utils/color_scheme.dart';
import 'package:provider/provider.dart';

import 'model/reminder_model.dart';
import 'model/reminder_type_adapter.dart';


void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ReminderAdapter());
  Hive.registerAdapter(ReminderTypeAdapter()); // Register the adapter for ReminderType
  await Hive.openBox<Reminder>('reminders');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Simple Reminder',
        theme: ThemeData(
          scaffoldBackgroundColor: lightColorScheme.background,
          useMaterial3: true,
          colorScheme: lightColorScheme,
        ),
        darkTheme: ThemeData(
          scaffoldBackgroundColor: darkColorScheme.background,
          useMaterial3: true,
          colorScheme: darkColorScheme,
        ),
        themeMode: ThemeMode.system,
        home: HomePage(),
      ),
    );
  }
}







