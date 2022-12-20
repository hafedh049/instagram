import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/chats.dart';
import 'package:instagram/instagram_title.dart';
import 'package:instagram/post.dart';
import 'package:instagram/saved.dart';
import 'package:instagram/story.dart';
import 'package:shimmer/shimmer.dart';
import 'add_story.dart';
import 'constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? selectedImage;
  List<String> postsList = [];
  void selectPicture(bool state, String username, String pictureURL) async {
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
          Fluttertoast.showToast(
            msg: "Uploading ...",
            fontSize: 16,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG,
          );
          selectedImage = File(croppedImage.path);
          DateTime now = DateTime.now();
          await FirebaseStorage.instance
              .ref("users_posts/${FirebaseAuth.instance.currentUser!.uid}")
              .child(now.toString())
              .putFile(selectedImage!)
              .then(
            (TaskSnapshot task) async {
              await FirebaseFirestore.instance
                  .collection("posts")
                  .doc(
                      "${FirebaseAuth.instance.currentUser!.uid} ${now.toString()}")
                  .set(
                {
                  "uid": FirebaseAuth.instance.currentUser!.uid,
                  "creation_date": now,
                  "post_id":
                      "${FirebaseAuth.instance.currentUser!.uid} ${now.toString()}",
                  "username": username,
                  "profile_picture_url": pictureURL,
                  "reacted_by_me": false,
                  "saved_by_me": false,
                  "post": await task.ref.getDownloadURL(),
                  "reacting_list": [],
                  "comments_list": [],
                  "saved_list": [],
                },
              ).then((value) async {
                postsList.add(
                    "${FirebaseAuth.instance.currentUser!.uid} ${now.toString()}");
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({"posts_list": postsList});
              });
              Fluttertoast.showToast(
                msg: "post successfully uploaded",
                fontSize: 16,
                gravity: ToastGravity.BOTTOM,
                textColor: Colors.white,
                toastLength: Toast.LENGTH_LONG,
              );
              selectedImage = null;
            },
          );
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        fontSize: 16,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic>? data = snapshot.data!.data();
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: <Widget>[
                        const InstagramTitle(),
                        const Spacer(),
                        IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onPressed: () async {
                            selectPicture(false, data!["username"],
                                data["profile_picture_url"]);
                          },
                          icon: Icon(
                            FontAwesomeIcons.squarePlus,
                            size: 15,
                            color: bgColor == Colors.white
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Saved(),
                              ),
                            );
                          },
                          icon: Icon(
                            FontAwesomeIcons.bookmark,
                            size: 15,
                            color: bgColor == Colors.white
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Chats(),
                              ),
                            );
                          },
                          icon: Icon(
                            FontAwesomeIcons.facebookMessenger,
                            size: 15,
                            color: bgColor == Colors.white
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const <Widget>[AddStory()] +
                            <Widget>[
                              for (Map<String, dynamic> story
                                  in data!["stories_list"])
                                const Story()
                            ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.grey.shade400,
                    indent: 5,
                    endIndent: 5,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("posts")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasData) {
                            List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                data = snapshot.data!.docs;
                            if (data.isNotEmpty) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Post(data: data[index].data());
                                },
                              );
                            } else {
                              return Center(
                                child: Text(
                                  'Sorry, no posts are available',
                                  style: GoogleFonts.acme(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }
                          } else {
                            return Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              enabled: true,
                              loop: 10,
                              period: const Duration(milliseconds: 300),
                              baseColor: bgColor,
                              highlightColor: Colors.grey,
                              child: Container(),
                            );
                          }
                        }),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else {
              Fluttertoast.showToast(msg: snapshot.error.toString());
              return Container();
            }
          }),
    );
  }
}
