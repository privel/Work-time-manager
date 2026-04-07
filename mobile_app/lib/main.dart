import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mobile_app/routes/routes.dart';
import 'package:mobile_app/screen/home_screen.dart';
import 'package:mobile_app/services/auth_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await authService.init();

  runApp(const MyApp());
}

final AuthService authService = AuthService();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Demo",
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //   ),
    //   home: Scaffold(
    //     bottomNavigationBar: GNav(

    //     ),
    //   ),
      
    // );
  }
}
