import 'package:flutter/material.dart';

class PicturesInGrid extends StatelessWidget {
  const PicturesInGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      children: [
        for (int i = 0; i < 20; i++)
          SizedBox(
            width: MediaQuery.of(context).size.width * .3,
            child: Image.asset("assets/hafedh.png", fit: BoxFit.cover),
          )
      ],
    );
  }
}
