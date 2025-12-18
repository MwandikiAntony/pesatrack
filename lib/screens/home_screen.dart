import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('PesaTrack')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Total: KES ${expenseProvider.totalExpenses.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: expenseProvider.expenses.isEmpty
                ? const Center(child: Text('No expenses yet'))
                : ListView.builder(
                    itemCount: expenseProvider.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenseProvider.expenses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.attach_money),
                          title: Text(expense.category),
                          subtitle: Text(
                            '${expense.note} • ${expense.date.toLocal().toString().split(' ')[0]}',
                          ),
                          trailing: Text(
                            'KES ${expense.amount.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
