import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/budget_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final budgetProvider = context.read<BudgetProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('PesaTrack'), centerTitle: true),
      body: Column(
        children: [
          // 🔹 Total Summary
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Spent', style: TextStyle(fontSize: 16)),
                  Text(
                    'KES ${expenseProvider.totalExpenses.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Expense List / Empty State
          Expanded(
            child: expenseProvider.expenses.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    itemCount: expenseProvider.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenseProvider.expenses[index];
                      final isExceeded = budgetProvider.isExceeded(
                        expense.category,
                      );

                      return Dismissible(
                        key: ValueKey(expense.key),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          padding: const EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Delete Expense'),
                              content: const Text(
                                'Are you sure you want to delete this expense?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (_) {
                          expenseProvider.deleteExpense(index);
                        },
                        child: Card(
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isExceeded ? Colors.red : null,
                              ),
                            ),
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

/// 🔹 Empty State Widget
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.receipt_long, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No expenses yet',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(height: 6),
          Text(
            'Add your first expense to get started',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
