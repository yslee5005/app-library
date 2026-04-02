import 'package:flutter/material.dart';

void main() {
  runApp(const PetLifeApp());
}

class PetLifeApp extends StatelessWidget {
  const PetLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pet Life',
      home: Scaffold(
        body: Center(child: Text('Pet Life')),
      ),
    );
  }
}
