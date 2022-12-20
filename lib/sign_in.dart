import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/homescreen.dart';
import 'package:instagram/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool obscure = true;
  bool loading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                "Instagram",
                style: GoogleFonts.acme(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                onChanged: (String value) {},
                cursorColor: Colors.blue,
                cursorRadius: const Radius.circular(15),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
                    ),
                    hintText: "E-mail",
                    hintStyle: GoogleFonts.abel(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    focusColor: Colors.blue,
                    prefixIcon: const Icon(
                      FontAwesomeIcons.envelope,
                      size: 20,
                      color: Colors.grey,
                    )),
                style: GoogleFonts.abel(
                  color: bgColor == Colors.white ? Colors.black : Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setS) {
                  return TextField(
                    onChanged: (String value) {},
                    controller: passwordController,
                    cursorColor: Colors.blue,
                    cursorRadius: const Radius.circular(15),
                    obscureText: obscure,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 0),
                      ),
                      suffixIcon: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        onPressed: () {
                          setS(
                            () {
                              obscure = !obscure;
                            },
                          );
                        },
                        icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                      hintText: "Password",
                      hintStyle: GoogleFonts.abel(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      focusColor: Colors.blue,
                      prefixIcon: const Icon(
                        FontAwesomeIcons.keybase,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    style: GoogleFonts.abel(
                      color:
                          bgColor == Colors.white ? Colors.black : Colors.white,
                      fontSize: 16,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  "reset password",
                  style: GoogleFonts.abel(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              StatefulBuilder(builder:
                  (BuildContext context, void Function(void Function()) setS) {
                return InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: () async {
                    try {
                      setS(
                        () {
                          loading = true;
                        },
                      );
                      Fluttertoast.showToast(
                        msg: "please wait a few seconds",
                        fontSize: 16,
                        gravity: ToastGravity.BOTTOM,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_LONG,
                      );
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text.toLowerCase().trim(),
                          password: passwordController.text.trim());

                      // ignore: use_build_context_synchronously
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    } catch (e) {
                      setS(
                        () {
                          loading = false;
                        },
                      );
                      Fluttertoast.showToast(
                        msg: e.toString(),
                        fontSize: 16,
                        gravity: ToastGravity.BOTTOM,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: !loading
                          ? Text(
                              "Sign-In",
                              style: GoogleFonts.abel(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color:
                          bgColor == Colors.white ? Colors.black : Colors.white,
                      height: .5,
                    ),
                  ),
                  Text(
                    " OR ",
                    style: GoogleFonts.abel(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color:
                          bgColor == Colors.white ? Colors.black : Colors.white,
                      height: .5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    FontAwesomeIcons.facebook,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Sign-In with Facebook",
                    style: GoogleFonts.abel(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 280),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color:
                          bgColor == Colors.white ? Colors.black : Colors.white,
                      height: .5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
