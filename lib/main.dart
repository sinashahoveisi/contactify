import 'package:contactify/groups.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'contactify',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.cyanAccent,
            background: Colors.white
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        )
      ),

      home: const GroupsPage(),
    );
  }
}

