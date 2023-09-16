import 'package:assetmamanger/apis/tenants.dart';
import 'package:assetmamanger/models/folders.dart';
import 'package:assetmamanger/models/groups.dart';
import 'package:assetmamanger/models/tenants.dart';
import 'package:assetmamanger/pages/admin/countryTreeView.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';
import 'package:assetmamanger/utils/global.dart';
import 'package:flutter/material.dart';
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

 //----------------------Tenant Details----------------------------//
  Tenant cur_tenant = Tenant();
  bool active_value = false;
  TextEditingController tenantNameEditController = TextEditingController();
  TextEditingController emailAddressEditController = TextEditingController();
  TextEditingController expiryDateEditController = TextEditingController();
  TextEditingController registerationEditController = TextEditingController();
 //-------------------- Reason Input Dialog--------------------------//
  String reason = '';
 //----------------------search Data--------------------------------//
  List<Tenant> filteredItems = [];
  //---------------------Left Side Bar -------------------------------//
  bool showing_bar = false;

  void fetchData() async{
    List<Tenant> tenants =  await TenantService().getAllTenant();
    setState((){
      m_tenants = tenants;
      filteredItems = List.from(m_tenants);
      if(m_tenants.length > 0)
      onLeftItemClicked(m_tenants[0].user_id!);
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
       tenantNameEditController.text = cur_tenant.name!;
       emailAddressEditController.text = cur_tenant.email!;
       registerationEditController.text = cur_tenant.created_date.toString();

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
    String email = cur_tenant.email!;
    String title = '${cur_tenant.name} Account Activated';
    String Body  = '<html><body><p>Welcome ${cur_tenant.name}. Your account has been activated by Cloud Asset. You can now use your username and email to sign into Cloud Asset. Simply get started by doing the following in order.</p>'
        '<p style = "margin-top:10px">1. Create Asset Folder</p>'
        '<p>2. Create Asset Groups</p>'
        '<p>3. Create Asset Types</p>'
        '<p>4. Create Asset Categories</p>'
        '<p>5. Register Asset Cloud users for your company or organization.</p>'
        '<p style = "margin-top:10px">If you have any queries, please contact CloudAsset@minsoft.com.pg or telephone on (675) 3221 2551.</p>'
        '<p style = "margin-top:10px">Thank You</p>'
        '<p style = "margin-top:10px">Cloud Asset Admin</p>'
        '</body></html>';
    sendEmail(email, title, Body);
  }
  void sendDeActiveAccountEmail() async{
    String email = cur_tenant.email!;
    String title = '${cur_tenant.name} Account Deactivated';
    String Body  = '<html><body><p>Your account ${cur_tenant.name} has been inactivated for the following reasons by Cloud Asset:</p>'
        '<p style = "margin-top:10px">${reason}</p>'
        '<p style = "margin-top:10px">If you have any queries, please contact CloudAsset@minsoft.com.pg or telephone on (675) 3221 2551.</p>'
        '<p style = "margin-top:10px">Thank You</p>'
        '<p style = "margin-top:10px">Cloud Asset Admin</p>'
        '</body></html>';
    sendEmail(email, title, Body);
  }
  StatefulBuilder gradeDialog() {
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          title: Text('Please enter the reason for deactivation.'),
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
                  cur_tenant.active = false;
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
  Widget getLargeWidget(BuildContext context){
    final screenWidth = MediaQuery.of(context).size.width;
    final double textfield_width = (screenWidth - 600)/2;
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
                        // Handle mouse press event
                        onLeftItemClicked(filteredItems[index].user_id!);
                        print('Item pressed: ${filteredItems[index].name}');
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
            )
        ),
        Expanded(
            child:
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(left:30),
              child: ListView(
                children: [
                  TitledContainer(
                      titleText: 'TENANT Details',
                      idden: 10,
                      child: Row(
                        children: [
                          cur_tenant.logo == null || cur_tenant.logo == ''  ? Image.asset('assets/images/tenant.png',width: 200,height: 150) : Image.network(cur_tenant.logo!,width: 200,height: 150),
                          Expanded(child:
                          Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      height: 50,
                                      width: textfield_width,
                                      child: Container(
                                          margin:EdgeInsets.only(left:20),
                                          child: TextField(
                                            controller: tenantNameEditController,
                                            decoration: InputDecoration(
                                              labelText: 'Tenant Name'
                                            ),
                                            style: TextStyle(fontSize: 16),
                                            readOnly: true,
                                          )
                                      )

                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: textfield_width,
                                    child:  Container(
                                        margin:EdgeInsets.only(left:20),
                                        child: TextField(
                                          controller: expiryDateEditController,
                                          decoration: InputDecoration(
                                            labelText: 'Expiry Date',
                                          ),
                                          readOnly: true,
                                        )
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                      height: 50,
                                      width: textfield_width,
                                      child:
                                      Container(
                                          margin:EdgeInsets.only(left:20),
                                          child: TextField(
                                            controller: emailAddressEditController,
                                            decoration: InputDecoration(
                                              labelText: 'Email Address',
                                            ),
                                            readOnly: true,
                                          )
                                      )

                                  ),
                                  SizedBox(
                                      height: 50,
                                      width: textfield_width,
                                      child:
                                      Container(
                                          margin:EdgeInsets.only(left:20),
                                          child: TextField(
                                            controller: registerationEditController,
                                            decoration: InputDecoration(
                                              labelText: 'Registeration Date',
                                            ),
                                            readOnly: true,
                                          )
                                      )
                                  )
                                ],
                              ),

                              SizedBox(height:10),
                              Row(
                                children: [
                                  SizedBox(width:120,height:40,child: Row(
                                    children: [
                                      SizedBox(
                                          width:15
                                      ),
                                      Checkbox(
                                        value: cur_tenant.active==null?false:cur_tenant.active,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if(value == true){
                                              sendActiveAccountEmail();
                                              cur_tenant.active = value;
                                            }
                                            else{
                                              showDialog(
                                                context: context,
                                                builder: (context) => gradeDialog()  ,
                                              );
                                            }

                                          });
                                        },
                                      ),
                                      SizedBox(
                                          width:10
                                      ),
                                      Text('Active?')

                                    ],
                                  )),
                                  SizedBox(width:150,height:40,child:
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.red),
                                          padding:MaterialStateProperty.all(const EdgeInsets.all(20)),
                                          textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14, color: Colors.white))),
                                      onPressed:  onSave,
                                      child: const Text('Save Changes')))
                                ],
                              )
                            ],
                          )

                          )
                        ],
                      )
                  ),
                  TitledContainer(
                      titleText: 'Allowed Countries',
                      idden: 10,
                      child:  Container(
                        height: 800,
                        alignment: Alignment.topCenter,
                        child: CountryTreeView(),
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
