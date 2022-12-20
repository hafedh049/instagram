import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/comment.dart';
import 'package:instagram/constants.dart';

class Post extends StatefulWidget {
  const Post({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  List<String> savedPosts = [];
  List<String> reactionList = [];
  List<Map<String, dynamic>> commentsList = [];
  List<Map<String, dynamic>> viewReactionsList = [];
  List<String> usersInSavedPosts = [];

  TextEditingController commentController = TextEditingController();

  Future<void> load() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> value) {
      savedPosts = value.data()!["saved_posts_list"] as List<String>;
    });
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.data["post_id"])
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> value) {
      reactionList = value.data()!["reacting_list"] as List<String>;
      commentsList =
          value.data()!["comments_list"] as List<Map<String, dynamic>>;
    });
  }

  @override
  void initState() {
    load().then((value) => null);
    super.initState();
  }

  bool isVisible = false;
  bool isSaved = false;
  bool isReacted = false;
  GlobalKey commentsKey = GlobalKey();
  GlobalKey reactionKey = GlobalKey();
  String dateDifference(Timestamp date) {
    DateTime now = DateTime.now();
    DateTime dated = date.toDate();
    Duration duration = now.difference(dated);
    int duration_in_seconds = duration.inSeconds;
    if (duration_in_seconds == 0) {
      return "Just now";
    }
    Map<String, int> filter = {
      "seconds": duration_in_seconds,
      "minutes": duration_in_seconds ~/ 60,
      "hours": duration_in_seconds ~/ 3600,
      "days": duration_in_seconds ~/ (3600 * 24),
      "weeks": duration_in_seconds ~/ (3600 * 24 * 7),
      "months": duration_in_seconds ~/ (3600 * 24 * 7 * 4),
      "years": duration_in_seconds ~/ (3600 * 24 * 7 * 4 * 12),
    };
    int dur = filter["seconds"]!, index = 0;
    List<String> keys = filter.keys.toList();
    for (String k in keys) {
      if (filter[k]! != 0) {
        dur = filter[k]!;
        index = keys.indexOf(k);
      }
    }
    return "$dur ${filter.keys.toList()[index]}";
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 15,
                backgroundImage: CachedNetworkImageProvider(
                  widget.data["profile_picture_url"],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.data["username"],
                style: TextStyle(
                  color: bgColor == Colors.white ? Colors.black : Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Spacer(),
              IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                onPressed: () {},
                icon: Icon(
                  FontAwesomeIcons.ellipsis,
                  size: 15,
                  color: bgColor == Colors.white ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          onLongPress: () {},
          onTap: () {},
          onDoubleTap: () async {
            if (!isReacted) {
              reactionList.add(FirebaseAuth.instance.currentUser!.uid);
            } else {
              reactionList.remove(FirebaseAuth.instance.currentUser!.uid);
            }
            await FirebaseFirestore.instance
                .collection("posts")
                .doc(widget.data["post_id"])
                .update({"reacting_list": reactionList}).then((value) {
              reactionKey.currentState!.setState(() {
                isReacted = !isReacted;
              });
            });
          },
          child: SizedBox(
            height: 450,
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: widget.data["post"],
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              StatefulBuilder(
                key: reactionKey,
                builder: (BuildContext context,
                    void Function(void Function()) setS) {
                  return IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onPressed: () async {
                      if (!isReacted) {
                        reactionList
                            .add(FirebaseAuth.instance.currentUser!.uid);
                      } else {
                        reactionList
                            .remove(FirebaseAuth.instance.currentUser!.uid);
                      }
                      await FirebaseFirestore.instance
                          .collection("posts")
                          .doc(widget.data["post_id"])
                          .update({"reacting_list": reactionList}).then(
                              (value) {
                        setS(
                          () {
                            isReacted = !isReacted;
                          },
                        );
                      });
                    },
                    icon: Icon(
                      widget.data["reacting_list"]
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      size: 15,
                      color: widget.data["reacting_list"]
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? Colors.pink
                          : bgColor == Colors.white
                              ? Colors.black
                              : Colors.white,
                    ),
                  );
                },
              ),
              IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                onPressed: () {
                  commentsKey.currentState!.setState(() {
                    isVisible = !isVisible;
                  });
                },
                icon: Icon(
                  FontAwesomeIcons.comment,
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
                  FontAwesomeIcons.paperPlane,
                  size: 15,
                  color: bgColor == Colors.white ? Colors.black : Colors.white,
                ),
              ),
              const Spacer(),
              StatefulBuilder(builder:
                  (BuildContext context, void Function(void Function()) setS) {
                return IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onPressed: () async {
                    if (!isSaved) {
                      savedPosts.add(widget.data["post_id"]);
                      usersInSavedPosts
                          .add(FirebaseAuth.instance.currentUser!.uid);
                    } else {
                      savedPosts.remove(widget.data["post_id"]);
                      usersInSavedPosts
                          .remove(FirebaseAuth.instance.currentUser!.uid);
                    }
                    await FirebaseFirestore.instance
                        .collection("posts")
                        .doc(widget.data["post_id"])
                        .update({"saved_list": usersInSavedPosts});
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({"saved_posts_list": savedPosts}).then((value) {
                      setS(
                        () {
                          isSaved = !isSaved;
                        },
                      );

                      Fluttertoast.showToast(
                        msg: isSaved ? "Saved" : "Unsaved",
                        fontSize: 16,
                        gravity: ToastGravity.BOTTOM,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_LONG,
                      );
                    });
                  },
                  icon: Icon(
                    savedPosts.contains(widget.data["post_id"])
                        ? FontAwesomeIcons.solidBookmark
                        : FontAwesomeIcons.bookmark,
                    size: 15,
                    color: savedPosts.contains(widget.data["post_id"])
                        ? Colors.pink
                        : bgColor == Colors.white
                            ? Colors.black
                            : Colors.white,
                  ),
                );
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () async {
              for (String user in widget.data["reacting_list"]) {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(user)
                    .get()
                    .then(
                  (DocumentSnapshot<Map<String, dynamic>> value) {
                    viewReactionsList.add(
                      {
                        "uid": value.data()!["uid"],
                        "username": value.data()!["username"],
                        "picture_url": value.data()!["profile_picture_url"],
                        "about": value.data()!["about"],
                      },
                    );
                  },
                );
              }
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                isDismissible: true,
                enableDrag: true,
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .5,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: viewReactionsList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            tileColor: Colors.transparent,
                            onTap: () {},
                            title: Text(
                              viewReactionsList[index]["username"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: bgColor == Colors.white
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              viewReactionsList[index]["about"],
                              style: TextStyle(
                                fontSize: 14,
                                color: bgColor == Colors.white
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: CachedNetworkImageProvider(
                                viewReactionsList[index]["picture_url"],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ).then((value) => viewReactionsList.clear());
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (!widget.data["reacting_list"].isEmpty)
                  Row(
                    children: [
                      Text(
                        "Liked by ",
                        style: TextStyle(
                          color: bgColor == Colors.white
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      Text(
                        " ${widget.data["reacting_list"].length} person",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: bgColor == Colors.white
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            dateDifference(widget.data["creation_date"]),
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 5),
        StatefulBuilder(
          key: commentsKey,
          builder: (BuildContext context, void Function(void Function()) setS) {
            return Visibility(
              visible: isVisible,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  addAutomaticKeepAlives: true,
                  addRepaintBoundaries: true,
                  shrinkWrap: true,
                  itemCount: widget.data["comments_list"].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Comment(
                        comment: widget.data["comments_list"][index]
                            as Map<String, dynamic>);
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 5),
        TextField(
          controller: commentController,
          cursorColor: Colors.blue,
          cursorRadius: const Radius.circular(15),
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0),
              ),
              suffixIcon: IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                onPressed: () async {
                  if (!commentController.text
                      .trim()
                      .contains(RegExp(r"^ *$"))) {
                    commentsList.add({
                      "username": widget.data["username"],
                      "picture_url": widget.data["profile_picture_url"],
                      "message": commentController.text.trim(),
                      "creation_time": DateTime.now(),
                      "likes_list": [],
                      "commenter_id": widget.data["uid"],
                    });
                    commentController.clear();
                    await FirebaseFirestore.instance
                        .collection("posts")
                        .doc(widget.data["post_id"])
                        .update({"comments_list": commentsList});
                  }
                },
                icon: const Icon(
                  FontAwesomeIcons.paperPlane,
                  size: 17,
                  color: Colors.grey,
                ),
              ),
              hintText: "Comment",
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
      ],
    );
  }
}
