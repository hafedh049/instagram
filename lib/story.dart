import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/constants.dart';

class Story extends StatefulWidget {
  const Story({super.key});

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.pinkAccent.shade100,
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 23,
                child: CircleAvatar(
                    // backgroundImage: AssetImage("assets/hafedh.png"),
                    ),
              ),
            ),
            Text(
              "user", //"hafedh",
              style: GoogleFonts.abel(
                fontSize: 14,
                color: bgColor == Colors.white ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
