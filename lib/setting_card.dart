import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsUI extends StatefulWidget {
  const SettingsUI({super.key});

  @override
  State<SettingsUI> createState() => _SettingsUIState();
}

class _SettingsUIState extends State<SettingsUI> {
  get bgColor => null;

  @override
  Widget build(BuildContext context) {
    Color color = bgColor == Colors.white ? Colors.black : Colors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Settings",
          style: GoogleFonts.abel(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: bgColor == Colors.white ? Colors.black : Colors.white,
          ),
        ),
        ...[
          for (List item in [
            [
              FontAwesomeIcons.circleHalfStroke,
              "Blocked Accounts",
            ],
            [
              FontAwesomeIcons.bell,
              "Notifications",
            ],
            [
              FontAwesomeIcons.shield,
              "Privacy Policy",
            ],
            [
              FontAwesomeIcons.fileWaveform,
              "Terms Of Services",
            ],
            [
              FontAwesomeIcons.fileCode,
              "Community Guide",
            ],
            [
              FontAwesomeIcons.circleQuestion,
              "Support",
            ],
          ])
            ListTile(
              leading: Icon(
                item[0],
                color: color,
                size: 15,
              ),
              title: Text(
                item[1],
                style: GoogleFonts.abel(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: bgColor == Colors.white ? Colors.black : Colors.white,
                ),
              ),
              trailing: Icon(
                FontAwesomeIcons.chevronRight,
                size: 15,
                color: color,
              ),
            ),
        ],
      ],
    );
  }
}
