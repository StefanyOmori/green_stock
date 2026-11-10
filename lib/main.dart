import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/produto_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProdutoProvider(),
      child: const GreenStockApp(),
    ),
  );
}

class GreenStockApp extends StatelessWidget {
  const GreenStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GreenStock',
      theme: ThemeData(
        primaryColor: const Color(0xFF27834B),
        scaffoldBackgroundColor: const Color(0xFFF2F7F0),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF27834B)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF174D32),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
