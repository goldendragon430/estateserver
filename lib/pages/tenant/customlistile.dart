import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget {
  final Text title;
  final Icon icon;
  final VoidCallback  onClick;
  CustomListTile({required this.title,required this.icon, required this.onClick});

  @override
  _HoverListTileState createState() => _HoverListTileState();
}

class _HoverListTileState extends State<CustomListTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool is_Mobile_Mode = screenWidth < 1260 ;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: ListTile(
        title: !is_Mobile_Mode! ? widget.title : Text(''),
        leading: widget.icon,
        iconColor: is_Mobile_Mode & isHovered?Colors.red:Colors.black,
        textColor: isHovered?Colors.red:Colors.black,
        onTap: (){
          widget.onClick();
        },
      ),
    );
  }
}