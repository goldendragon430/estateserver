
import 'package:flutter/material.dart';


class CustomAppBar extends AppBar {
  final String title2;
  CustomAppBar({Key? key, required String title, required this.title2, required BuildContext context})
      : super(
    key: key,
    automaticallyImplyLeading: false,
    title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.fitWidth
          ),
           Text(title2),
          Text(title, style : TextStyle(
                  fontSize: 14
            )
          )
        ]),
    actions: [
      IconButton(
        icon: Icon(Icons.logout),
        onPressed: () {
          if(ModalRoute.of(context)!.isFirst != null)
              Navigator.pop(context);
          else
            Navigator.pushNamed(
              context,
              '/',
            );
          // Navigator.pop(context);
          // Perform settings action
        },
      )
    ],
    backgroundColor: Colors.orange, // Customize the background color
    elevation: 4.0, // Customize the elevation
  );
}