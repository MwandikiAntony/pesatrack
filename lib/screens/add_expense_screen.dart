import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<ExpenseProvider>().addExpense(
              Expense(
                amount: 500,
                category: 'Food',
                date: DateTime.now(),
                note: 'Lunch',
              ),
            );
          },
          child: const Text('Add Test Expense'),
        ),
      ),
    );
  }
}
