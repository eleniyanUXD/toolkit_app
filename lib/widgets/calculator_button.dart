import 'package:flutter/material.dart';
import '../models/calculator_model.dart';

class CalculatorButton extends StatelessWidget {
  final CalculatorModel button;
  final VoidCallback onTap;

  const CalculatorButton({
    super.key,
    required this.button,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: button.isOperator ? Colors.blue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: button.icon != null
              ? Icon(
                  button.icon,
                  size: 24,
                  color: button.isOperator ? Colors.white : Colors.black,
                )
              : Text(
                  button.label,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: button.isOperator ? Colors.white : Colors.black,
                  ),
                ),
        ),
      ),
    );
  }
}
