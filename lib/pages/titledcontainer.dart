import 'package:flutter/material.dart';

class TitledContainer extends StatelessWidget {
  const TitledContainer({required this.titleText, required this.child, this.idden = 8, Key? key}) : super(key: key);
  final String titleText;
  final double idden;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: EdgeInsets.all(idden),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(idden * 0.6),
          ),
          child: child,
        ),
        Positioned(
          left: 10,
          right: 10,
          top: 0,
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.white,
              child: Text(titleText, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
      ],
    );
  }
}