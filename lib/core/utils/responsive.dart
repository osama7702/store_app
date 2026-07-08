/// Responsive helpers for grid layouts.
class Responsive {
  const Responsive._();

  /// 2 columns on phones, 3 on small tablets, 4 on large tablets/desktop.
  static int gridColumns(double width) {
    if (width >= 1100) return 4;
    if (width >= 720) return 3;
    return 2;
  }
}
