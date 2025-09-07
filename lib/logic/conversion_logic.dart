/// Simple unit conversion by normalizing to a base unit per category.
class UnitCatalog {
  // Categories -> base unit
  static const Map<String, String> _base = {
    'length': 'meters',
    'mass': 'grams',
  };

  // Unit -> (category, factor to base)
  // For length, base = meters. For mass, base = grams.
  static const Map<String, (String category, double toBase)> _units = {
    // length
    'meters': ('length', 1.0),
    'kilometers': ('length', 1000.0),
    'centimeters': ('length', 0.01),
    'inches': ('length', 0.0254),
    'feet': ('length', 0.3048),
    'miles': ('length', 1609.34),

    // mass
    'grams': ('mass', 1.0),
    'kilograms': ('mass', 1000.0),
    'ounces': ('mass', 28.349523125),
    'pounds': ('mass', 453.59237),
  };

  static List<String> allUnits() => _units.keys.toList()..sort();

  static String? categoryOf(String unit) => _units[unit]?.$1;

  static double? toBase(String unit, double value) {
    final entry = _units[unit];
    if (entry == null) return null;
    return value * entry.$2;
  }

  static double? fromBase(String unit, double valueInBase) {
    final entry = _units[unit];
    if (entry == null) return null;
    return valueInBase / entry.$2;
  }

  static bool canConvert(String from, String to) {
    final c1 = categoryOf(from);
    final c2 = categoryOf(to);
    return c1 != null && c1 == c2;
  }
}

/// Convert [value] from [fromUnit] to [toUnit].
/// Returns `double` on success, or `null` if units are incompatible/unknown.
double? convertUnits(double value, String fromUnit, String toUnit) {
  if (!UnitCatalog.canConvert(fromUnit, toUnit)) return null;
  final baseValue = UnitCatalog.toBase(fromUnit, value);
  if (baseValue == null) return null;
  return UnitCatalog.fromBase(toUnit, baseValue);
}
