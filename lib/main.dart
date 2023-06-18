import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:road_emergency/screens/admin/add_center.dart';
import 'package:road_emergency/screens/admin/admin_centers.dart';
import 'package:road_emergency/screens/admin/admin_home.dart';
import 'package:road_emergency/screens/auth/admin_login.dart';
import 'package:road_emergency/screens/auth/center_login.dart';
import 'package:road_emergency/screens/auth/login_page.dart';
import 'package:road_emergency/screens/auth/signup_page.dart';
import 'package:road_emergency/screens/centers/add_service.dart';
import 'package:road_emergency/screens/centers/add_technical.dart';
import 'package:road_emergency/screens/centers/center_home.dart';
import 'package:road_emergency/screens/centers/center_service.dart';
import 'package:road_emergency/screens/centers/center_technicals.dart';
import 'package:road_emergency/screens/user/add_opinion.dart';
import 'package:road_emergency/screens/user/user_center.dart';
import 'package:road_emergency/screens/user/user_home.dart';
import 'package:road_emergency/screens/user/user_opinions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ?  UserLogin()
          : FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com'
              ? const AdminHome()
              : FirebaseAuth.instance.currentUser!.displayName == 'مركز'
                  ? const CenterHome()
                  : UserHome(),
      routes: {
        SignUp.routeName: (ctx) => SignUp(),
        UserLogin.routeName: (ctx) => UserLogin(),
        AdminLogin.routeName: (ctx) => AdminLogin(),
        CenterLogin.routeName: (ctx) => CenterLogin(),
        AdminHome.routeName: (ctx) => AdminHome(),
        CenterHome.routeName: (ctx) => CenterHome(),
        AdminCenters.routeName: (ctx) => AdminCenters(),
        AddCenters.routeName: (ctx) => AddCenters(),
        UserHome.routeName: (ctx) => UserHome(),
        UserCenters.routeName: (ctx) => UserCenters(),
        UserOpinions.routeName: (ctx) => UserOpinions(),
        AddOpinion.routeName: (ctx) => AddOpinion(),
      },
    );
  }
}
