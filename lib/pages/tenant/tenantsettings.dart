import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:assetmamanger/apis/countries.dart';
import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/models/folders.dart';
import 'package:assetmamanger/models/groups.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:image_picker_web/image_picker_web.dart';

class TenantSettings extends StatefulWidget {
  TenantSettings({super.key});
  @override
  _TenantSettings createState() => _TenantSettings();
}
class  _TenantSettings extends State<TenantSettings> {

  int hoveredIndex = -1;
  Tenant tenant_data = Tenant(name: '', email: '', active: false,   address: '', phone: '', fax: '', landline: '', office: '', renewal_date: DateTime(2023,1,1),   user_id: '',logo : 'https://coinscipher.com/wp-content/uploads/2023/07/file-48.jpg');
  String userid = 'DHIKw96a6xWlS8K1DKxl';
  String group = '';
  String folder = '';
  Uint8List? logo_image = null;
  List<String> level_list = ['1','2','3','4','5','6'];
  String current_level = '1';
  List<String> country_list = [];
  String current_country = '';
  List<Map<String, dynamic>> m_countries = [];
  bool show_asset_types = false;

  //------------------Controllers For TextField-----------------------------------//
  TextEditingController nameEditController = TextEditingController();
  TextEditingController emailEditController = TextEditingController();
  TextEditingController addressEditController = TextEditingController();
  TextEditingController landlineEditController = TextEditingController();
  TextEditingController phoneEditController = TextEditingController();
  TextEditingController officeEditController = TextEditingController();
  TextEditingController faxEditController = TextEditingController();
  TextEditingController firstEditController = TextEditingController();
  TextEditingController lastEditController = TextEditingController();

  void loadData () async{
    Tenant? result =  await TenantService().getTenantDetails(userid);
    if(result != null){
      setState(() {
        tenant_data = result;
      });
    }else{
      setState(() {
        tenant_data.user_id = userid;
      });
    }

    nameEditController.text = tenant_data.name!;
    emailEditController.text = tenant_data.email!;
    addressEditController.text = tenant_data.address!;
    landlineEditController.text = tenant_data.landline!;
    firstEditController.text = tenant_data.firstname!;
    lastEditController.text = tenant_data.lastname!;
    phoneEditController.text = tenant_data.phone!;
    officeEditController.text = tenant_data.office!;
    faxEditController.text = tenant_data.fax!;
  //----------------------------Load Country Data---------------------------//
   List<Map<String, dynamic>> data =  await CountryService().getCountries();
   setState(() {
     m_countries = data;
   });
    country_list = [];
   for (Map<String, dynamic> item in data){
     setState(() {
       country_list.add(item['id']);
     });
   }
   if(country_list.length > 0){
     setState(() {
       current_country = country_list[0];
     });
   }
   if(tenant_data.country == '')
     tenant_data.country = current_country;
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    String? userDataString =  getStorage('user');
    Map<String, dynamic>? data =  jsonDecode(userDataString!);
    setState(() {
      userid = data?['id'];
    });
    loadData();

  }

