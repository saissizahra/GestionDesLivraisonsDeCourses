import 'package:flutter/material.dart';
import 'package:mkadia/common/color_extension.dart';

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.check, color: Colors.green),
          title: Text(
            widget.question,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: TColor.primaryText,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: TColor.primaryText,
            ),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Text(
              widget.answer,
              style: TextStyle(
                fontSize: 15,
                color: TColor.darkGray,
              ),
            ),
          ),
      ],
    );
  }
}