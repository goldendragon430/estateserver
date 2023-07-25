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
        title: widget.title,
        leading: widget.icon,
        textColor: isHovered?Colors.red:Colors.black,
        onTap: (){
          widget.onClick();
        },
      ),
    );
  }
}