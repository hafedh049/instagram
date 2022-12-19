import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/comment.dart';
import 'package:instagram/constants.dart';

class Post extends StatefulWidget {
  const Post({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  bool isVisible = false;
  bool isReacted = false;
  GlobalKey commentsKey = GlobalKey();
  GlobalKey reactionKey = GlobalKey();

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
                  widget.data["post"],
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
          onDoubleTap: () {
            reactionKey.currentState!.setState(() {
              isReacted = !isReacted;
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
                    onPressed: () {
                      setS(
                        () {
                          isReacted = !isReacted;
                        },
                      );
                    },
                    icon: Icon(
                      FontAwesomeIcons.heart,
                      size: 15,
                      color: isReacted
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
                  setState(
                    () {
                      isVisible = !isVisible;
                    },
                  );
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
              IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                onPressed: () {},
                icon: Icon(
                  FontAwesomeIcons.idBadge,
                  size: 15,
                  color: bgColor == Colors.white ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  for (int i = 0; i < 3; i++)
                    const CircleAvatar(
                      radius: 8,
                      backgroundImage: AssetImage("assets/hafedh.png"),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  Text(
                    "Liked by ",
                    style: TextStyle(
                      color:
                          bgColor == Colors.white ? Colors.black : Colors.white,
                    ),
                  ),
                  Text(
                    "hafedh ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          bgColor == Colors.white ? Colors.black : Colors.white,
                    ),
                  ),
                  Text(
                    "and ",
                    style: TextStyle(
                      color:
                          bgColor == Colors.white ? Colors.black : Colors.white,
                    ),
                  ),
                  Text(
                    "others",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          bgColor == Colors.white ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "November 12",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Visibility(
          visible: isVisible,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return const Comment();
              },
            ),
          ),
        )
      ],
    );
  }
}
