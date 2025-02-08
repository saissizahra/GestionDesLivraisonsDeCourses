import 'package:flutter/material.dart';

class DetailImages extends StatelessWidget {
  final Function(int) onChange;
  final String image;
  const DetailImages({
    super.key, 
    required this.onChange, 
    required this.image
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: PageView.builder(
        onPageChanged: onChange,
        itemBuilder: (context, index) {
          return Image.asset(image);
        },
      ),
    );
  }
}