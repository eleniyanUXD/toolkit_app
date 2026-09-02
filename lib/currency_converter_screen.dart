import 'package:flutter/material.dart';
import 'currencyconverter_logic.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final controller = TextEditingController();

  String from = 'NGN';
  String to = 'USD';
  double convertedAmount = 0;

  void convert() {
    final amount = double.tryParse(controller.text) ?? 0;

    if (from == to) {
      setState(() {
        convertedAmount = amount;
      });
      return;
    }

    setState(() {
      convertedAmount = convertCurrency(amount, from, to);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Currency Converter',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Currency Converter',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Amount input
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Amount',
                  prefixIcon: const Icon(Icons.currency_exchange),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // FROM dropdown
              DropdownButtonFormField<String>(
                value: from,
                items: const [
                  DropdownMenuItem(value: 'NGN', child: Text('Nigerian Naira')),
                  DropdownMenuItem(value: 'USD', child: Text('US Dollar')),
                ],
                onChanged: (value) {
                  setState(() => from = value!);
                },
                decoration: InputDecoration(
                  labelText: 'From',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // SWAP button (centered)
              Center(
                child: IconButton(
                  icon: const Icon(Icons.swap_horiz, size: 30),
                  onPressed: () {
                    setState(() {
                      final amount = from;
                      from = to;
                      to = amount;
                    });
                  },
                ),
              ),

              const SizedBox(height: 12),

              // TO dropdown
              DropdownButtonFormField<String>(
                value: to,
                items: const [
                  DropdownMenuItem(value: 'NGN', child: Text('Nigerian Naira')),
                  DropdownMenuItem(value: 'USD', child: Text('US Dollar')),
                ],
                onChanged: (value) {
                  setState(() => to = value!);
                },
                decoration: InputDecoration(
                  labelText: 'To',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Convert button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: convert,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Convert',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Result
              Center(
                child: Text(
                  '$from -> $to: ${convertedAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
