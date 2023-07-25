import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:assetmamanger/pages/tenant/folderitem.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'dart:math';
class TenantFolders extends StatefulWidget {
  TenantFolders({super.key});
  @override
  _TenantFolders createState() => _TenantFolders();
}
class  _TenantFolders extends State<TenantFolders> {

  void searchItems(String val){

  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tile_width = (screenWidth - 300 - 100)/3;
    final items_count = 10;

    List<TrackSize> Rows = List<TrackSize>.filled((items_count/3).ceil(), 170.px);
    return   Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left:30),
      child: Column(
        children: [
          Expanded(child: TitledContainer(
              titleText: 'TENANT Folders',
              idden: 10,
              child:
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10,bottom:10),
                        child: SizedBox(
                            height: 45,
                            width: 400,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      searchItems(value);
                                    });
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'Search...',
                                      // Add a clear button to the search bar
                                      suffixIcon:  Icon(Icons.clear),
                                      // Add a search icon or button to the search bar
                                      prefixIcon:  Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      fillColor: Colors.white,
                                      filled: true
                                  ),
                                ),
                            )

                        )
                      ),
                      SizedBox(width:20),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green),
                              padding:MaterialStateProperty.all(const EdgeInsets.all(20)),

                              textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                          onPressed: () {
                            setState(() {
                            });
                          },
                          child: const Text('Add')),
                      SizedBox(width:20),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                              padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                              textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                          onPressed: () {
                            setState(() {
                            });
                          },
                          child: const Text('Delete')),
                    ],
                  ),
                  SizedBox(height: 30),
                  Expanded(child: ListView(
                    children: [
                    LayoutGrid(
                      columnSizes: [tile_width.px,tile_width.px,tile_width.px],
                      rowSizes: Rows,
                      columnGap: 2,
                      rowGap: 2,
                      children: [
                        Center(child:FolderItem()),
                        Center(child:FolderItem()),
                        Center(child:FolderItem()),
                        Center(child:FolderItem()),
                        Center(child:FolderItem()),
                        Center(child:FolderItem()),
                        Center(child:FolderItem()),
                        Center(child:FolderItem()),
                        Center(child:FolderItem()),
                        Center(child:FolderItem()),
                      ],
                    )
                    ],
                  ))
                ],
              )

          ))
        ],
      ),
    );
  }
}