  void onSave() async{

    if(logo_image != null) {
      String url =  await uploadFile(logo_image);
      tenant_data.logo = url;
    }

    bool isOk = await TenantService().createTenantDetails(tenant_data);
    if(isOk){
      showSuccess('Success');
    }else{
      showError('Error');
    }
  }
  String getCountryName(String id){
    for (Map<String, dynamic> item in m_countries){
      if(item['id'] == id) return item['text'];
    }
    return '';
  }
  Widget getLargeWidget(context){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double textfield_width = screenWidth > 1260 ? (screenWidth - 500) : (screenWidth - 350) ;
    double renewal_width = textfield_width * 2 - 410;
    if(renewal_width < 50) renewal_width = 50;
    return  Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.asset('assets/images/home.jpg',width: 200,height: 150),
            GestureDetector(
                onTap:() async{
                  // Image? fromPicker = await ImagePickerWeb.getImageAsWidget();
                  Uint8List? data =  await ImagePickerWeb.getImageAsBytes();
                  setState(() {
                    logo_image = data!;
                  });
                },
                child:  Container(
                    width:200,
                    height: 150,
                    child: logo_image != null? Image.memory(logo_image!) : (tenant_data.logo == '' ? Image.asset('assets/images/home.jpg') : Image.network(tenant_data.logo!))
                )
            ),
            SizedBox(width:20),
            Expanded(child:
              SizedBox(height: screenHeight - 170,
                  child: ListView(
                    children: [
                      Row(children: [
                        Container(child: Text('First Name:'),margin: EdgeInsets.only(top:10,right : 31)),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 143,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                  controller: firstEditController,
                                  decoration: InputDecoration(

                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      tenant_data.firstname = value;
                                    });
                                  },
                                )
                            )
                        ),
                      ]),
                      Row(children: [
                        Container(child: Text('Last Name:'),margin: EdgeInsets.only(top:10,right:32)),
                        SizedBox(
                          height: 40,
                          width: textfield_width - 143,
                          child:  Container(
                              margin:EdgeInsets.only(left:20),
                              child: TextFormField(
                                  controller: lastEditController,
                                  onChanged: (value){
                                    setState(() {
                                      tenant_data.lastname = value;
                                    });
                                  }
                              )
                          ),
                        ),

                      ]),
                      SizedBox(height: 5),
                      Row(children: [
                        Container(child: Text('Tenant Name:'),margin: EdgeInsets.only(top:10,right: 16)),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 140,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                  controller: nameEditController,
                                  onChanged: (value){
                                    setState(() {
                                      tenant_data.name = value;
                                    });
                                  },
                                )
                            )

                        ),

                      ]),
                      Row(children: [
                        Container(child: Text('Tenant Email:'),margin: EdgeInsets.only(top:10,right : 20)),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 138,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller: emailEditController,
                                    onChanged: (value){
                                      setState(() {
                                        tenant_data.email = value;
                                      });
                                    }
                                )
                            )

                        ),
                      ]),
                      Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top:0),
                                child: Text('Cut Off Level:')
                            ),
                            SizedBox(width : 35),
                            SizedBox(
                                width: textfield_width - 154 ,
                                child: DropdownButton<String>(
                                  value: tenant_data.cut_off_level,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      tenant_data.cut_off_level = newValue!;
                                    });
                                  },
                                  items: level_list.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )
                            )
                          ]),
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top:5),
                              child: Text('Country:')
                          ),
                          SizedBox(width : 65),
                          Column(
                            children: [
                              SizedBox(
                                  width: textfield_width - 152 ,
                                  child: DropdownButton<String>(
                                    value: tenant_data.country,
                                    isExpanded: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        tenant_data.country = newValue!;
                                      });
                                    },
                                    items: country_list.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(getCountryName(value)),
                                      );
                                    }).toList(),
                                  )
                              )
                            ],
                          )
                        ],
                      ),

                      Row(children: [
                        Container(child: Text('Tenant Mobile:'),margin: EdgeInsets.only(top:10,right:10)),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 132,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller: phoneEditController,

                                    onChanged: (value){
                                      setState(() {
                                        tenant_data.phone = value;
                                      });
                                    }
                                )
                            )

                        ),
                      ]),
                      Row(children: [
                        Container(child: Text('Tenant Landline:'),margin: EdgeInsets.only(top:10)),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 130,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                  controller: landlineEditController,

                                  onChanged: (value){
                                    setState(() {
                                      tenant_data.landline = value;
                                    });
                                  },

                                )
                            )

                        ),
                      ]),
                      Row(children: [
                        Container(child: Text('Office Location:'),margin: EdgeInsets.only(top:10,right:5)),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 130,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20,top:0),
                                child: TextFormField(
                                    controller: officeEditController,
                                    onChanged: (value){
                                      setState(() {
                                        tenant_data.office = value;
                                      });
                                    }
                                )
                            )

                        ),
                      ]),
                      Row(children: [
                        Container(child: Text('Show Asset Type:'),margin: EdgeInsets.only(top:10)),
                        SizedBox(
                            height: 40,
                            width: textfield_width - 150,
                            child:
                            Container(
                                margin: EdgeInsets.only(left:10,top:15),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width:5
                                    ),
                                    Checkbox(
                                      value: tenant_data == null ? false : tenant_data.show_asset_types,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          tenant_data.show_asset_types = value!;
                                        });
                                      },
                                    )
                                  ],
                                )
                            )
                        ),
                      ]),
                      SizedBox(height: 13),
                      Row(
                        children: [
                          Text('Account Active:'),
                          SizedBox(width : 30),
                          Text(tenant_data.active == true? 'Yes' : 'No')
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(children: [
                        Text('Renewal Date:'),
                        SizedBox(width : 30),
                        Text(tenant_data.created_date == null ? '' : DateFormat('yyyy-MM-dd').format(tenant_data.created_date!))
                      ]),
                      SizedBox(height: 10),
                      Row(children: [
                        Container(
                            padding: EdgeInsets.only(top:10),
                            width: 100, // Set the desired width here
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.green),
                                    padding:MaterialStateProperty.all(const EdgeInsets.all(20)),

                                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                                onPressed: onSave,
                                child: const Text('Save'))
                        )
                      ])

                    ],
                  )
              )

            )
          ],
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool is_Large = screenWidth > 800;
    return  Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left:0),
      child: Column(
        children: [
         Expanded(child: TitledContainer(
             titleText: 'TENANT Details',
             idden: 10,
             title_color: Colors.orange.withOpacity(0.8),
             child:  getLargeWidget(context)
         ))
        ],
      ),
    );
  }
}
