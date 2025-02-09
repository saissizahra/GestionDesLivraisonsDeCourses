import 'package:flutter/material.dart';
import 'package:mkadia/login/home.dart';
import 'package:mkadia/provider/cartProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
   MultiProvider(
      providers:  [
        ChangeNotifierProvider(
          create: (_)=> CartProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Zabal', 
        ),
        home:  const HomeScreen(),
      ),
    );

}

