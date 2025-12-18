import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/budget.dart';
import '../models/expense.dart';

class BudgetProvider extends ChangeNotifier {
  late Box<Budget> _budgetBox;
  late Box<Expense> _expenseBox;

  BudgetProvider() {
    _budgetBox = Hive.box<Budget>('budgets');
    _expenseBox = Hive.box<Expense>('expenses');
  }

  List<Budget> get budgets => _budgetBox.values.toList();

  void setBudget(String category, double limit) {
    final index = _budgetBox.values.toList().indexWhere(
      (b) => b.category == category,
    );

    if (index == -1) {
      _budgetBox.add(Budget(category: category, limit: limit));
    } else {
      final budget = _budgetBox.getAt(index)!;
      budget.limit = limit;
      budget.save();
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
