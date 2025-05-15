import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/authentication/domain/view model/home_auth_model.dart';
import 'features/authentication/presentation/screens/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
