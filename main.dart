import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const AgeApp());
}

class AgeApp extends StatelessWidget {
  const AgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AgeHome(),
    );
  }
}

class AgeHome extends StatefulWidget {
  const AgeHome({super.key});

  @override
  State<AgeHome> createState() => _AgeHomeState();
}

class _AgeHomeState extends State<AgeHome> {
  DateTime? birthDate;
  String result = "No result yet";

  void pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        birthDate = date;
      });
      calculateAge();
    }
  }

  void calculateAge() {
    if (birthDate == null) return;

    DateTime today = DateTime.now();

    int years = today.year - birthDate!.year;
    int months = today.month - birthDate!.month;
    int days = today.day - birthDate!.day;

    if (days < 0) {
      months--;
      days += 30;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    setState(() {
      result = "$years years, $months months, $days days";
    });
  }

  void clearResult() {
    setState(() {
      birthDate = null;
      result = "No result yet";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Age Calculator")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cake, size: 70, color: Colors.indigo),

              const SizedBox(height: 20),

              Text(
                birthDate == null
                    ? "Select your birthdate"
                    : DateFormat.yMMMMd().format(birthDate!),
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),







              ElevatedButton(
                onPressed: pickDate,
                child: const Text("Pick Birthdate"),
              ),

              const SizedBox(height: 20),

              Text(
                result,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: (birthDate == null && result == "No result yet")
                    ? null
                    : clearResult,
                icon: const Icon(Icons.delete),
                label: const Text("Clear Result"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}