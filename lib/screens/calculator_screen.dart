import 'package:flutter/material.dart';
import '../models/calculator_model.dart';
import '../widgets/calculator_button.dart';
import '../widgets/calculator_display.dart';
import '../services/recent_activity_service.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = '';
  String result = '0';
  String firstNumber = '';
  String operator = '';
  String secondNumber = '';

  final List<CalculatorModel> buttons = [
    CalculatorModel(label: 'AC'),
    CalculatorModel(label: '±'),
    CalculatorModel(label: '%'),
    CalculatorModel(label: '÷', isOperator: true),

    CalculatorModel(label: '7'),
    CalculatorModel(label: '8'),
    CalculatorModel(label: '9'),
    CalculatorModel(label: '×', isOperator: true),

    CalculatorModel(label: '4'),
    CalculatorModel(label: '5'),
    CalculatorModel(label: '6'),
    CalculatorModel(label: '-', isOperator: true),

    CalculatorModel(label: '1'),
    CalculatorModel(label: '2'),
    CalculatorModel(label: '3'),
    CalculatorModel(label: '+', isOperator: true),

    CalculatorModel(label: '0'),
    CalculatorModel(label: '.'),
    CalculatorModel(label: '='),
  ];

  void onButtonPressed(String value) {
    if (value == 'AC') {
      clearCalculator();
      return;
    }

    if (value == '=') {
      calculateResult();
      return;
    }

    if (value == '±') {
      toggleSign();
      return;
    }

    if (value == '%') {
      calculatePercentage();
      return;
    }

    if (['+', '-', '×', '÷'].contains(value)) {
      selectOperator(value);
      return;
    }

    enterNumber(value);
  }

  void enterNumber(String value) {
    setState(() {
      if (operator.isEmpty) {
        if (value == '.' && firstNumber.contains('.')) {
          return;
        }

        firstNumber += value;
        result = firstNumber;
      } else {
        if (value == '.' && secondNumber.contains('.')) {
          return;
        }

        secondNumber += value;
        result = secondNumber;
      }
    });
  }

  void selectOperator(String value) {
    if (firstNumber.isEmpty) return;

    setState(() {
      operator = value;

      expression = '$firstNumber $operator';
    });
  }

  Future<void> calculateResult() async {
    if (firstNumber.isEmpty || operator.isEmpty || secondNumber.isEmpty) {
      return;
    }

    final double first = double.tryParse(firstNumber) ?? 0;
    final double second = double.tryParse(secondNumber) ?? 0;

    double calculation;

    switch (operator) {
      case '+':
        calculation = first + second;
        break;

      case '-':
        calculation = first - second;
        break;

      case '×':
        calculation = first * second;
        break;

      case '÷':
        if (second == 0) {
          setState(() {
            expression = '$firstNumber $operator $secondNumber';
            result = 'Cannot divide by 0';
          });
          return;
        }

        calculation = first / second;
        break;

      default:
        return;
    }

    final formattedResult = formatResult(calculation);

    setState(() {
      expression = '$firstNumber $operator $secondNumber';
      result = formattedResult;

      firstNumber = formattedResult;
      secondNumber = '';
      operator = '';
    });

    await RecentActivityService.addActivity(
      title: 'Calculator',
      subtitle: '$expression = $formattedResult',
      icon: 'calculate',
    );
  }

  void toggleSign() {
    setState(() {
      if (operator.isEmpty && firstNumber.isNotEmpty) {
        if (firstNumber.startsWith('-')) {
          firstNumber = firstNumber.substring(1);
        } else {
          firstNumber = '-$firstNumber';
        }

        result = firstNumber;
      } else if (secondNumber.isNotEmpty) {
        if (secondNumber.startsWith('-')) {
          secondNumber = secondNumber.substring(1);
        } else {
          secondNumber = '-$secondNumber';
        }

        result = secondNumber;
      }
    });
  }

  void calculatePercentage() {
    setState(() {
      if (operator.isEmpty && firstNumber.isNotEmpty) {
        final number = double.tryParse(firstNumber) ?? 0;
        firstNumber = formatResult(number / 100);
        result = firstNumber;
      } else if (secondNumber.isNotEmpty) {
        final number = double.tryParse(secondNumber) ?? 0;
        secondNumber = formatResult(number / 100);
        result = secondNumber;
      }
    });
  }

  void clearCalculator() {
    setState(() {
      expression = '';
      result = '0';
      firstNumber = '';
      operator = '';
      secondNumber = '';
    });
  }

  String formatResult(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(6).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Calculator',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: CalculatorDisplay(expression: expression, result: result),
            ),

            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: buttons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.15,
                  ),
                  itemBuilder: (context, index) {
                    final button = buttons[index];

                    return CalculatorButton(
                      button: button,
                      onTap: () {
                        onButtonPressed(button.label);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
