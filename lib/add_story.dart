import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class AddStory extends StatefulWidget {
  const AddStory({super.key});

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () {},
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 23,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/hafedh.png"),
                  ),
                ),
                Text(
                  "hafedh",
                  style: GoogleFonts.abel(
                    fontSize: 14,
                    color: bgColor == Colors.white
                        ? Colors.black.withOpacity(.5)
                        : Colors.white.withOpacity(.5),
                  ),
                ),
              ],
            ),
            const Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.plus,
                      color: Colors.white,
                      size: 8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
