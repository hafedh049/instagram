import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/constants.dart';

class Comment extends StatefulWidget {
  const Comment({super.key});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CircleAvatar(
          radius: 15,
          backgroundImage: AssetImage("assets/hafedh.png"),
        ),
        //const SizedBox(width: 10),
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
                //verticalDirection: VerticalDirection.up,
                children: [
                      Text(
                        "hafedh_gnichi",
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: bgColor == Colors.white
                              ? Colors.black
                              : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] +
                    "hello hello hello hello hello hello hello"
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
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "22h",
                    style: TextStyle(
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
                    child: const Text(
                      "1,609 likes",
                      style: TextStyle(
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
              )
            ],
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          onPressed: () {},
          icon: const Icon(
            FontAwesomeIcons.heart,
            color: Colors.grey,
            size: 15,
          ),
        ),
      ],
    );
  }
}
