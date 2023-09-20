import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';


class UserItem extends StatefulWidget {

  String? id;
  String? username;
  Function(String id, BuildContext context)? onChange;


  UserItem({super.key, this.id, this.username, this.onChange});
  @override
  _UserItem createState() => _UserItem();
}
class  _UserItem extends State<UserItem> {
  String user_name = '';
  bool is_focus = false;
  TextEditingController userNameEditController = TextEditingController();

  void update(BuildContext context){
    widget.onChange!(widget.id!, context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user_name = widget.username!;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  SizedBox(width:200,height:150,
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
                children: [
                  GestureDetector(
                    onTap: (){
                      update(context);
                    },
                    child: TitledContainer(
                        titleText: '',
                        idden: 10,
                        color : is_focus ? Colors.deepOrange:Colors.black12,
                        child: Column(
                          children: [
                            Image.asset('assets/images/group.png',width: 94,height: 94),
                            SizedBox(width : 200,child: Center(child: Text(user_name, style: TextStyle(fontSize: 20))))
                          ],
                        )
                    )
                  )
                ]

            ))
    );
  }
}
