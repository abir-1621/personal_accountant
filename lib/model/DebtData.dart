class DebtData {
  late final int id;
  final String name;
  final int amount;
  final DateTime debtTakenDate;
  final DateTime oweDate;
  final String type;

  DebtData({
    required this.id,
    required this.name,
    required this.amount,
     required this.debtTakenDate,
     required this.oweDate,
    required this.type
  });
}