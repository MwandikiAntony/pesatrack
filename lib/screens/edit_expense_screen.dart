import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../utils/categories.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  final int index;

  const EditExpenseScreen({
    super.key,
    required this.expense,
    required this.index,
  });

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController amountController;
  late TextEditingController noteController;
  late String selectedCategory;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );
    noteController = TextEditingController(text: widget.expense.note);
    selectedCategory = widget.expense.category;
    selectedDate = widget.expense.date;
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void _save() {
    if (amountController.text.isEmpty ||
        double.tryParse(amountController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final updatedExpense = Expense(
      amount: double.parse(amountController.text),
      category: selectedCategory,
      date: selectedDate,
      note: noteController.text,
    );

    context.read<ExpenseProvider>().updateExpense(widget.index, updatedExpense);
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Amount
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (KES)',
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: expenseCategories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => selectedCategory = value);
              },
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
              ),
            ),
            const SizedBox(height: 16),

            // Date Picker
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                'Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
              ),
              trailing: TextButton(
                onPressed: _pickDate,
                child: const Text('Pick Date'),
              ),
            ),
            const SizedBox(height: 16),

            // Note
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
