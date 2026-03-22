import 'package:flutter/material.dart';
import 'package:timely_app/homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Timely());
}

class Timely extends StatelessWidget {
  const Timely({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
