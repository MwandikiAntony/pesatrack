import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/expense.dart';
import 'screens/main_layout.dart';
import 'package:provider/provider.dart';
import 'providers/expense_provider.dart';
import 'models/budget.dart';
import 'providers/budget_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>('expenses');

  Hive.registerAdapter(BudgetAdapter());
  await Hive.openBox<Budget>('budgets');

  runApp(const PesaTrackApp());
}

class PesaTrackApp extends StatelessWidget {
  const PesaTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
      ],
      child: MaterialApp(
        title: 'PesaTrack',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
        home: const MainLayout(),
      ),
    );
  }
}
