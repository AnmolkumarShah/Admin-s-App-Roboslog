import 'package:admin_app/Provider/adminProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:provider/provider.dart';

import './Helpers/custom_route.dart';
import './Provider/ProductProvider.dart';
import './Provider/order.dart';
import './Provider/userProvider.dart';
import './Screens/ProductDetailsScreen.dart';
import './Screens/auth_screen.dart';
import './Screens/editScreen.dart';
import './Screens/homeScreen.dart';
import './Screens/manageScreen.dart';
import './Screens/screen2.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AdminProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Order(),
        ),
      ],
      child: MaterialApp(
        title: 'Admin App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            },
          ),
          primarySwatch: Colors.amber,
          accentColor: Colors.red[300],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Screen2();
                } else if (snapshot.hasData) {
                  return HomeScreen();
                } else {
                  return AuthScreen();
                }
              },
            );
          },
        ),
        routes: {
          ManageScreen.RouteName: (ctx) => ManageScreen(),
          EditScreen.RouteName: (ctx) => EditScreen(),
          ProductDetail.RouteName: (ctx) => ProductDetail(),
        },
      ),
    );
  }
}
