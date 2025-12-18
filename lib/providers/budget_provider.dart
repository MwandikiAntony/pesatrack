import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/budget.dart';
import '../models/expense.dart';

class BudgetProvider extends ChangeNotifier {
  final Box<Budget> _budgetBox = Hive.box<Budget>('budgets');
  final Box<Expense> _expenseBox = Hive.box<Expense>('expenses');

  List<Budget> get budgets => _budgetBox.values.toList();

  void setBudget(String category, double limit) {
    final existing = _budgetBox.values.firstWhere(
      (b) => b.category == category,
      orElse: () => Budget(category: category, limit: 0),
    );

    if (existing.limit == 0) {
      _budgetBox.add(Budget(category: category, limit: limit));
    } else {
      existing
        ..limit = limit
        ..save();
    }
    notifyListeners();
  }

  double spentForCategory(String category) {
    final now = DateTime.now();
    return _expenseBox.values
        .where(
          (e) =>
              e.category == category &&
              e.date.month == now.month &&
              e.date.year == now.year,
        )
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  bool isExceeded(String category) {
    final budget = _budgetBox.values.firstWhere(
      (b) => b.category == category,
      orElse: () => Budget(category: category, limit: 0),
    );

    if (budget.limit == 0) return false;
    return spentForCategory(category) > budget.limit;
  }
}
