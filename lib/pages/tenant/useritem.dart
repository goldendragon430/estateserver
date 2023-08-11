import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';


class UserItem extends StatefulWidget {

  String? id;
  String? username;
  String? email;
  bool? active;
  Function(String email, String username,String id,bool active)? onChange;
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

  void update(){
    widget.onChange!(email,user_name,widget.id!,active);
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
    return  SizedBox(width:300,height:150,
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
                  TitledContainer(
                      titleText: '',
                      idden: 10,
                      child: Row(
                        children: [
                          Image.asset('assets/images/group.png',width: 94,height: 94),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: 35,
                                  width: 150,
                                  child:
                                  Container(
                                      margin:EdgeInsets.only(left:20),
                                      child: TextField(

                                        controller: userNameEditController,
                                        decoration: InputDecoration(
                                          hintText: 'User Name',
                                        ),
                                        onChanged: (value){
                                                user_name = value;
                                                update();
                                        },
                                      )
                                  )

                              ),
                              SizedBox(
                                  height: 35,
                                  width: 150,
                                  child:
                                  Container(
                                      margin:EdgeInsets.only(left:20),
                                      child: TextField(
                                        controller: emailNameEditController,
                                        decoration: InputDecoration(
                                          hintText: 'Email',
                                        ),
                                        onChanged: (value){
                                          setState(() {
                                            email = value;
                                            update();
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
                                      setState(() {
                                        this.active = value!;
                                        update();
                                      });
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
