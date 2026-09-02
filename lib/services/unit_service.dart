class UnitConversionService {
  double convert({
    required double value,
    required String category,
    required String from,
    required String to,
  }) {
    if (from == to) {
      return value;
    }

    switch (category) {
      case 'Length':
        return _convertLength(value, from, to);

      case 'Weight':
        return _convertWeight(value, from, to);

      case 'Volume':
        return _convertVolume(value, from, to);

      case 'Time':
        return _convertTime(value, from, to);

      case 'Area':
        return _convertArea(value, from, to);

      case 'Speed':
        return _convertSpeed(value, from, to);

      case 'Data':
        return _convertData(value, from, to);

      case 'Temperature':
        return _convertTemperature(value, from, to);

      default:
        throw Exception('Unsupported conversion category');
    }
  }

  // Length
  double _convertLength(double value, String from, String to) {
    final units = {
      'Meter': 1.0,
      'Kilometer': 1000.0,
      'Centimeter': 0.01,
      'Millimeter': 0.001,
      'Mile': 1609.344,
      'Yard': 0.9144,
      'Foot': 0.3048,
      'Inch': 0.0254,
    };

    return value * (units[from]! / units[to]!);
  }

  // Weight
  double _convertWeight(double value, String from, String to) {
    final units = {
      'Kilogram': 1.0,
      'Gram': 0.001,
      'Milligram': 0.000001,
      'Pound': 0.453592,
      'Ounce': 0.0283495,
    };

    return value * (units[from]! / units[to]!);
  }

  // Volume
  double _convertVolume(double value, String from, String to) {
    final units = {
      'Liter': 1.0,
      'Milliliter': 0.001,
      'Gallon': 3.78541,
      'Quart': 0.946353,
      'Pint': 0.473176,
      'Cup': 0.236588,
    };

    return value * (units[from]! / units[to]!);
  }

  // Time
  double _convertTime(double value, String from, String to) {
    final units = {
      'Second': 1.0,
      'Minute': 60.0,
      'Hour': 3600.0,
      'Day': 86400.0,
      'Week': 604800.0,
    };

    return value * (units[from]! / units[to]!);
  }

  // Area
  double _convertArea(double value, String from, String to) {
    final units = {
      'Square Meter': 1.0,
      'Square Kilometer': 1000000.0,
      'Square Centimeter': 0.0001,
      'Square Foot': 0.092903,
      'Square Yard': 0.836127,
      'Acre': 4046.86,
      'Hectare': 10000.0,
    };

    return value * (units[from]! / units[to]!);
  }

  // Speed
  double _convertSpeed(double value, String from, String to) {
    final units = {
      'Meters per Second': 1.0,
      'Kilometers per Hour': 0.277778,
      'Miles per Hour': 0.44704,
      'Feet per Second': 0.3048,
      'Knot': 0.514444,
    };

    return value * (units[from]! / units[to]!);
  }

  // Data
  double _convertData(double value, String from, String to) {
    final units = {
      'Byte': 1.0,
      'Kilobyte': 1024.0,
      'Megabyte': 1024.0 * 1024.0,
      'Gigabyte': 1024.0 * 1024.0 * 1024.0,
      'Terabyte': 1024.0 * 1024.0 * 1024.0 * 1024.0,
    };

    return value * (units[from]! / units[to]!);
  }

  // Temperature
  double _convertTemperature(double value, String from, String to) {
    double celsius;

    // Convert FROM to Celsius
    switch (from) {
      case 'Celsius':
        celsius = value;
        break;

      case 'Fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;

      case 'Kelvin':
        celsius = value - 273.15;
        break;

      default:
        throw Exception('Unsupported temperature unit');
    }

    // Convert Celsius TO target
    switch (to) {
      case 'Celsius':
        return celsius;

      case 'Fahrenheit':
        return (celsius * 9 / 5) + 32;

      case 'Kelvin':
        return celsius + 273.15;

      default:
        throw Exception('Unsupported temperature unit');
    }
  }
}