import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/chat_room.dart';
import 'constants.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => ChatsState();
}

class ChatsState extends State<Chats> {
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            FontAwesomeIcons.chevronLeft,
            size: 15,
            color: bgColor == Colors.white ? Colors.black : Colors.white,
          ),
        ),
        actions: [
          IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.video,
              size: 15,
              color: bgColor == Colors.white ? Colors.black : Colors.white,
            ),
          ),
          IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.pen,
              size: 15,
              color: bgColor == Colors.white ? Colors.black : Colors.white,
            ),
          ),
        ],
        title: Text(
          "Direct",
          style: GoogleFonts.abel(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: bgColor == Colors.white ? Colors.black : Colors.white,
          ),
        ),
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      bottomSheet: Container(
          decoration: BoxDecoration(
            color: bgColor.withOpacity(.95),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.camera,
                size: 15,
                color: Colors.blueAccent,
              ),
              const SizedBox(width: 10),
              Text(
                "Camera",
                style: GoogleFonts.abel(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          )),
      body: Column(
        children: [
          Flexible(
            child: TextField(
              onChanged: (String value) {},
              controller: searchController,
              cursorColor: Colors.blue,
              cursorRadius: const Radius.circular(15),
              maxLength: null,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide:
                        const BorderSide(color: Colors.transparent, width: 0),
                  ),
                  hintText: "Search",
                  hintStyle: GoogleFonts.abel(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  focusColor: Colors.blue,
                  prefixIcon: const Icon(
                    FontAwesomeIcons.searchengin,
                    size: 20,
                    color: Colors.grey,
                  )),
              style: GoogleFonts.abel(
                color: bgColor == Colors.white ? Colors.black : Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("messages")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                      snapshot.data!.docs;
                  return data.isNotEmpty
                      ? ListView.builder(
                          addAutomaticKeepAlives: true,
                          addRepaintBoundaries: true,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 100,
                          itemBuilder: (BuildContext context, int index) {
                            return FutureBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              future: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(data[index].id)
                                  .get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.hasData) {
                                  Map<String, dynamic> remoteData =
                                      snapshot.data!.data()!;
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ChatRoom(
                                              remoteData: remoteData,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              remoteData["profile_picture_url"],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                remoteData["username"],
                                                style: GoogleFonts.abel(
                                                  fontSize: 16,
                                                  color: bgColor == Colors.white
                                                      ? Colors.black
                                                      : Colors.white,
                                                ),
                                              ),
                                              Text(
                                                remoteData["about"],
                                                style: GoogleFonts.abel(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            onPressed: () {},
                                            icon: Icon(
                                              FontAwesomeIcons.camera,
                                              size: 15,
                                              color: bgColor == Colors.white
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                    ),
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: snapshot.error.toString());
                                  return Container();
                                }
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "There is no chats",
                            style: GoogleFonts.abel(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: bgColor == Colors.white
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
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
            ),
          ),
        ],
      ),
    );
  }
}
