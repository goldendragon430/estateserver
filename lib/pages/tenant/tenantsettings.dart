import 'package:flutter/material.dart';
import 'package:assetmamanger/pages/titledcontainer.dart';

class TenantSettings extends StatefulWidget {
  TenantSettings({super.key});
  @override
  _TenantSettings createState() => _TenantSettings();
}
class  _TenantSettings extends State<TenantSettings> {
  int hoveredIndex = -1;
  bool account_active = false;
  bool unlimited_folder = false;
  bool unlimited_group = false;
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left:30),
      child: Column(
        children: [
         Expanded(child: TitledContainer(
             titleText: 'TENANT Details',
             idden: 10,
             child:
             Column(
               children: [
                 Row(
                   children: [
                     Image.asset('assets/images/home.jpg',width: 300,height: 200),
                     Expanded(child: Column(
                       children: [
                         Row(
                           children: [
                             SizedBox(
                                 height: 35,
                                 width: 350,
                                 child:
                                 Container(
                                     margin:EdgeInsets.only(left:20),
                                     child: TextField(
                                         decoration: InputDecoration(
                                           hintText: 'Tenant Name',
                                         )
                                     )
                                 )

                             ),
                             SizedBox(
                               height: 35,
                               width: 350,
                               child:  Container(
                                   margin:EdgeInsets.only(left:20),
                                   child: TextField(
                                       decoration: InputDecoration(
                                         hintText: 'POSTAL ADDRESS',
                                       )
                                   )
                               ),
                             )
                           ],
                         ),
                         SizedBox(height: 5),
                         Row(
                           children: [
                             SizedBox(
                                 height: 35,
                                 width: 350,
                                 child:
                                 Container(
                                     margin:EdgeInsets.only(left:20),
                                     child: TextField(
                                         decoration: InputDecoration(
                                           hintText: 'Tenant Email',
                                         )
                                     )
                                 )

                             ),
                             SizedBox(
                               height: 35,
                               width: 350,
                               child:  Container(
                                   margin:EdgeInsets.only(left:20),
                                   child: TextField(
                                       decoration: InputDecoration(
                                         hintText: 'Folder Name',
                                       )
                                   )
                               ),
                             )
                           ],
                         ),
                         SizedBox(height: 5),
                         Row(
                           children: [
                             SizedBox(
                                 height: 35,
                                 width: 350,
                                 child:
                                 Container(
                                     margin:EdgeInsets.only(left:20),
                                     child: TextField(
                                         decoration: InputDecoration(
                                           hintText: 'Tenant Landline',
                                         )
                                     )
                                 )

                             ),
                             SizedBox(
                               height: 35,
                               width: 350,
                               child:  Container(
                                   margin:EdgeInsets.only(left:20),
                                   child: TextField(
                                       decoration: InputDecoration(
                                         hintText: 'Group Name',
                                       )
                                   )
                               ),
                             )
                           ],
                         ),
                         SizedBox(height: 5),
                         Row(
                           children: [
                             Column(
                               children: [
                                 SizedBox(
                                     height: 35,
                                     width: 350,
                                     child:
                                     Container(
                                         margin:EdgeInsets.only(left:20),
                                         child: TextField(
                                             decoration: InputDecoration(
                                               hintText: 'Tenant Mobile',
                                             )
                                         )
                                     )

                                 ),
                                 SizedBox(
                                   height: 35,
                                   width: 350,
                                   child:  Container(
                                       margin:EdgeInsets.only(left:20),
                                       child: TextField(
                                           decoration: InputDecoration(
                                             hintText: 'Faxline',
                                           )
                                       )
                                   ),
                                 )
                               ],
                             ),
                             SizedBox(
                                 height: 70,
                                 width: 350,
                                 child:
                                 Container(
                                     margin:EdgeInsets.only(left:20,top:5),
                                     child: TextField(
                                         maxLines: 5,
                                         decoration: InputDecoration(
                                           hintText: 'Office location',
                                           border: OutlineInputBorder(),
                                         )
                                     )
                                 )

                             )
                           ],
                         )
                       ],
                     )

                     )
                   ],
                 ),
                 SizedBox(height: 50),
                 Row(
                   children: [
                     SizedBox(width:300),
                     TitledContainer(titleText: 'Account Status and Settings',
                         child: Row(
                           children: [
                             Row(
                               children: [
                                 SizedBox(
                                     width:15
                                 ),
                                 Checkbox(
                                   value: this.account_active,
                                   onChanged: (bool? value) {
                                     setState(() {
                                       this.account_active = value!;
                                     });
                                   },
                                 ),
                                 SizedBox(
                                     width:10
                                 ),
                                 Text('Account Active')

                               ],
                             ),
                             SizedBox(width: 15),
                             Row(children: [
                               Text('Renewal Date'),
                               SizedBox(
                                   height: 35,
                                   width: 150,
                                   child:
                                   Container(
                                       margin:EdgeInsets.only(left:20,bottom:5),
                                       child: TextField(
                                           decoration: InputDecoration(
                                             hintText: '',
                                           )
                                       )
                                   )

                               )
                             ],),
                             Row(
                               children: [
                                 SizedBox(
                                     width:15
                                 ),
                                 Checkbox(
                                   value: this.unlimited_folder,
                                   onChanged: (bool? value) {
                                     setState(() {
                                       this.unlimited_folder = value!;
                                     });
                                   },
                                 ),
                                 SizedBox(
                                     width:10
                                 ),
                                 Text('Unlimited Folders')

                               ],

                             ),
                             Row(
                               children: [
                                 SizedBox(
                                     width:15
                                 ),
                                 Checkbox(
                                   value: this.unlimited_group,
                                   onChanged: (bool? value) {
                                     setState(() {
                                       this.unlimited_group = value!;
                                     });
                                   },
                                 ),
                                 SizedBox(
                                     width:10
                                 ),
                                 Text('Unlimited Groups')

                               ],

                             ),

                           ],
                         ) )
                   ],
                 )
               ],
             )

         ))
        ],
      ),
    );
  }
}
