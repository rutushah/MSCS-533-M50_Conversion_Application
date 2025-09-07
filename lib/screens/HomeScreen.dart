import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../logic/conversion_logic.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _valueController = TextEditingController();

  String? _fromUnit;
  String? _toUnit;
  String? _errorMessage;
  String? _result;

  late final List<String> _units;

  @override
  void initState() {
    super.initState();
    _units = UnitCatalog.allUnits();
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _performConversion() {
    setState(() {
      _errorMessage = null;
      _result = null;

      final raw = _valueController.text.trim();
      final value = double.tryParse(raw);
      if (value == null) {
        _errorMessage = 'Please enter a valid number';
        return;
      }
      if (_fromUnit == null || _toUnit == null || _fromUnit!.isEmpty || _toUnit!.isEmpty) {
        _errorMessage = 'Please select both units';
        return;
      }

      final result = convertUnits(value, _fromUnit!, _toUnit!);
      if (result == null) {
        _errorMessage = 'Conversion not possible between selected units';
        return;
      }

      _result = result.toStringAsFixed(3);
    });
  }

  void _swapUnits() {
    if (_fromUnit == null && _toUnit == null) return;
    setState(() {
      final tmp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = tmp;
      // Optionally re-run conversion if a value exists
      if (_valueController.text.trim().isNotEmpty) {
        _performConversion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Value', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _valueController,
              decoration: InputDecoration(
                hintText: 'Enter value to convert',
                errorText: _errorMessage,
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
              onSubmitted: (_) => _performConversion(),
            ),
            const SizedBox(height: 16),

            Text('From', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _fromUnit,
              items: _units
                  .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                  .toList(),
              onChanged: (v) => setState(() => _fromUnit = v),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('To', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _toUnit,
                        items: _units
                            .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                            .toList(),
                        onChanged: (v) => setState(() => _toUnit = v),
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  onPressed: _swapUnits,
                  icon: const Icon(Icons.swap_horiz),
                  tooltip: 'Swap units',
                ),
              ],
            ),
            const SizedBox(height: 20),

            FilledButton(
              onPressed: _performConversion,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                child: Text('Convert'),
              ),
            ),
            const SizedBox(height: 20),

            if (_result != null)
              _ResultCard(
                inputValue: _valueController.text.trim(),
                fromUnit: _fromUnit!,
                toUnit: _toUnit!,
                result: _result!,
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String inputValue;
  final String fromUnit;
  final String toUnit;
  final String result;

  const _ResultCard({
    required this.inputValue,
    required this.fromUnit,
    required this.toUnit,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle.merge(
          style: theme.textTheme.titleMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Result'),
              const SizedBox(height: 8),
              Text('$inputValue $fromUnit → $result $toUnit'),
            ],
          ),
        ),
      ),
    );
  }
}
