import 'package:assetmamanger/apis/countries.dart';
import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/models/folders.dart';
import 'package:assetmamanger/models/groups.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/pages/admin/countryTreeView.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class AdminView extends StatefulWidget {
  AdminView({super.key});
  @override
  _AdminViewState createState() => _AdminViewState();
}
class  _AdminViewState extends State<AdminView> {
  //---------------------entire Data-------------------------------//
  List<String> entries = <String>['Tenant1', 'Tenant2', 'Tenant3', 'Tenant4'];
  List<Tenant> m_tenants = [];
  //---------------------hover style-------------------------------//
  int hoveredIndex = -1;
  int hoveredIndex_2 = -1;
 //----------------------Tenant Details----------------------------//
  Tenant cur_tenant = Tenant();
  bool active_value = false;
  TextEditingController tenantNameEditController = TextEditingController();
  TextEditingController emailAddressEditController = TextEditingController();
  TextEditingController expiryDateEditController = TextEditingController();
  TextEditingController registerationEditController = TextEditingController();
  TextEditingController firstNameEditController = TextEditingController();
  TextEditingController lastNameEditController = TextEditingController();

 //-------------------- Reason Input Dialog--------------------------//
  String reason = '';
 //----------------------search Data--------------------------------//
  List<Tenant> filteredItems = [];
  //---------------------Left Side Bar -------------------------------//
  bool showing_bar = false;
  //---------------------Load Country Data----------------------------//
  List<Map<String, dynamic>> countryData = [];
  Map<String, dynamic> detailData = {};
  final _key = GlobalKey<CountryTreeViewState>();
  String new_country_name = '';
  //----------------------Right Content Select------------------------//
  bool isTenantorCountry = true;
  void fetchData() async{
    List<Tenant> tenants =  await TenantService().getAllTenant();
    List<Map<String, dynamic>> serverData = await CountryService().getCountries();
    setState((){
      m_tenants = tenants;
      filteredItems = List.from(m_tenants);
      if(m_tenants.length > 0)
      onLeftItemClicked(m_tenants[0].user_id!);
      countryData = serverData;
    });

  }
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void searchItems(String query) {
    filteredItems = m_tenants.where((item) => item.name!.contains(query)).toList();
  }
  void onLeftItemClicked(String user_id){
    List<Tenant> results =  m_tenants.where((element) => element.user_id == user_id).toList();
    if(results.length == 0)
      return;
    List<Folder> temp = [];
    setState(() {

       cur_tenant = results[0];
       firstNameEditController.text = cur_tenant.firstname!;
       lastNameEditController.text = cur_tenant.lastname!;
       tenantNameEditController.text = cur_tenant.name!;
       emailAddressEditController.text = cur_tenant.email!;
       registerationEditController.text = DateFormat('yyyy-MM-dd').format(cur_tenant.created_date!);
       expiryDateEditController.text =  DateFormat('yyyy-MM-dd').format(cur_tenant.created_date!.add(Duration(days: 30)));
     });
  }
  void onSave() async{
    bool isOk = await TenantService().createTenantDetails(cur_tenant);
    if(isOk){
      showSuccess('Success');
    }else{
      showError('Error');
    }
  }
  void sendActiveAccountEmail() async{
    String registered_date = DateFormat('yyyy-MM-dd').format(cur_tenant.created_date!);
    String expired_date =  DateFormat('yyyy-MM-dd').format(cur_tenant.created_date!.add(Duration(days: 30)));

    String email = cur_tenant.email!;
    String title = '${cur_tenant.name} Account Approved';
    String Body  = '<html><body>'
        '<p>Geo Asset Manager has approved a trial account for ${cur_tenant.name}. Details of your account and trial period is provided below.</p>'
        '<p>Account Name: ${cur_tenant.name}</p>'
        '<p>Email: ${cur_tenant.email}</p>'
        '<p>Trial Period: From: $registered_date -to $expired_date </p>'
        '<p style = "margin-top:10px">Thank you for your patient and If you require assistance, do get in touch with us on the following email address.</p>'
        '<p>Email: geoAssetManager@gmail.com</p>'
        '<p style = "margin-top:10px">Thank you</p>'
        '<p>System Admin</p>'
        '<p style = "margin-top:10px">Geo Asset Manager</p>'
        '</body></html>';
    sendEmail(email, title, Body);
  }
  void sendDeActiveAccountEmail() async{
    String email = cur_tenant.email!;
    String title = 'Account Deactivated';
    String Body  = '<html><body>'
        '<p>Dear ${cur_tenant.firstname} ${cur_tenant.lastname}.</p>'
        '<p>The account for ${cur_tenant.name} has been deactivated because $reason.</p>'
        '<p style = "margin-top:10px">If you have further quereies, please contact us on the following.</p>'
        '<p>Email: geoAssetManager@gmail.com</p>'
        '<p>Landline: (+675) 325 2552</p>'
        '<p style = "margin-top:10px">Thank you</p>'
        '<p style = "margin-top:10px">Geo Asset Manager</p>'
        '<p>System Admin</p>'
        '</body></html>';
    sendEmail(email, title, Body);
  }
  void addNewCountry() async{
    bool isOK = await CountryService().createCountry(new_country_name, generateID(length: 3));
    if(isOK == true){
      showSuccess('Success');
    }else{
      showError('Error');
    }
    setState(() {
      countryData = [];
    });
    List<Map<String, dynamic>> serverData = await CountryService().getCountries();
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        countryData = serverData;
      });
    });
  }
  void deleteCountry() async{
    String id  = detailData['id'];
    bool isOK = await CountryService().deleteCountry(id);
    if(isOK == true){
      showSuccess('Success');
    }else{
      showError('Error');
    }
    setState(() {
      countryData = [];
    });
    List<Map<String, dynamic>> serverData = await CountryService().getCountries();
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        countryData = serverData;
        detailData = {};
        _key.currentState!.fetchData();
      });
    });

  }
  void changeCountry() async{
    String id = detailData['id'];
    bool isOk = await CountryService().saveChanges(detailData);
    if(isOk){
      showSuccess('Success');
    }else{
      showError('Error');
    }
    setState(() {
      countryData = [];
      detailData = {};
    });
    List<Map<String, dynamic>> serverData = await CountryService().getCountries();
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        countryData = serverData;
      });
      for(Map<String, dynamic> item in countryData) {
        if(item['id'] == id) {
          setState(() {
            detailData = item;
          });
          Future.delayed(const Duration(milliseconds: 20), () {
            _key.currentState!.fetchData();
          });
          break;
        }
      }

    });
  }
  StatefulBuilder gradeDialog(bool? value) {
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text('Please enter the reason for action.'),
          content:
          Container(
              height: 150,
              child:
                SizedBox(
                  width:300,
                  child: TextField(
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: 'Reason',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value){
                      setState(() {
                        reason = value;
                      });
                    },
                  ))

          ),

          actions: [
            ElevatedButton(
              onPressed:(){
                setState(() {
                  cur_tenant.active = value!;
                });
                  sendDeActiveAccountEmail();
                Navigator.pop(context);
              },
              child: Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  StatefulBuilder createDialog() {
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text( 'Add Country', style: TextStyle(fontSize: 16)),
          content:
          Container(
              height: 50,
              child:
              SizedBox(
                  width:200,
                  child: TextFormField(
                    initialValue: '',
                    decoration: InputDecoration(
                      labelText: 'Country Title',
                    ),
                    onChanged: (value){
                      setState(() {
                        new_country_name = value;
                      });
                    },
                  ))

          ),
          actions: [
            ElevatedButton(
              onPressed:(){
                addNewCountry();
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  StatefulBuilder deleteDialog() {
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text( 'Delete Country - ${detailData['text']}', style: TextStyle(fontSize: 16)),
          content:
          Container(
              height: 50,
              child:
              SizedBox(
                  width:200,
                  child:  Text('Would you really delete this country?')
              )
          ),
          actions: [
            ElevatedButton(
              onPressed:(){
                deleteCountry();
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
  StatefulBuilder editDialog() {
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text( 'Edit Country', style: TextStyle(fontSize: 16)),
          content:
          Container(
              height: 50,
              child:
              SizedBox(
                  width:200,
                  child: TextFormField(
                    initialValue: detailData['text'],
                    decoration: InputDecoration(
                      labelText: 'Country Title',
                    ),
                    onChanged: (value){
                      setState(() {
                        detailData['text'] = value;
                      });
                    },
                  ))

          ),
          actions: [
            ElevatedButton(
              onPressed:(){
                changeCountry();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  String getCountryName(String id) {
    for(Map<String, dynamic> item in countryData) {
      if(item['id'] == id) {
          return item['text'];
      }
    }
    return '';
  }
  Widget getLargeWidget(BuildContext context){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double textfield_width = (screenWidth - 600);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            width : 300,
            color:Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: screenHeight - 390, child : Column(
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
                            labelText: 'Search...',
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
                            setState(() {
                              isTenantorCountry = true;
                            });
                            Future.delayed(const Duration(milliseconds: 20), () {
                              // Handle mouse press event
                              onLeftItemClicked(filteredItems[index].user_id!);
                              print('Item pressed: ${filteredItems[index].name}');
                            });

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
                                  Image.asset('assets/images/tenant.png'),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text('${filteredItems[index].name}'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
                  ],
                )),
                SizedBox(height: 300, child : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top:10),
                      child:  Text('Allowed Countries',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(child: ListView.builder(
                      padding: const EdgeInsets.only(top: 0),
                      itemCount: countryData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {

                            setState(() {
                              isTenantorCountry = false;
                              detailData = countryData[index];
                            });
                            Future.delayed(const Duration(milliseconds: 20), () {
                              _key.currentState!.fetchData();
                            });
                          },
                          child: MouseRegion(
                            onEnter: (event) {
                              setState(() {
                                hoveredIndex_2 = index;
                              });
                            },
                            onExit: (event) {
                              setState(() {
                                hoveredIndex_2 = -1;
                              });
                            },

                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: 40,
                              color: hoveredIndex_2 == index ? Color.fromRGBO(150, 150, 150, 0.2) : Colors.white,
                              child: Row(
                                children: [
                                  Image.asset('assets/images/country.png'),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text('${countryData[index]['text']}'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: 80,
                              height:50,
                              child : FloatingActionButton(
                                heroTag: "btn1",
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (context) => createDialog(),
                                  );
                                },
                                child: const Icon(Icons.add),
                              ) ),
                          SizedBox(
                              width: 80,
                              height:50,
                              child : FloatingActionButton(
                                heroTag: "btn2",
                                onPressed: (){
                                  if(detailData['id'] == null) return;
                                  showDialog(
                                    context: context,
                                    builder: (context) => deleteDialog(),
                                  );
                                },
                                child: const Icon(Icons.delete),
                              ) ),
                          SizedBox(
                              width: 80,
                              height:50,
                              child : FloatingActionButton(
                                heroTag: "btn3",
                                onPressed: (){
                                  if(detailData['id'] == null) return;
                                  showDialog(
                                    context: context,
                                    builder: (context) => editDialog(),
                                  );
                                },
                                child: const Icon(Icons.edit),
                              ) )
                    ])
                  ],
                ))
              ],
            )

        ),
        Expanded(
            child:
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(left:30),
              child: ListView(
                children: [
                  if(isTenantorCountry) TitledContainer(
                      titleText: 'TENANT Details',
                      idden: 10,
                      child: Row(
                        children: [
                          cur_tenant.logo == null || cur_tenant.logo == ''  ? Image.asset('assets/images/tenant.png',width: 200,height: 150) : Image.network(cur_tenant.logo!,width: 200,height: 150),
                          Expanded(child:
                          Column(
                            children: [
                                  Row(children: [
                                    Text("First Name: "),
                                    SizedBox(width: 165),
                                    Text(cur_tenant == null ? "Not Selected" : cur_tenant!.firstname, style: TextStyle(fontWeight: FontWeight.w600))
                                  ]),
                                  SizedBox(height: 10),
                                  Row(children: [
                                    Text("Last Name: "),
                                    SizedBox(width: 165),
                                    Text(cur_tenant == null ? "Not Selected" : cur_tenant!.lastname, style: TextStyle(fontWeight: FontWeight.w600))
                                  ]),
                                  SizedBox(height: 10),
                                  Row(children: [
                                    Text("Tenant Name: "),
                                    SizedBox(width: 147),
                                    Text(cur_tenant.name == null ? "Not Selected" : cur_tenant!.name!, style: TextStyle(fontWeight: FontWeight.w600))
                                  ]),
                                  SizedBox(height: 10),
                                  Row(children: [
                                    Text("Tenant Email: "),
                                    SizedBox(width: 151),
                                    Text(cur_tenant.email == null ? "Not Selected" : cur_tenant!.email!, style: TextStyle(fontWeight: FontWeight.w600))
                                  ]),
                                  SizedBox(height: 10),
                                  Row(children: [
                                    Text("Mobile: "),
                                    SizedBox(width: 186),
                                    Text(cur_tenant.phone == null ? "Not Selected" : cur_tenant!.phone!, style: TextStyle(fontWeight: FontWeight.w600))
                                  ]),
                                  SizedBox(height: 10),
                                  Row(children: [
                                    Text("Landline: "),
                                    SizedBox(width: 178),
                                    Text(cur_tenant.landline == null ? "Not Selected" : cur_tenant!.landline!, style: TextStyle(fontWeight: FontWeight.w600))
                                  ]),
                                  SizedBox(height: 10),
                                  Row(children: [
                                    Text("Country: "),
                                    SizedBox(width: 180),
                                    Text(cur_tenant.country == null ? "Not Selected" : getCountryName(cur_tenant!.country) , style: TextStyle(fontWeight: FontWeight.w600))
                                  ]),
                                  SizedBox(height: 10),
                                  Row(children: [
                                    Text("Branches in more than 1 location: "),
                                    SizedBox(width: 24),
                                    Text(cur_tenant.hasOffice == null ? "Not Selected" : cur_tenant!.hasOffice ? 'Yes' : 'No', style: TextStyle(fontWeight: FontWeight.w600))
                                  ]),
                                  SizedBox(height: 10),
                                  Row(children: [
                                    Text("Geo Structure Cut of Level: "),
                                    SizedBox(width: 67),
                                    Text(cur_tenant.cut_off_level == null ? "Not Selected" : cur_tenant!.cut_off_level, style: TextStyle(fontWeight: FontWeight.w600))
                                  ]),
                                  SizedBox(height: 10),
                                  Row(children: [
                                    Text("Show Asset Type in Asset Tree View: "),
                                    SizedBox(width: 10),
                                    Text(cur_tenant.show_asset_types == null ? "Not Selected" : cur_tenant!.show_asset_types ? 'Yes' : 'No', style: TextStyle(fontWeight: FontWeight.w600))
                                  ]),
                                  SizedBox(height: 10),
                                  Row(children: [
                                    Text("Account Activated?: "),
                                    SizedBox(width: 102),
                                    SizedBox(width:120,height:30,child: Row(
                                      children: [
                                         Checkbox(
                                          value: cur_tenant.active==null?false:cur_tenant.active,
                                          onChanged: (bool? value) {
                                            if(value! == true) {
                                              setState((){
                                                  cur_tenant.active = value;
                                              });

                                            sendActiveAccountEmail();
                                            } else
                                              setState(() {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => gradeDialog(value)  ,
                                                );
                                              });
                                          },
                                        )
                                      ],
                                    ))
                                  ]),
                                  SizedBox(height: 10),
                                  Row(children: [
                                    Text("Account Renewal Date: "),
                                    SizedBox(width: 88),
                                    Text(cur_tenant.renewal_date == null ? "Not Selected" : DateFormat('yyyy-MM-dd').format(cur_tenant.renewal_date!), style: TextStyle(fontWeight: FontWeight.w600))
                                  ]),
                                  SizedBox(height: 25),
                                  Row(children: [
                                    SizedBox(width:135,height:40,child:
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Colors.red),
                                            padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                                            textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                                        onPressed:  onSave,
                                        child: const Text('Save Changes')))
                                  ])

                            ],
                          )

                          )
                        ],
                      )
                  ),
                  if(!isTenantorCountry) TitledContainer(
                      titleText: 'Country Details',
                      idden: 10,
                      child:  Container(
                        height: screenHeight - 200,
                        alignment: Alignment.topCenter,
                        child: CountryTreeView(key : _key, id :  detailData['id'] == null ? '' : detailData['id']),
                      )
                  )
                ],
              ),
            )

        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return   getLargeWidget(context);
  }
}
