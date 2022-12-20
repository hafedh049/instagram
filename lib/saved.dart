import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/constants.dart';
import 'package:shimmer/shimmer.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FontAwesomeIcons.chevronLeft,
            size: 15,
            color: bgColor == Colors.white ? Colors.black : Colors.white,
          ),
        ),
        title: Text(
          "Instagram",
          style: GoogleFonts.abel(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: bgColor == Colors.white ? Colors.black : Colors.white,
          ),
        ),
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .where("saved_list",
                  arrayContains: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                  snapshot.data!.docs;
              return GridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                shrinkWrap: true,
                children: [
                  for (QueryDocumentSnapshot<Map<String, dynamic>> post in data)
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              post.get("post"),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: MediaQuery.of(context).size.width * .3,
                      ),
                    ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.blue,
                child: const SizedBox(
                  width: 100,
                  height: 100,
                ),
              );
            } else {
              Fluttertoast.showToast(msg: snapshot.error.toString());
              return Container();
            }
          },
        ),
      ),
      extendBody: true,
    );
  }
}
