import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/constants.dart';

class Comment extends StatefulWidget {
  const Comment({super.key, required this.comment});
  final Map<String, dynamic> comment;
  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
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

  bool isReacted = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircleAvatar(
          radius: 15,
          backgroundImage:
              CachedNetworkImageProvider(widget.comment["picture_url"]),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runAlignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  runSpacing: 0,
                  spacing: 2,
                  children: [
                    Text(
                      widget.comment["username"],
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: bgColor == Colors.white
                            ? Colors.black
                            : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...widget.comment["message"]
                        .split(" ")
                        .map(
                          (String word) => Text(
                            word,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: bgColor == Colors.white
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        )
                        .toList(),
                  ]),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dateDifference(widget.comment["creation_time"]),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {},
                    child: Text(
                      "${widget.comment["likes_list"].length} likes",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {},
                    child: const Text(
                      "reply",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        StatefulBuilder(builder:
            (BuildContext context, void Function(void Function()) setS) {
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
              isReacted ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
              color: isReacted ? Colors.pink : Colors.grey,
              size: 15,
            ),
          );
        }),
      ],
    );
  }
}
