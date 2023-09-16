import 'dart:convert';
import 'dart:typed_data';

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
  String userid = 'bdMg1tPZwEUZA1kimr8b';
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
  TextEditingController folderEditController = TextEditingController();
  TextEditingController groupEditController = TextEditingController();
  TextEditingController phoneEditController = TextEditingController();
  TextEditingController officeEditController = TextEditingController();
  TextEditingController faxEditController = TextEditingController();

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

    // String? userDataString =  getStorage('user');
    // Map<String, dynamic>? data =  jsonDecode(userDataString!);
    // setState(() {
    //   userid = data?['id'];
    // });
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
    final double textfield_width = screenWidth > 1260 ? (screenWidth - 500)/2 : (screenWidth - 350)/2 ;
    double renewal_width = textfield_width * 2 - 410;
    if(renewal_width < 50) renewal_width = 50;
    return  Column(
      children: [
        Row(
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

            Expanded(child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        height: 50,
                        width: textfield_width,
                        child:
                        Container(
                            margin:EdgeInsets.only(left:20),
                            child: TextFormField(
                              controller: nameEditController,
                              decoration: InputDecoration(
                                labelText: 'Tenant Name',
                              ),
                              onChanged: (value){
                                setState(() {
                                  tenant_data.name = value;
                                });
                              },
                            )
                        )

                    ),
                    SizedBox(
                      height: 50,
                      width: textfield_width,
                      child:  Container(
                          margin:EdgeInsets.only(left:20),
                          child: TextFormField(
                              controller: addressEditController,
                              decoration: InputDecoration(
                                labelText: 'POSTAL ADDRESS',
                              ),
                              onChanged: (value){
                                setState(() {
                                  tenant_data.address = value;
                                });
                              }
                          )
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(
                        height: 50,
                        width: textfield_width,
                        child:
                        Container(
                            margin:EdgeInsets.only(left:20),
                            child: TextFormField(
                                controller: emailEditController,
                                decoration: InputDecoration(
                                  labelText: 'Tenant Email',
                                ),
                                onChanged: (value){
                                  setState(() {
                                    tenant_data.email = value;
                                  });
                                }
                            )
                        )

                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        SizedBox(height: 15),
                        SizedBox(
                            width: textfield_width - 20 ,
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
                      ],
                    )
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(
                        height: 50,
                        width: textfield_width,
                        child:
                        Container(
                            margin:EdgeInsets.only(left:20),
                            child: TextFormField(
                              controller: landlineEditController,
                              decoration: InputDecoration(
                                labelText: 'Tenant Landline',
                              ),
                              onChanged: (value){
                                setState(() {
                                  tenant_data.landline = value;
                                });
                              },

                            )
                        )

                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        SizedBox(height: 15),
                        SizedBox(
                            width: textfield_width - 20 ,
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
                SizedBox(height: 5),
                Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                            height: 50,
                            width: textfield_width,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20),
                                child: TextFormField(
                                    controller: phoneEditController,
                                    decoration: InputDecoration(
                                      labelText: 'Tenant Mobile',
                                    ),
                                    onChanged: (value){
                                      setState(() {
                                        tenant_data.phone = value;
                                      });
                                    }
                                )
                            )

                        ),
                        SizedBox(
                          height: 50,
                          width: textfield_width,
                          child:  Container(
                              margin:EdgeInsets.only(left:20),
                              child: TextFormField(
                                  controller: faxEditController,
                                  decoration: InputDecoration(
                                    labelText: 'Faxline',
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      tenant_data.fax = value;
                                    });
                                  }
                              )
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                            height: 50,
                            width: textfield_width,
                            child:
                            Container(
                                margin:EdgeInsets.only(left:20,top:0),
                                child: TextFormField(
                                    controller: officeEditController,
                                    decoration: InputDecoration(
                                      labelText: 'Office location',

                                    ),
                                    onChanged: (value){
                                      setState(() {
                                        tenant_data.office = value;
                                      });
                                    }
                                )
                            )

                        ),
                        SizedBox(
                            height: 50,
                            width: textfield_width,
                            child:
                            Container(
                              margin: EdgeInsets.only(left:10,top:25),
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
                                  ),
                                  SizedBox(
                                      width:3
                                  ),
                                  Text('Show Asset Types')
                                ],
                              )
                            )
                        )
                      ],
                    )
                  ],
                ),
                Row(children: [
                  SizedBox(width:textfield_width * 2 - 100),
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
          ],
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitledContainer(titleText: '',
                child: Row(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width:5
                        ),
                        Checkbox(
                          value: tenant_data?.active,
                          onChanged: (bool? value) {

                          },
                        ),
                        SizedBox(
                            width:3
                        ),
                        Text('Account Active')
                      ],
                    ),
                    SizedBox(width: 25),
                    Row(children: [
                      Text('Renewal Date'),
                      SizedBox(
                          height: 35,
                          width: renewal_width > 300 ? 300 : renewal_width,
                          child:
                          Container(
                              margin:EdgeInsets.only(left:20,bottom:3),
                              child: TextFormField(
                                style: TextStyle(fontSize: 16),
                                initialValue: tenant_data.renewal_date.toString(),
                                decoration: InputDecoration(
                                  labelText: '',

                                ),
                                onChanged: (value){

                                },
                                enabled: false,
                              )
                          )

                      )
                    ]),

                  ],
                ) )
          ],
        )
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
