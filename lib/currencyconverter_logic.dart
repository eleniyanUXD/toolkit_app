double convertCurrency(double amount, String from, String to) {
  Map<String, double> rates = {'NGN': 1, 'USD': 1500, 'GBP': 1800};
  return amount * (rates[to]! / rates[from]!);
}
