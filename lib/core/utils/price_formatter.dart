/// Formats prices consistently across the app.
class PriceFormatter {
  const PriceFormatter._();

  static String format(num value) => '\$${value.toStringAsFixed(2)}';
}
