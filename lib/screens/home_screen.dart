import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/budget_provider.dart';
import '../models/expense.dart';
import '../utils/categories.dart';
import 'edit_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategory;
  DateTimeRange? selectedDateRange;

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final budgetProvider = context.read<BudgetProvider>();

    // Filtered expenses
    final filteredExpenses = expenseProvider.expenses.where((expense) {
      final matchesCategory =
          selectedCategory == null || expense.category == selectedCategory;
      final matchesDate =
          selectedDateRange == null ||
          (expense.date.isAfter(
                selectedDateRange!.start.subtract(const Duration(days: 1)),
              ) &&
              expense.date.isBefore(
                selectedDateRange!.end.add(const Duration(days: 1)),
              ));
      return matchesCategory && matchesDate;
    }).toList();

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

          // 🔹 Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Category Filter
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Filter by Category'),
                    value: selectedCategory,
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All')),
                      ...expenseCategories.map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => selectedCategory = value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Date Range Filter
                ElevatedButton.icon(
                  onPressed: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDateRange: selectedDateRange,
                    );
                    if (picked != null) {
                      setState(() => selectedDateRange = picked);
                    }
                  },
                  icon: const Icon(Icons.date_range),
                  label: const Text('Date'),
                ),
                if (selectedDateRange != null)
                  IconButton(
                    onPressed: () => setState(() => selectedDateRange = null),
                    icon: const Icon(Icons.clear),
                  ),
              ],
            ),
          ),

          // 🔹 Expense List / Empty State
          Expanded(
            child: filteredExpenses.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
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
                          expenseProvider.deleteExpense(
                            expenseProvider.expenses.indexOf(expense),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            onTap: () {
                              // Launch Edit Expense Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditExpenseScreen(
                                    expense: expense,
                                    index: expenseProvider.expenses.indexOf(
                                      expense,
                                    ),
                                  ),
                                ),
                              );
                            },
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
