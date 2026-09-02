import 'package:flutter/material.dart';
import 'unitconverter_logic.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() {
    return _ConverterScreenState();
  }
}

class _ConverterScreenState extends State<ConverterScreen> {
  final controller = TextEditingController();

  String from = 'C';
  String to = 'F';
  double result = 0;

  void convert() {
    final input = double.tryParse(controller.text) ?? 0;

    if (from == to) {
      setState(() {
        result = input;
      });
      return;
    }

    setState(() {
      result = convertTemp(input, from, to);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Unit Converter',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Temperature Converter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Input Field
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter value',
                prefixIcon: const Icon(Icons.thermostat),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // From & To row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: from,
                    decoration: InputDecoration(
                      labelText: 'From',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'C', child: Text('Celsius')),
                      DropdownMenuItem(value: 'F', child: Text('Fahrenheit')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        from = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // Swap Button
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: () {
                    setState(() {
                      final temp = from;
                      from = to;
                      to = temp;
                    });
                  },
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: to,
                    decoration: InputDecoration(
                      labelText: 'To',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'C', child: Text('Celsius')),
                      DropdownMenuItem(value: 'F', child: Text('Fahrenheit')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        to = value!;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Convert Button
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

            //  Result
            Center(
              child: Text(
                'Result: ${result.toStringAsFixed(2)}°$to',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
