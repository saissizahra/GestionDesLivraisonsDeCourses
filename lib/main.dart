import 'package:flutter/material.dart';
import 'package:flutter_application_catmkadia/provider/cartProvider.dart';
import 'package:flutter_application_catmkadia/views/home/widget/navbar.dart';
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
        // Ajoute ici les providers si nécessaire
        ChangeNotifierProvider(
          create: (_)=> CartProvider(),

        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Zabal', // Utilisation de la police personnalisée
        ),
        home:  const BottomNavBar(),
      ),
    );

}

