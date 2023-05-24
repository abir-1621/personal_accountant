import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_accountant/model/DebtData.dart';

import '../database/DatabaseHelper.dart';
import 'DataListPage.dart';

class HomePage1 extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  DateTime? debtTakenDate;
  DateTime? oweDate;
  String? selectedType;
  List<String> types = [];

  @override
  void initState() {
    super.initState();
    _getTypesFromDatabase();
  }

  Future<void> _insertTypeToDatabase() async {
    final newType = _typeController.text.trim();
    if (newType.isNotEmpty) {
      await DatabaseHelper.instance.insertType(newType);
      setState(() {
        selectedType = newType;
        _getTypesFromDatabase();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Type inserted successfully.')),
      );
      _typeController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid type.')),
      );
    }
  }

  Future<void> _getTypesFromDatabase() async {
    final List<String> fetchedTypes = await DatabaseHelper.instance.getTypes();
    setState(() {
      types = fetchedTypes;
    });
  }

  Future<void> _saveData() async {
    final String name = _nameController.text.trim();
    final int amount = int.tryParse(_amountController.text.trim()) ?? 0;
    if (name.isNotEmpty &&
        amount > 0 &&
        debtTakenDate != null &&
        oweDate != null) {
      final int id = await DatabaseHelper.instance.insertData(
        DebtData(
          id: 0,
          name: name,
          amount: amount,
          debtTakenDate: debtTakenDate!,
          oweDate: oweDate!,
          type: selectedType!,
        ),
      );
      _nameController.clear();
      _amountController.clear();
      setState(() {
        debtTakenDate = null;
        oweDate = null;
        selectedType = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data saved with id: $id'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all the fields'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debt Tracker'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _typeController,
                  decoration: InputDecoration(
                    labelText: 'Type',
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _insertTypeToDatabase,
                  child: Text('Insert Type'),
                ),



                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                  ),
                ),
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                Text(
                    'Debt Taken Date: ${debtTakenDate != null ? DateFormat.yMd().format(debtTakenDate!) : 'Not selected'}'),
                ElevatedButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        debtTakenDate = selectedDate;
                      });
                    }
                  },
                  child: Text('Select Debt Taken Date'),
                ),
                SizedBox(height: 16),
                Text(
                    'Owe Date: ${oweDate != null ? DateFormat.yMd().format(oweDate!) : 'Not selected'}'),
                ElevatedButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        oweDate = selectedDate;
                      });
                    }
                  },
                  child: Text('Select Owe Date'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Type',
                  ),
                  items: types.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveData,
                  child: Text('Save Data'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DebtListPage()),
                    );
                  },
                  child: Text('Open List'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
