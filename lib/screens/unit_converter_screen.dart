import 'package:flutter/material.dart';
import '../services/unit_service.dart';
import '../services/recent_activity_service.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final controller = TextEditingController();
  final UnitConversionService unitService = UnitConversionService();

  String selectedCategory = 'Temperature';
  String from = 'Celsius';
  String to = 'Fahrenheit';
  double result = 0;

  final Map<String, List<String>> units = {
    'Length': [
      'Meter',
      'Kilometer',
      'Centimeter',
      'Millimeter',
      'Mile',
      'Yard',
      'Foot',
      'Inch',
    ],
    'Weight': ['Kilogram', 'Gram', 'Milligram', 'Pound', 'Ounce'],
    'Volume': ['Liter', 'Milliliter', 'Gallon', 'Quart', 'Pint', 'Cup'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
    'Time': ['Second', 'Minute', 'Hour', 'Day', 'Week'],
    'Area': [
      'Square Meter',
      'Square Kilometer',
      'Square Centimeter',
      'Square Foot',
      'Square Yard',
      'Acre',
      'Hectare',
    ],
    'Speed': [
      'Meters per Second',
      'Kilometers per Hour',
      'Miles per Hour',
      'Feet per Second',
      'Knot',
    ],
    'Data': ['Byte', 'Kilobyte', 'Megabyte', 'Gigabyte', 'Terabyte'],
  };

  final List<String> categories = [
    'Length',
    'Weight',
    'Volume',
    'Temperature',
    'Time',
    'Area',
    'Speed',
    'Data',
  ];

  Future<void> convert() async {
    final input = double.tryParse(controller.text);

    if (input == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid value')),
      );
      return;
    }

    final convertedResult = unitService.convert(
      value: input,
      category: selectedCategory,
      from: from,
      to: to,
    );

    setState(() {
      result = convertedResult;
    });

    await RecentActivityService.addActivity(
      title: 'Unit Converter',
      subtitle: '$input $from → ${convertedResult.toStringAsFixed(2)} $to',
      icon: _getActivityIcon(),
    );
  }

  String _getActivityIcon() {
    switch (selectedCategory) {
      case 'Length':
        return 'length';
      case 'Weight':
        return 'weight';
      case 'Temperature':
        return 'temperature';
      default:
        return 'calculate';
    }
  }

  void changeCategory(String category) {
    final categoryUnits = units[category]!;

    setState(() {
      selectedCategory = category;
      from = categoryUnits.first;
      to = categoryUnits.length > 1 ? categoryUnits[1] : categoryUnits.first;
      result = 0;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUnits = units[selectedCategory]!;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Unit Converter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Category
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  changeCategory(value);
                }
              },
            ),

            const SizedBox(height: 20),

            // Input
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'Enter value',
                prefixIcon: const Icon(Icons.calculate),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // From & To
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: currentUnits.contains(from)
                        ? from
                        : currentUnits.first,
                    decoration: InputDecoration(
                      labelText: 'From',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: currentUnits.map((unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          from = value;
                        });
                      }
                    },
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  icon: const Icon(Icons.swap_horiz, size: 28),
                  onPressed: () {
                    setState(() {
                      final temp = from;
                      from = to;
                      to = temp;
                    });
                  },
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: currentUnits.contains(to) ? to : currentUnits.first,
                    decoration: InputDecoration(
                      labelText: 'To',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: currentUnits.map((unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          to = value;
                        });
                      }
                    },
                  ),
                ),
              ],
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
              child: Column(
                children: [
                  const Text(
                    'Result',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${result.toStringAsFixed(2)} $to',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
