import '../models/expense.dart';

class AnalyticsService {
  static Map<String, double> categoryTotals(List<Expense> expenses) {
    final Map<String, double> totals = {};

    for (final expense in expenses) {
      totals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return totals;
  }
}
