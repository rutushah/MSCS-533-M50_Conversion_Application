import 'package:flutter/material.dart';
import './screens/HomeScreen.dart';

void main() {
  runApp(const ConversionApp());
}

class ConversionApp extends StatelessWidget {
  const ConversionApp({super.key});

  //variable declaration section
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Convertor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true
      ),
      home: const HomeScreen(
        title: 'Measures Convertor'
      ),
    );
}
}


