
import 'package:famer_map/screens/splash_screen.dart';
import 'package:flutter/material.dart';

Future main()  async{
 
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
   MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Famer Map',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home:  SplashScreen(),
    );
  }
}
