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
  String? status;
  String? value;
  Function(String id, DateTime inspection_date,bool condition,String asset_money_value,DateTime next_inspection, String comment, String value, String status)? onChange;
  Function(String id)? onDelete;
  InspcetionItem({super.key,this.status,this.value,this.id,this.logo,this.inspection_date,this.asset_money_value,this.next_inspection,this.comment,this.functional_condition,this.onChange,this.onDelete});
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
  String? status = 'Active';
  String? asset_value;
  List<String> status_list = ['Active','Disposed','Non Operational','UnAccounted','Sold Off'];
  TextEditingController inspectionController = TextEditingController();
  TextEditingController amountControlller = TextEditingController();
  TextEditingController valueController = TextEditingController();
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
      status =  widget.status;
      asset_value = widget.value;
      valueController.text = asset_value!;
    });
  }
  void update(){
    widget.onChange!(widget.id!,inspection_date!,functional_condition!,asset_money_value!,next_inspection!,comment!,asset_value!,status!);
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
                    SizedBox(
                        height: 35,
                        width: 70,
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
                        width : 170,
                        height : 60,
                        child: DropdownButton<String>(
                          value: status,
                          padding: EdgeInsets.all(5),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              status = newValue;
                            });
                          },
                          items: status_list.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                    ),
                    SizedBox(
                        height: 35,
                        width: 70,
                        child:
                        Container(
                            margin:EdgeInsets.only(left:20),
                            child: TextField(
                                controller: valueController,
                                decoration: InputDecoration(
                                  hintText: 'Asset Value',
                                ),
                                onChanged: (value){
                                  setState(() {
                                    asset_value = value;
                                  });
                                  update();

                                },
                                style: TextStyle(fontSize: 14)
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