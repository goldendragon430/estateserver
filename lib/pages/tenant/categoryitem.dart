import 'package:flutter/material.dart';



class CategoryItem extends StatefulWidget {

  String? folderID;
  String? groupID;
  String? assetTypeID;
  String? categoryID;
  String? assetTypeName;
  String? categoryName;
  Function(String folderID, String groupID,String assetTypeID,String categoryID, String categoryName)? onChange;
  Function(String folder_id, String group_id, String asset_type_id, String category_id)? onDelete;

  CategoryItem({super.key,this.folderID, this.groupID, this.assetTypeID, this.categoryID, this.assetTypeName, this.categoryName, this.onChange, this.onDelete});
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
      assetTypeEditController.text = widget.assetTypeName!;
    });
  }
  void update(){
    widget.onChange!(widget.folderID!, widget.groupID!,widget.assetTypeID!,widget.categoryID!,categoryName);
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
                            controller: assetTypeEditController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Asset Type',
                              ),
                            readOnly: true,
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
                            widget.onDelete!(widget.folderID!, widget.groupID!, widget.assetTypeID!, widget.categoryID!);
                          },
                        )
                    )
                )
            ]
        ))
      );
  }
}
