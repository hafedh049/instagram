import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: bgColor,
      statusBarColor: bgColor,
      systemStatusBarContrastEnforced: true,
      systemNavigationBarContrastEnforced: true,
    ),
  );
  InternetConnectionChecker().onStatusChange.listen(
    (InternetConnectionStatus status) {
      if (status == InternetConnectionStatus.connected) {
        Fluttertoast.showToast(
            msg: "Connected",
            backgroundColor: Colors.lightGreen,
            fontSize: 16,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      } else {
        Fluttertoast.showToast(
            msg: "Disconnected",
            backgroundColor: Colors.redAccent,
            fontSize: 16,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      }
      play("notif");
    },
  );
  runApp(Main());
  await player.stop();
}

class Main extends StatelessWidget {
  Main({super.key});
  final Future<FirebaseApp> instance = Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDHWHd4GmLqYFdYak1k4rqciF25LBRVdG0",
      appId: "1:47389856113:android:70a9d1db7bbd36f11326d0",
      messagingSenderId: "47389856113",
      projectId: "instagram-a0976",
      storageBucket: "instagram-a0976.appspot.com",
    ),
  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: instance,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot snap) {
                if (snap.data != null) {
                  return const HomeScreen();
                } else {
                  return const SignIn();
                }
              },
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: bgColor,
              body: const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: bgColor,
              body: Center(
                child: Text(
                  "Error :  ${snapshot.error.toString()}",
                  style: GoogleFonts.abel(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
