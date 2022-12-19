import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/homescreen.dart';
import 'package:instagram/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool obscure = true;
  int genderIndex = 1;
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Widget gender(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border:
            Border.all(color: genderIndex == index ? Colors.blue : Colors.grey),
      ),
      width: 60,
      height: 40,
      child: Icon(
        index == 1 ? FontAwesomeIcons.person : FontAwesomeIcons.personDress,
        size: 30,
        color: genderIndex == index ? Colors.blue : Colors.grey,
      ),
    );
  }

  GlobalKey imageState = GlobalKey();

  void selectPicture(bool state) async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: state ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 100,
      );
      if (image != null) {
        CroppedFile? croppedImage = await ImageCropper().cropImage(
          sourcePath: image.path,
          compressQuality: 100,
          compressFormat: ImageCompressFormat.png,
          uiSettings: [
            AndroidUiSettings(
              backgroundColor: bgColor,
              activeControlsWidgetColor: Colors.blue,
              cropFrameColor: Colors.blue,
              toolbarTitle: "Image Cropping",
            )
          ],
        );
        if (croppedImage != null) {
          imageState.currentState!.setState(() {
            selectedImage = File(croppedImage.path);
          });
        }
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  File? selectedImage;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
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
              const SizedBox(height: 30),
              Text(
                'Sign up to see photos and videos from your friends',
                style: GoogleFonts.acme(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.facebook,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text(
                      'Sign-In with Facebook',
                      style: GoogleFonts.acme(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 0.5,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    ' OR ',
                    style: GoogleFonts.acme(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: bgColor,
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                onPressed: () {
                                  selectPicture(true);
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.camera,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                onPressed: () {
                                  selectPicture(false);
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.image,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: StatefulBuilder(
                    key: imageState,
                    builder: (context, snapshot) {
                      return selectedImage == null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: CachedNetworkImageProvider(
                                  genderIndex == 2
                                      ? "https://firebasestorage.googleapis.com/v0/b/instagram-a0976.appspot.com/o/no_female.jpeg?alt=media&token=584203ae-f8f2-47b9-a206-95217c273abf"
                                      : "https://firebasestorage.googleapis.com/v0/b/instagram-a0976.appspot.com/o/no_male.jpeg?alt=media&token=debeb408-f55f-40eb-8097-065657078148"),
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(selectedImage!),
                            );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "E-mail is mandatory";
                        } else if (!value
                            .contains(RegExp(r"[a-z]\w+\@\w+\.\w"))) {
                          return "Eg : abc@xyz.com";
                        }
                        return null;
                      },
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      cursorRadius: const Radius.circular(15),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.grey,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0),
                        ),
                      ),
                      controller: emailController,
                      style: GoogleFonts.abel(
                          color: bgColor == Colors.white
                              ? Colors.black
                              : Colors.white,
                          fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Username can't be empty";
                        } else if (!value.contains(RegExp(r"[a-z]\w+"))) {
                          return "username should start with a letter and contains alphanumerics & _";
                        }
                        return null;
                      },
                      controller: usernameController,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      cursorRadius: const Radius.circular(15),
                      decoration: InputDecoration(
                        hintText: 'Username',
                        prefixIcon: const Icon(
                          FontAwesomeIcons.userAstronaut,
                          color: Colors.grey,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0),
                        ),
                      ),
                      style: GoogleFonts.abel(
                          color: bgColor == Colors.white
                              ? Colors.black
                              : Colors.white,
                          fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Phone number is mandatory";
                        } else if (!value
                            .contains(RegExp(r"(\+?\d{1,3})?[\d ]+"))) {
                          return "Eg : +216 22 147 987";
                        }
                        return null;
                      },
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: (String value) {},
                      cursorColor: Colors.blue,
                      cursorRadius: const Radius.circular(15),
                      decoration: InputDecoration(
                        hintText: 'Phone',
                        prefixIcon: const Icon(
                          FontAwesomeIcons.phone,
                          color: Colors.grey,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 0),
                        ),
                      ),
                      style: GoogleFonts.abel(
                          color: bgColor == Colors.white
                              ? Colors.black
                              : Colors.white,
                          fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    StatefulBuilder(
                      builder: (BuildContext context,
                          void Function(void Function()) setS) {
                        return TextFormField(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Password is mandatory";
                            } else if (!value.contains(RegExp(r"\w{6,}"))) {
                              return "password length must be >= 6";
                            }
                            return null;
                          },
                          controller: passwordController,
                          onChanged: (String value) {},
                          cursorColor: Colors.blue,
                          cursorRadius: const Radius.circular(15),
                          obscureText: obscure,
                          decoration: InputDecoration(
                            hintText: 'Password',
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
                                obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                          ),
                          style: GoogleFonts.abel(
                              color: bgColor == Colors.white
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 16),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    StatefulBuilder(
                      builder: (BuildContext context,
                          void Function(void Function()) setS) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              onTap: () {
                                setS(
                                  () {
                                    genderIndex = 1;
                                  },
                                );
                                imageState.currentState!.setState(() {});
                              },
                              child: gender(1),
                            ),
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              onTap: () {
                                setS(
                                  () {
                                    genderIndex = 2;
                                  },
                                );
                                imageState.currentState!.setState(() {});
                              },
                              child: gender(2),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setS) {
                  return InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () async {
                      try {
                        if (formKey.currentState!.validate()) {
                          if (selectedImage != null) {
                            setS(
                              () {
                                loading = true;
                              },
                            );
                            Fluttertoast.showToast(
                              msg: "please wait a few seconds",
                              backgroundColor: Colors.blue,
                              fontSize: 16,
                              gravity: ToastGravity.BOTTOM,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG,
                            );

                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailController.text
                                        .toLowerCase()
                                        .trim(),
                                    password: passwordController.text.trim());
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailController.text
                                        .toLowerCase()
                                        .trim(),
                                    password: passwordController.text.trim());
                            await FirebaseStorage.instance
                                .ref("users_profile_pictures/")
                                .child(FirebaseAuth.instance.currentUser!.uid)
                                .putFile(selectedImage!)
                                .then(
                              (TaskSnapshot task) async {
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .set(
                                  {
                                    "uid":
                                        FirebaseAuth.instance.currentUser!.uid,
                                    "username": usernameController.text.trim(),
                                    "email": emailController.text
                                        .toLowerCase()
                                        .trim(),
                                    "password": passwordController.text.trim(),
                                    "timestamp": Timestamp.now(),
                                    "gender": genderIndex == 1 ? "M" : "F",
                                    "phone_number": phoneController.text.trim(),
                                    "profile_picture_url":
                                        await task.ref.getDownloadURL(),
                                    "about": "",
                                    "posts_list": [],
                                    "stories_list": [],
                                    "saved_posts_list": [],
                                    "followers_list": [],
                                    "following_list": [],
                                  },
                                );
                              },
                            );
                            // ignore: use_build_context_synchronously
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: "please choose a picture",
                              backgroundColor: Colors.blue,
                              fontSize: 16,
                              gravity: ToastGravity.BOTTOM,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG,
                            );
                          }
                        }
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: e.toString(),
                          backgroundColor: Colors.blue,
                          fontSize: 16,
                          gravity: ToastGravity.BOTTOM,
                          textColor: Colors.white,
                          toastLength: Toast.LENGTH_LONG,
                        );
                        setS(
                          () {
                            loading = false;
                          },
                        );
                      }
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: !loading
                            ? Text(
                                'Sign-Up',
                                style: GoogleFonts.acme(
                                  fontSize: 18,
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
                },
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'By signing up, you agree to our',
                    style: GoogleFonts.abel(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Terms & Privacy Policy.',
                    style: GoogleFonts.abel(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
                      builder: (context) => const SignIn(),
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Have an account? ",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: "Sign In",
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
