import 'package:flutter/material.dart';

import '../models/date_calculator_model.dart';
import '../widgets/date_input_card.dart';
import '../widgets/date_result_card.dart';

class DateCalculatorScreen extends StatefulWidget {
  const DateCalculatorScreen({super.key});

  @override
  State<DateCalculatorScreen> createState() => _DateCalculatorScreenState();
}

class _DateCalculatorScreenState extends State<DateCalculatorScreen> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));

  DateCalculatorModel? calculation;

  Future<void> selectStartDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return;

    setState(() {
      startDate = selectedDate;
      calculation = null;
    });
  }

  Future<void> selectEndDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return;

    setState(() {
      endDate = selectedDate;
      calculation = null;
    });
  }

  void calculateDifference() {
    final difference = endDate.difference(startDate).inDays;

    if (difference < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End date cannot be earlier than start date.'),
        ),
      );
      return;
    }

    setState(() {
      calculation = DateCalculatorModel(
        startDate: startDate,
        endDate: endDate,
        totalDays: difference,
      );
    });
  }

  void clearCalculator() {
    setState(() {
      startDate = DateTime.now();
      endDate = DateTime.now().add(const Duration(days: 1));
      calculation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Date Calculator',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Calculate date difference',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Find the number of days between two dates.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 28),

              DateInputCard(
                title: 'Start Date',
                date: startDate,
                onTap: selectStartDate,
              ),

              const SizedBox(height: 20),

              DateInputCard(
                title: 'End Date',
                date: endDate,
                onTap: selectEndDate,
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: calculateDifference,
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text(
                    'Calculate Difference',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              if (calculation != null) ...[
                const SizedBox(height: 28),

                DateResultCard(totalDays: calculation!.totalDays),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
