import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:assetmamanger/pages/user/userassetitem.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter/material.dart';

import 'dart:math';

class UserView extends StatefulWidget {
  UserView({super.key});
  @override
  _UserView createState() => _UserView();
}
 class User {
   final String asset;
   final String category;
   final String name;
   final String registered;
   final String lastInspected;
   final String status;

   User({
     required this.asset,
     required this.category,
     required this.name,
     required this.registered,
     required this.lastInspected,
     required this.status,
   });
 }
class  _UserView extends State<UserView> {
  int hoveredIndex = -1;
  int hoveredIndex2 = -1;
  int hoveredIndex3 = -1;
  String selectedValue = 'Folder 1';
  String selectedValue2 = 'Category 1';
  List<String> groups = <String>['Group1', 'Group2', 'Group3', 'Group4'];
  List<String> assets = <String>['Asset1', 'Asset2', 'Asset3', 'Asset4'];

  List<String> actions = <String>['Gallery View', 'Grid View', 'Stats View', 'Export'];
  List<Icon> acionIcons = <Icon>[Icon(Icons.calendar_month),Icon(Icons.grid_4x4_outlined),Icon(Icons.show_chart),Icon(Icons.file_copy)];
  List<PlutoColumn> columns = [
    /// Text Column definition
    PlutoColumn(
      title: 'Asset',
      field: 'asset',
      type: PlutoColumnType.text(),
    ),
    /// Number Column definition
    PlutoColumn(
      title: 'Category',
      field: 'category',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    /// Datetime Column definition
    PlutoColumn(
      title: 'Registered',
      field: 'registered',
      type: PlutoColumnType.date(),
    ),
    PlutoColumn(
      title: 'Last Inspected',
      field: 'inspected',
      type: PlutoColumnType.date(),
    ),
    PlutoColumn(
    title: 'Status',
    field: 'status',
    type: PlutoColumnType.text(),
    ),
  ];
  List<PlutoRow> rows = [
    PlutoRow(
      cells: {
        'asset': PlutoCell(value: 'Type A'),
        'category': PlutoCell(value: '1'),
        'name': PlutoCell(value: 'Cruiser 901'),
        'registered': PlutoCell(value: '2020-08-06'),
        'inspected': PlutoCell(value: ''),
        'status': PlutoCell(value: '')
      },
    ),
    PlutoRow(
      cells: {
        'asset': PlutoCell(value: 'Type A'),
        'category': PlutoCell(value: '1'),
        'name': PlutoCell(value: 'Cruiser 901'),
        'registered': PlutoCell(value: '2020-08-06'),
        'inspected': PlutoCell(value: ''),
        'status': PlutoCell(value: '')
      },
    ),
    PlutoRow(
      cells: {
        'asset': PlutoCell(value: 'Type A'),
        'category': PlutoCell(value: '1'),
        'name': PlutoCell(value: 'Cruiser 901'),
        'registered': PlutoCell(value: '2020-08-06'),
        'inspected': PlutoCell(value: ''),
        'status': PlutoCell(value: '')
      },
    )
  ];
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tile_width = (screenWidth - 650 - 50)/2;
    final items_count = 5;
    List<TrackSize> Rows = List<TrackSize>.filled((items_count/2).ceil(), 220.px);

    return   Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            width : 250,
            color:Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top:10),
                  child:  Text('Folders',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  width: 250,
                  margin: EdgeInsets.only(top: 10,bottom: 20),
                  child: DropdownButton<String>(
                    value: selectedValue,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedValue = newValue;
                        });
                      }
                    },
                    items: <String>[
                      'Folder 1',
                      'Folder 2',
                      'Folder 3',
                      'Folder 4',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                ),
                Expanded(child: ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: groups.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // Handle mouse press event
                        print('Item pressed: ${groups[index]}');
                      },
                      child: MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            hoveredIndex = index;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            hoveredIndex = -1;
                          });
                        },

                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 40,
                          color: hoveredIndex == index ? Color.fromRGBO(150, 150, 150, 0.2) : Colors.white,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('assets/images/home.jpg'),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text('${groups[index]}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ],
            )
        ),
        Container(
            width : 250,
            color:Color.fromRGBO(0, 113,255,0.1),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top:10),
                  child:  Text('Assets',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(child: ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: assets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // Handle mouse press event
                        print('Item pressed: ${assets[index]}');
                      },
                      child: MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            hoveredIndex2 = index;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            hoveredIndex2 = -1;
                          });
                        },

                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 40,
                          color: hoveredIndex2 == index ? Color.fromRGBO(0, 113,255,0.4) : Color.fromRGBO(0, 113,255,0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('assets/images/home.jpg'),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text('${assets[index]}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ],
            )
        ),
        Expanded(
            child:
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(left:30),
              child: Column(
                children: [
                  TitledContainer(
                      titleText: '',
                      idden: 10,
                      child: Row(
                        children: [
                          Container(
                              width: 250,
                              margin: EdgeInsets.only(top: 10,bottom: 10),
                              child: DropdownButton<String>(
                                value: selectedValue2,
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedValue2 = newValue;
                                    });
                                  }
                                },
                                items: <String>[
                                  'Category 1',
                                  'Category 2',
                                  'Category 3',
                                  'Category 4',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                          ),
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
                      )
                  ),
                  SizedBox(height: 10),
                  Expanded(child: TitledContainer(
                      titleText: 'Grid View',
                      idden: 10,
                      child:PlutoGrid(
                          columns: columns,
                          rows: rows,
                          onChanged: (PlutoGridOnChangedEvent event) {
                            print(event);
                          },
                          onLoaded: (PlutoGridOnLoadedEvent event) {
                            print(event);
                          }
                      )
                  )
                  ),
                  SizedBox(height: 10),
                  Expanded(child: TitledContainer(
                          titleText: 'Gallery View',
                          idden: 10,
                          child: ListView(
                            children: [
                              LayoutGrid(
                                columnSizes: [tile_width.px,tile_width.px],
                                rowSizes: Rows,
                                columnGap: 2,
                                rowGap: 2,
                                children: [
                                  UserAssetItem(),
                                  UserAssetItem(),
                                  UserAssetItem(),
                                  UserAssetItem(),
                                  UserAssetItem(),
                                ],
                              )
                            ],
                          )
                  )
                  ),
                ],
              ),
            )
        ),
        Container(
            width : 150,
            color:Color.fromRGBO(0, 113,255,0.1),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top:10),
                  child:  Text('Actions',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(child: ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: assets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // Handle mouse press event
                        print('Item pressed: ${assets[index]}');
                      },
                      child: MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            hoveredIndex3 = index;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            hoveredIndex3 = -1;
                          });
                        },

                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 80,
                          color: hoveredIndex3 == index ? Color.fromRGBO(0, 113,255,0.4) : Color.fromRGBO(0, 113,255,0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              acionIcons[index],
                              Text('${actions[index]}'),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ],
            )
        ),
      ],
    );
  }
}
