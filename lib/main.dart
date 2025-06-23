// import 'package:currency_converter/currency_converter_material_page.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: CurrencyConverterMaterialPage()
//     );
//   }
// }









import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      home: const CurrencyConverterHome(),
    );
  }
}

class CurrencyConverterHome extends StatefulWidget {
  const CurrencyConverterHome({super.key});

  @override
  State<CurrencyConverterHome> createState() => _CurrencyConverterHomeState();
}

class _CurrencyConverterHomeState extends State<CurrencyConverterHome>
    with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  String _convertedValue = "";
  String _fromCurrency = "USD";
  String _toCurrency = "INR";
  bool _showResult = false;

  final List<String> _currencies = ['USD', 'INR', 'EUR', 'JPY'];

  final Map<String, double> _conversionRates = {
    'USD_INR': 83.2,
    'USD_EUR': 0.92,
    'USD_JPY': 156.4,
    'INR_USD': 0.012,
    'INR_EUR': 0.011,
    'INR_JPY': 1.88,
    'EUR_USD': 1.09,
    'EUR_INR': 90.3,
    'EUR_JPY': 170.3,
    'JPY_USD': 0.0064,
    'JPY_INR': 0.53,
    'JPY_EUR': 0.0059,
  };

  void _convert() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      setState(() {
        _convertedValue = "Please enter a valid number.";
        _showResult = true;
      });
      return;
    }

    if (_fromCurrency == _toCurrency) {
      setState(() {
        _convertedValue = "$amount $_toCurrency";
        _showResult = true;
      });
      return;
    }

    final conversionKey = "${_fromCurrency}_$_toCurrency";
    final rate = _conversionRates[conversionKey] ?? 1.0;
    final result = (amount * rate).toStringAsFixed(2);

    setState(() {
      _convertedValue = "$result $_toCurrency";
      _showResult = true;
    });
  }

  Widget _buildDropdown(String value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton2<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items: _currencies
            .map((currency) => DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('💱 Currency Converter'),
        backgroundColor: color.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 15,
                      offset: const Offset(4, 4))
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("Enter Amount"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "e.g. 100",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildDropdown(_fromCurrency, (val) => setState(() => _fromCurrency = val!))),
                      const SizedBox(width: 10),
                      const Icon(Icons.swap_horiz),
                      const SizedBox(width: 10),
                      Expanded(child: _buildDropdown(_toCurrency, (val) => setState(() => _toCurrency = val!))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _convert,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: color.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Convert"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            AnimatedOpacity(
              opacity: _showResult ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: _showResult
                  ? Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 12,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _convertedValue,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}