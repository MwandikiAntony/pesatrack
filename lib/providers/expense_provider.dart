import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  late final Box<Expense> _expenseBox;

  ExpenseProvider() {
    _initBox();
  }

  Future<void> _initBox() async {
    _expenseBox = await Hive.openBox<Expense>('expenses');
    notifyListeners();
  }

  List<Expense> get expenses => _expenseBox.values.toList();

  void addExpense(Expense expense) {
    _expenseBox.add(expense);
    notifyListeners();
  }

  double get totalExpenses =>
      expenses.fold(0, (sum, item) => sum + item.amount);
}
