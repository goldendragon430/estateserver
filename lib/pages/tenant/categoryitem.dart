import 'package:flutter/material.dart';



class CategoryItem extends StatefulWidget {

  String? categoryID;
  String? categoryName;
  Function(String   category_id, String   categoryName)? onChange;
  Function(String   category_id)? onDelete;

  CategoryItem({super.key,  this.categoryID,  this.categoryName, this.onChange, this.onDelete});
  @override
  _CategoryItem createState() => _CategoryItem();
}
class  _CategoryItem extends State<CategoryItem> {
  String categoryName = '';
  bool is_focus = false;
  TextEditingController categoryEditController = TextEditingController();
  TextEditingController assetTypeEditController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      categoryName = widget.categoryName!;
      categoryEditController.text = widget.categoryName!;

    });
  }
  void update(){
    widget.onChange!(widget.categoryID!,categoryName);
  }
  @override
  Widget build(BuildContext context) {
    return
      SizedBox(width:180,height:200,child: MouseRegion(
        onEnter: (event){
          setState(() {
            is_focus = true;
          });
        },
        onExit: (eve){
          setState(() {
            is_focus = false;
          });
        },
        child: Stack(
            children:
            [
              Column(
                children: [
                  Image.asset('assets/images/category.png',width: 94,height: 94),
                  SizedBox(
                      height: 35,
                      width: 150,
                      child:
                      Container(
                          margin:EdgeInsets.only(left:0),
                          child: TextField(
                            controller: categoryEditController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Category Name',
                              ),
                            onChanged: (val){
                              setState(() {
                                categoryName = val;
                              });
                              update();
                            },
                          )
                      )
                  ),
                ]
              ),
              if(is_focus)
                Container(
                    margin: EdgeInsets.only(top:10,right:5),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Image.asset('assets/images/delete.png'),
                          onPressed: () {
                            widget.onDelete!(  widget.categoryID!);
                          },
                        )
                    )
                )
            ]
        ))
      );
  }
}
