import 'package:flutter/material.dart';

class TitledContainer extends StatelessWidget {
  const  TitledContainer({required this.titleText, required this.child,this.color = Colors.black12,this.title_color = Colors.white, this.idden = 8, Key? key}) : super(key: key);
  final String titleText;
  final double idden;
  final Widget child;
  final Color color;
  final Color title_color;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: (titleText != '' ? 40 : 5)),
          padding: EdgeInsets.all(idden),
          decoration: BoxDecoration(
            border: Border.all(color: color),
          ),
          child: child,
        ),
        if(titleText != '')
          Container(
          color: title_color == Colors.white ? Color.fromRGBO(0, 113, 255, 1) : title_color,
          height: 40,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(titleText,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    )),
                             ]),
        )
      ],
    );
  }
}