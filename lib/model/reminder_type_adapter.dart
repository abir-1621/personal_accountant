import 'package:hive/hive.dart';

import '../enums/debt_type.dart';

class ReminderTypeAdapter extends TypeAdapter<ReminderType> {
  @override
  final int typeId = 1;

  @override
  ReminderType read(BinaryReader reader) {
    return ReminderType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, ReminderType obj) {
    writer.writeByte(obj.index);
  }
}