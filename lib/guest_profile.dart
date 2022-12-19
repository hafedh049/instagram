import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/constants.dart';
import 'package:instagram/pictures_in_grid.dart';
import 'package:instagram/story.dart';

class UserSpace extends StatefulWidget {
  const UserSpace({super.key});

  @override
  State<UserSpace> createState() => _UserSpaceState();
}

class _UserSpaceState extends State<UserSpace> {
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Map<int, List<Color>> colors = <int, List<Color>>{
    0: [bgColor == Colors.white ? Colors.black : Colors.white, bgColor],
    1: [bgColor == Colors.white ? Colors.black : Colors.white, bgColor],
    2: [bgColor == Colors.white ? Colors.black : Colors.white, bgColor],
    3: [bgColor == Colors.white ? Colors.black : Colors.white, bgColor],
  };
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          onPressed: () {},
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
              FontAwesomeIcons.ellipsis,
              size: 15,
              color: bgColor == Colors.white ? Colors.black : Colors.white,
            ),
          ),
        ],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "instagram",
              style: GoogleFonts.abel(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: bgColor == Colors.white ? Colors.black : Colors.white,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.verified,
              color: Colors.blue,
              size: 15,
            )
          ],
        ),
        backgroundColor: bgColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const CircleAvatar(
                  radius: 41,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.pinkAccent,
                    backgroundImage: AssetImage("assets/hafedh.png"),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "5,963",
                      style: GoogleFonts.abel(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: bgColor == Colors.white
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    Text(
                      "Posts",
                      style: GoogleFonts.abel(
                        fontSize: 16,
                        color: bgColor == Colors.white
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "308 M",
                      style: GoogleFonts.abel(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: bgColor == Colors.white
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    Text(
                      "Followers",
                      style: GoogleFonts.abel(
                        fontSize: 16,
                        color: bgColor == Colors.white
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "223",
                      style: GoogleFonts.abel(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: bgColor == Colors.white
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    Text(
                      "Following",
                      style: GoogleFonts.abel(
                        fontSize: 16,
                        color: bgColor == Colors.white
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Instagram",
              style: GoogleFonts.abel(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: bgColor == Colors.white ? Colors.black : Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Bringing you closer to the people and things you love. ♥",
              style: GoogleFonts.abel(
                fontSize: 16,
                color: bgColor == Colors.white ? Colors.black : Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () {},
              child: Text(
                "help.instagram.com",
                style: GoogleFonts.abel(
                  fontSize: 16,
                  //decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Center(
                        child: Text(
                          "Follow",
                          style: GoogleFonts.abel(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 227, 243, 255),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 30,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: () {},
                      child: Center(
                        child: Text(
                          "Message",
                          style: GoogleFonts.abel(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 227, 243, 255),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {},
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          FontAwesomeIcons.chevronDown,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[for (int i = 0; i < 50; i++) const Story()],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Colors.grey,
              indent: 5,
              endIndent: 5,
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 10),
            StatefulBuilder(builder: (context, setS) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onPressed: () {
                      setS(() {
                        colors[0] = [Colors.blue, Colors.blue];
                        for (int i = 1; i < 4; i++) {
                          colors[i] = [
                            bgColor == Colors.white
                                ? Colors.black
                                : Colors.white,
                            bgColor
                          ];
                        }
                      });
                    },
                    icon: Column(
                      children: [
                        Icon(
                          Icons.grid_3x3_outlined,
                          color: colors[0]![0],
                          size: 25,
                        ),
                        const SizedBox(height: 2),
                        Container(height: 1, color: colors[0]![1]),
                      ],
                    ),
                  ),
                  IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onPressed: () {
                      setS(() {
                        colors[1] = [Colors.blue, Colors.blue];
                        for (int i = 0; i < 4; i++) {
                          if (i != 1) {
                            colors[i] = [
                              bgColor == Colors.white
                                  ? Colors.black
                                  : Colors.white,
                              bgColor
                            ];
                          }
                        }
                      });
                    },
                    icon: Column(
                      children: [
                        Icon(
                          Icons.tv,
                          color: colors[1]![0],
                          size: 25,
                        ),
                        const SizedBox(height: 2),
                        Container(height: 1, color: colors[1]![1]),
                      ],
                    ),
                  ),
                  IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onPressed: () {
                      setS(() {
                        colors[2] = [Colors.blue, Colors.blue];
                        for (int i = 0; i < 4; i++) {
                          if (i != 2) {
                            colors[i] = [
                              bgColor == Colors.white
                                  ? Colors.black
                                  : Colors.white,
                              bgColor
                            ];
                          }
                        }
                      });
                    },
                    icon: Column(
                      children: [
                        Icon(
                          Icons.emoji_emotions_outlined,
                          color: colors[2]![0],
                          size: 25,
                        ),
                        const SizedBox(height: 2),
                        Container(height: 1, color: colors[2]![1]),
                      ],
                    ),
                  ),
                  IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onPressed: () {
                      setS(() {
                        colors[3] = [Colors.blue, Colors.blue];
                        for (int i = 0; i < 4; i++) {
                          if (i != 3) {
                            colors[i] = [
                              bgColor == Colors.white
                                  ? Colors.black
                                  : Colors.white,
                              bgColor
                            ];
                          }
                        }
                      });
                    },
                    icon: Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.userAstronaut,
                          color: colors[3]![0],
                          size: 25,
                        ),
                        const SizedBox(height: 2),
                        Container(height: 1, color: colors[3]![1]),
                      ],
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 10),
            Expanded(
              child: PageView(
                controller: pageController,
                children: const <Widget>[PicturesInGrid()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
