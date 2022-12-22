import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class PicturesInGrid extends StatelessWidget {
  final String uid;
  const PicturesInGrid({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: uid)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
              snapshot.data!.docs;
          return data.isNotEmpty
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return index >= data.length
                        ? Container()
                        : Container(
                            width: MediaQuery.of(context).size.width * .3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  data[index].get("post"),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                  },
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                )
              : Center(
                  child: Text(
                    "No Posts",
                    style: GoogleFonts.abel(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          bgColor == Colors.white ? Colors.black : Colors.white,
                    ),
                  ),
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
      },
    );
  }
}
