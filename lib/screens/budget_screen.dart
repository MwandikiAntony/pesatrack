import 'package:flutter/material.dart';
import 'package:pesatrack/models/budget.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../utils/categories.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetProvider = context.watch<BudgetProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: ListView(
        children: expenseCategories.map((category) {
          final spent = budgetProvider.spentForCategory(category);
          final budget = budgetProvider.budgets.firstWhere(
            (b) => b.category == category,
            orElse: () => Budget(category: category, limit: 0),
          );

          final percent = budget.limit == 0
              ? 0.0
              : ((spent / budget.limit).clamp(0.0, 1.0)).toDouble();

          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: percent),
                  const SizedBox(height: 8),
                  Text('Spent: KES ${spent.toStringAsFixed(2)}'),
                  Text('Budget: KES ${budget.limit.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => _showSetBudgetDialog(context, category),
                    child: const Text('Set Budget'),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showSetBudgetDialog(BuildContext context, String category) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Set Budget for $category'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount (KES)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null) {
                context.read<BudgetProvider>().setBudget(category, value);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
