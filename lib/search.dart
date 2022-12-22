import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/guest_profile.dart';

class Search extends StatefulWidget {
  const Search({super.key});
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _searchResults = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _searchResultsCopy = [];

  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: bgColor,
      body: Column(
        children: [
          Flexible(
            child: TextField(
              controller: _searchController,
              onChanged: (String query) {
                setState(() {
                  _searchResultsCopy = performSearch(query);
                });
              },
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
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  _searchResults = snapshot.data!.docs;
                  return _searchResultsCopy.isNotEmpty
                      ? ListView.builder(
                          itemCount: _searchResultsCopy.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => GuestSpace(
                                      data: _searchResultsCopy[index].data(),
                                    ),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundImage: CachedNetworkImageProvider(
                                  _searchResultsCopy[index]
                                      .get("profile_picture_url"),
                                ),
                              ),
                              title: Text(
                                _searchResultsCopy[index].get("username"),
                                style: GoogleFonts.abel(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: bgColor == Colors.white
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "Sorry, there is no person with this criteria.",
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

  List<QueryDocumentSnapshot<Map<String, dynamic>>> performSearch(
      String query) {
    return _searchResults
        .where((QueryDocumentSnapshot<Map<String, dynamic>> element) =>
            element.get("username").contains(query))
        .toList();
  }
}
