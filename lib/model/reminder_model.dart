import 'package:hive/hive.dart';
import 'package:personal_accountant/enums/debt_type.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 0)
class Reminder extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String? description;

  @HiveField(2)
  final DateTime? dateTime;

  @HiveField(3)
  final bool isDone;

  @HiveField(4)
  final ReminderType? type;

  Reminder({
    required this.title,
    required this.description,
    required this.dateTime,
    this.isDone = false,
    required this.type
  });
}
