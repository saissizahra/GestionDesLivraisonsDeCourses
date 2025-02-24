import 'package:flutter/material.dart';
import 'package:mkadia/provider/BottomNavProvider.dart';
import 'package:mkadia/provider/searchProvider';
import 'package:mkadia/views/login/home.dart';
import 'package:mkadia/provider/OrderProvider.dart';
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
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_)=> CartProvider()),
        ChangeNotifierProvider(create: (_)=> OrderProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        
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

