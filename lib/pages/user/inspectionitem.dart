import 'package:flutter/material.dart';
class InspcetionItem extends StatefulWidget {
  InspcetionItem({super.key});
  @override
  _InspcetionItem createState() => _InspcetionItem();
}

class  _InspcetionItem extends State<InspcetionItem> {

  bool active_value = false;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Row(
            children: [
              SizedBox(width:10),
              Image.asset('assets/images/home.jpg',width: 80,height: 50,),
              SizedBox(
                  height: 35,
                  width: 250,
                  child:
                  Container(
                      margin:EdgeInsets.only(left:20),
                      child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Inspection Date',
                          )
                      )
                  )
              ),
              Row(
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
                  Text('Functional Condition')
                ],
              ),
              SizedBox(
                  height: 35,
                  width: 250,
                  child:
                  Container(
                      margin:EdgeInsets.only(left:20),
                      child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Asset Money Value',
                          )
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
                          decoration: InputDecoration(
                            hintText: 'Next Inspection',
                          )
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
                          decoration: InputDecoration(
                            hintText: 'Comments',
                          )
                      )
                  )
              ),

            ]
        )
    );
  }
}