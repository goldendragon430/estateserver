import 'package:assetmamanger/pages/admin/tenantgroup.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:assetmamanger/pages/admin/tenantfolder.dart';
import 'package:flutter/material.dart';
class AdminView extends StatefulWidget {
  AdminView({super.key});
  @override
  _AdminViewState createState() => _AdminViewState();
}
class  _AdminViewState extends State<AdminView> {
  int hoveredIndex = -1;
  bool valuefirst = false;
  bool active_value = false;
  bool folder_value = false;
  bool group_value = false;
  List<String> entries = <String>['Tenant1', 'Tenant2', 'Tenant3', 'Tenant4'];
  List<String> filteredItems = [];

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
                margin: EdgeInsets.only(top:10),
                child:  Text('Tenants',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
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
              Expanded(child: ListView.builder(
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
              Container(
                margin: EdgeInsets.only(top:10),
                child:  FloatingActionButton(
                  child : Icon(Icons.add),
                  backgroundColor: Colors.orange,
                  onPressed: () => {},
                )
              )
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
                        titleText: 'TENANT Details',
                        idden: 10,
                        child: Row(
                          children: [
                            Image.asset('assets/images/home.jpg',width: 200,height: 150,),
                            Expanded(child:
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 35,
                                          width: 350,
                                          child:
                                          Container(
                                              margin:EdgeInsets.only(left:20),
                                              child: TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Tenant Name',
                                              )
                                          )
                                          )

                                        ),
                                        SizedBox(
                                          height: 35,
                                          width: 350,
                                          child:  Container(
                                              margin:EdgeInsets.only(left:20),
                                              child: TextField(
                                                  decoration: InputDecoration(
                                                    hintText: 'Expiry Date',
                                                  )
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            height: 35,
                                            width: 350,
                                            child:
                                            Container(
                                                margin:EdgeInsets.only(left:20),
                                                child: TextField(
                                                    decoration: InputDecoration(
                                                      hintText: 'Email Address',
                                                    )
                                                )
                                            )

                                        ),
                                        SizedBox(
                                          height: 35,
                                          width: 350,
                                          child:  Container(
                                              margin:EdgeInsets.only(left:20),
                                              child: TextField(
                                                  decoration: InputDecoration(
                                                    hintText: 'Folder Name',
                                                  )
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            height: 35,
                                            width: 350,
                                            child:
                                            Container(
                                                margin:EdgeInsets.only(left:20),
                                                child: TextField(
                                                    decoration: InputDecoration(
                                                      hintText: 'Registeration Date',
                                                    )
                                                )
                                            )

                                        ),
                                        SizedBox(
                                          height: 35,
                                          width: 350,
                                          child:  Container(
                                              margin:EdgeInsets.only(left:20),
                                              child: TextField(
                                                  decoration: InputDecoration(
                                                    hintText: 'Group Name',
                                                  )
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height:5),
                                    Row(
                                      children: [
                                        SizedBox(width:220,height:40,child: Row(
                                          children: [
                                            SizedBox(
                                                width:15
                                            ),
                                            Checkbox(
                                              value: this.active_value,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  this.active_value = value!;
                                                });
                                              },
                                            ),
                                            SizedBox(
                                              width:10
                                            ),
                                            Text('Active?')

                                          ],

                                        )),
                                        SizedBox(width:220,height:40,child: Row(
                                          children: [
                                            SizedBox(
                                                width:15
                                            ),
                                            Checkbox(
                                              value: this.folder_value,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  this.folder_value = value!;
                                                });
                                              },
                                            ),
                                            SizedBox(
                                                width:10
                                            ),
                                            Text('Unlimited Folders?')

                                          ],

                                        )),
                                        SizedBox(width:220,height:40,child: Row(
                                          children: [
                                            SizedBox(
                                                width:15
                                            ),
                                            Checkbox(
                                              value: this.group_value,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  this.group_value = value!;
                                                });
                                              },
                                            ),
                                            SizedBox(
                                                width:10
                                            ),
                                            Text('Unlimited Groups?')

                                          ],

                                        )),
                                      ],
                                    )
                                  ],
                                )

                            )
                          ],
                        )
                    ),
                    SizedBox(height:10),
                    Expanded(child: TitledContainer(
                        titleText: 'TENANT Folders',
                        idden: 10,
                        child:
                            ListView.builder(
                            padding: const EdgeInsets.only(top: 0),
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) {
                              return new TenantFolderItem();

                            })

                    )),
                    SizedBox(height:10),
                    Expanded(child: TitledContainer(
                        titleText: 'TENANT Groups',
                        idden: 10,
                        child:
                        ListView.builder(
                            padding: const EdgeInsets.only(top: 0),
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) {
                              return
                                new TenantGroupItem();
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
