import 'package:assetmamanger/pages/user/inspectionitem.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:flutter/material.dart';
class AssetDetailView extends StatefulWidget {
  AssetDetailView({super.key});
  @override
  _AssetDetailView createState() => _AssetDetailView();
}
class  _AssetDetailView extends State<AssetDetailView> {
  int hoveredIndex = -1;
  int hoveredIndex2 = -1;
  List<String> entries = <String>['Asset1', 'Asset2', 'Asset3', 'Asset4'];
  List<String> images = <String>['Image1', 'Image2', 'Image3', 'Image4'];
  List<String> filteredItems = [];
  String selectedValue = 'Type 1';
  String selectedValue2 = 'Category 1';

  @override
  void initState() {
    super.initState();
    filteredItems = List<String>.from(entries);
  }
  void searchItems(String query) {
    filteredItems = entries.where((item) => item.contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return   Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            width : 300,
            color:Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10,bottom: 20),
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
                ),
                Text('**Search from DM and if found add to the cached list and display'),
                SizedBox(height: 10),
                Expanded(child:
                ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: filteredItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // Handle mouse press event
                        print('Item pressed: ${filteredItems[index]}');
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
                                child: Text('${filteredItems[index]}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
                Text('**Cached Assets from filtered list'),
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
                      titleText: 'Asset Details',
                      idden: 10,
                      child:
                      Column(
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/images/home.jpg',width: 200,height: 150,),
                                Column(
                                  children: [
                                    SizedBox(
                                        height: 35,
                                        width: 700,
                                        child:
                                        Container(
                                            margin:EdgeInsets.only(left:20),
                                            child: TextField(
                                                decoration: InputDecoration(
                                                  hintText: 'Asset ID',
                                                )
                                            )
                                        )

                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(
                                        height: 35,
                                        width: 700,
                                        child:
                                        Container(
                                            margin:EdgeInsets.only(left:20),
                                            child: TextField(
                                                decoration: InputDecoration(
                                                  hintText: 'Asset Name',
                                                )
                                            )
                                        )

                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(
                                        width: 700,
                                        child: DropdownButton<String>(
                                          value: selectedValue,
                                          padding: EdgeInsets.only(left:20),
                                          isExpanded: true,
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                selectedValue = newValue;
                                              });
                                            }
                                          },
                                          items: <String>[
                                            'Type 1',
                                            'Type 2',
                                            'Type 3',
                                            'Type 4',
                                          ].map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )
                                    ),
                                    SizedBox(
                                        width: 700,
                                        child: DropdownButton<String>(
                                          value: selectedValue2,
                                          padding: EdgeInsets.only(left:20),
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
                                  ],
                                )

                              ],
                            ),
                            Row(children: [
                               SizedBox(
                                   width: 200,
                                   height:130,
                                   child: ListView.builder(
                                 padding: const EdgeInsets.only(top: 0),
                                 itemCount: images.length,
                                 itemBuilder: (BuildContext context, int index) {
                                   return GestureDetector(
                                     onTap: () {
                                       // Handle mouse press event
                                       print('Item pressed: ${images[index]}');
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
                                         margin: const EdgeInsets.only(top: 1),
                                         height: 40,
                                         alignment: Alignment.center,
                                         color: hoveredIndex2 == index ? Color.fromRGBO(150, 150, 150, 0.2) : Colors.white,
                                         child: Text('${images[index]}',textAlign: TextAlign.center,)
                                       ),
                                     ),
                                   );
                                 },
                               )
                               ),Expanded(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                          Row(children: [
                                            SizedBox(
                                                height: 35,
                                                width: 200,
                                                child:
                                                Container(
                                                    margin:EdgeInsets.only(left:20),
                                                    child: TextField(
                                                        decoration: InputDecoration(
                                                          hintText: 'Acquired Date',
                                                        )
                                                    )
                                                )

                                            ),
                                            SizedBox(
                                                height: 35,
                                                width: 200,
                                                child:
                                                Container(
                                                    margin:EdgeInsets.only(left:20),
                                                    child: TextField(
                                                        decoration: InputDecoration(
                                                          hintText: 'Last Inspection',
                                                        )
                                                    )
                                                )

                                            ),
                                          ]),
                                          SizedBox(height: 5),
                                          SizedBox(
                                              width:700,
                                              child:TextField(
                                                maxLines: 3,
                                                decoration: InputDecoration(
                                                  hintText: 'Comments',
                                                  border: OutlineInputBorder(),
                                                )
                                            ))

                              ]))
                            ])
                          ],
                      ),
                  ),
                  SizedBox(height:10),
                  Expanded(child: TitledContainer(
                      titleText: 'Inspections',
                      idden: 10,
                      child:
                      ListView.builder(
                          padding: const EdgeInsets.only(top: 0),
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return  new InspcetionItem();
                          })

                  )),

                ],
              ),
            )


        ),

      ],
    );
  }
}
