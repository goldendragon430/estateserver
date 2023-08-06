import 'package:flutter/material.dart';



class CategoryItem extends StatefulWidget {
  CategoryItem({super.key});
  @override
  _CategoryItem createState() => _CategoryItem();
}
class  _CategoryItem extends State<CategoryItem> {

  @override
  Widget build(BuildContext context) {
    return
      SizedBox(width:330,height:200,child: Column(
        children: [
          Image.asset('assets/images/category.png',width: 94,height: 94),
          SizedBox(
              height: 35,
              width: 150,
              child:
              Container(
                  margin:EdgeInsets.only(left:0),
                  child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Asset Type',
                      )
                  )
              )

          ),
          SizedBox(
              height: 35,
              width: 150,
              child:
              Container(
                  margin:EdgeInsets.only(left:0),
                  child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Category Name',
                      )
                  )
              )

          ),
        ],

      ));
  }
}
