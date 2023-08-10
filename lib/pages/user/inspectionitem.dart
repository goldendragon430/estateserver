import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class InspcetionItem extends StatefulWidget {
  String? id;
  String? logo;
  DateTime? inspection_date;
  String? asset_money_value;
  DateTime? next_inspection;
  String? comment;
  bool? functional_condition;
  Function(String id, DateTime inspection_date,bool condition,String asset_money_value,DateTime next_inspection, String comment)? onChange;
  Function(String id)? onDelete;
  InspcetionItem({super.key,this.id,this.logo,this.inspection_date,this.asset_money_value,this.next_inspection,this.comment,this.functional_condition,this.onChange,this.onDelete});
  @override
  _InspcetionItem createState() => _InspcetionItem();
}

class  _InspcetionItem extends State<InspcetionItem> {
  bool is_focus = false;
  bool active_value = false;
  String? logo;
  DateTime? inspection_date;
  String? asset_money_value;
  DateTime? next_inspection;
  String? comment;
  bool? functional_condition;
  TextEditingController inspectionController = TextEditingController();
  TextEditingController amountControlller = TextEditingController();
  TextEditingController nextInspectionController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      logo = widget.logo;
      inspection_date = widget.inspection_date;
      inspectionController.text = DateFormat('yyyy-MM-dd').format(inspection_date!);
      asset_money_value = widget.asset_money_value;
      amountControlller.text = asset_money_value!;
      next_inspection = widget.next_inspection;
      nextInspectionController.text = DateFormat('yyyy-MM-dd').format(next_inspection!);
      comment = widget.comment;
      commentController.text = comment!;
      functional_condition = widget.functional_condition;
    });
  }
  void update(){
    widget.onChange!(widget.id!,inspection_date!,functional_condition!,asset_money_value!,next_inspection!,comment!);
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child:
        MouseRegion(
          onExit: (event){
            setState(() {
              is_focus = false;
            });
          },
          onEnter: (event){
            setState(() {
              is_focus = true;
            });
          },
          child:

              Row(
                  children: [
                    SizedBox(width:10),
                    logo == '' ?Image.asset('assets/images/home.jpg',width: 80,height: 50) : Image.network(logo!,width: 80,height: 50),
                    SizedBox(
                        height: 35,
                        width: 150,
                        child:
                        Container(
                            margin:EdgeInsets.only(left:20),
                            child:
                            TextField(
                              controller: inspectionController,
                              decoration: InputDecoration(
                                hintText: 'Inspection Date',
                              ),
                              readOnly: true,
                              onTap: () async{
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(), //get today's date
                                    firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101)
                                );
                                if(pickedDate!= null)
                                  setState(() {
                                    inspectionController.text = DateFormat('yyyy-MM-dd').format(pickedDate);//set foratted date to TextField value.
                                    inspection_date = pickedDate;
                                  });
                                update();
                              },
                            )
                        )
                    ),
                    Column(children: [
                      SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(
                              width:15
                          ),

                          Checkbox(
                            value: functional_condition,
                            onChanged: (bool? value) {
                              setState(() {
                                functional_condition = value!;
                              });
                              update();

                            },
                          ),
                          SizedBox(
                              width:5
                          ),
                          Text('Functional Condition')
                        ],
                      ),
                    ]),
                    SizedBox(
                        height: 35,
                        width: 150,
                        child:
                        Container(
                            margin:EdgeInsets.only(left:20),
                            child: TextField(
                                controller: amountControlller,
                                decoration: InputDecoration(
                                  hintText: 'Asset Money Value',
                                ),
                              onChanged: (value){
                                  setState(() {
                                    asset_money_value = value;

                                  });
                                  update();

                              },
                              style: TextStyle(fontSize: 14)
                            )
                        )
                    ),
                    SizedBox(
                        height: 35,
                        width: 150,
                        child:
                        Container(
                            margin:EdgeInsets.only(left:20),
                            child:  TextField(
                              controller: nextInspectionController,
                              decoration: InputDecoration(
                                hintText: 'Inspection Date',
                              ),
                              readOnly: true,
                              onTap: () async{
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(), //get today's date
                                    firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101)
                                );
                                if(pickedDate!= null)
                                  setState(() {
                                    nextInspectionController.text = DateFormat('yyyy-MM-dd').format(pickedDate);//set foratted date to TextField value.
                                    next_inspection = pickedDate;
                                  });
                                update();

                              },
                            )
                        )
                    ),
                    SizedBox(
                        height: 35,
                        width: screenWidth - 1150 > 400 ? 400 : screenWidth - 1150 ,
                        child:
                        Container(
                            margin:EdgeInsets.only(left:20),
                            child: TextField(
                              controller: commentController,
                                decoration: InputDecoration(
                                  hintText: 'Comments',
                                ),
                              onChanged: (value){
                                setState(() {
                                  comment = value;
                                });
                                update();
                              },
                            )
                        )
                    ),
                    if(is_focus)
                      Container(
                          margin: EdgeInsets.only(top:5,left:10),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Image.asset('assets/images/delete.png'),
                                onPressed: () {
                                  widget.onDelete!(widget.id!);
                                },
                              )
                          )
                      )
                  ]
              ),


        )

    );
  }
}