import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';


class UserItem extends StatefulWidget {

  String? id;
  String? username;
  String? email;
  bool? active;
  Function(String id, BuildContext context)? onChange;
  Function(String id)? onDelete;

  UserItem({super.key, this.id, this.username,this.email, this.active, this.onChange, this.onDelete});
  @override
  _UserItem createState() => _UserItem();
}
class  _UserItem extends State<UserItem> {
  bool active = false;

  String user_name = '';
  String email = '';
  bool is_focus = false;
  TextEditingController userNameEditController = TextEditingController();
  TextEditingController emailNameEditController = TextEditingController();

  void update(BuildContext context){
    widget.onChange!(widget.id!, context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      active = widget.active!;
      user_name = widget.username!;
      userNameEditController.text = user_name;
      email = widget.email!;
      emailNameEditController.text = email;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  SizedBox(width:300,height:170,
        child: MouseRegion(
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
                  GestureDetector(
                    onTap: (){
                      update(context);
                    },
                    child: TitledContainer(
                        titleText: '',
                        idden: 10,
                        color : is_focus ? Colors.deepOrange:Colors.black12,
                        child: Row(
                          children: [
                            Image.asset('assets/images/group.png',width: 94,height: 94),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 50,
                                    width: 180,
                                    child:
                                    Container(
                                        margin:EdgeInsets.only(left:20),
                                        child: TextField(

                                          controller: userNameEditController,
                                          decoration: InputDecoration(
                                            labelText: 'User Name',
                                          ),
                                          readOnly: true,
                                          onChanged: (value){
                                            // user_name = value;
                                            // update();
                                          },
                                        )
                                    )

                                ),
                                SizedBox(
                                    height: 50,
                                    width: 180,
                                    child:
                                    Container(
                                        margin:EdgeInsets.only(left:20),
                                        child: TextField(
                                          controller: emailNameEditController,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                          ),
                                          readOnly: true,
                                          onChanged: (value){
                                            setState(() {
                                              // email = value;
                                              // update();
                                            });
                                          },
                                        )
                                    )

                                ),
                                SizedBox(height:5),
                                Row(
                                  children: [
                                    SizedBox(
                                        width:15
                                    ),
                                    Checkbox(
                                      value: this.active,
                                      onChanged: (bool? value) {

                                      },
                                    ),
                                    SizedBox(
                                        width:10
                                    ),
                                    Text('Active')
                                  ],
                                ),

                              ],)
                          ],
                        )
                    )
                  ),
                  if(is_focus)
                    Container(
                        margin: EdgeInsets.only(top:15,right:5),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Image.asset('assets/images/delete.png'),
                              onPressed: () {
                                widget.onDelete!(widget.id!);
                                // Add your button functionality here
                              },
                            )
                        )
                    )
                ]

            ))
    );
  }
}
