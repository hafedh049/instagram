import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class InstagramTitle extends StatelessWidget {
  const InstagramTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Instagram",
      style: GoogleFonts.aladin(
        color: bgColor == Colors.white ? Colors.black : Colors.white,
        fontSize: 22,
      ),
    );
  }
}
