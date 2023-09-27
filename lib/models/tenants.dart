import 'folders.dart';
class Tenant {
   // String? id ;
   String? name  = '';
   String? email = '';
   String? password = '';
   String? address = '' ;
   String? phone = '' ;
   String? fax = '' ;
   String? landline = '' ;
   String? office = '' ;
   DateTime? renewal_date = DateTime(2023,1,1) ;
   bool? active  = false;
   String cut_off_level = '1';
   String country = '';
   bool show_asset_types = false;
   String? user_id = '' ;
   String? logo = '' ;
   DateTime? created_date = DateTime(2023,1,1) ;
   String firstname = '';
   String lastname = '';
   bool hasOffice = false;

   Map<String,dynamic> toJson(){

     return {
       // 'id' : id,
       'name' : name,
       'email' : email,
       'password' : password,
       'address' : address,
       'phone' : phone,
       'fax' : fax,
       'landline' : landline,
       'office' : office,
       'renewal_date' : renewal_date.toString(),
       'created_date' : created_date.toString(),
       'active' : active,
       'user_id' : user_id,
       'logo' : logo,
       'cut_off_level' : cut_off_level,
       'country' : country,
       'show_asset_type' : show_asset_types,
       'firstname' : firstname,
       'lastname' : lastname,
       'hasOffice' : hasOffice
     };
   }

   void fromJson(Map<String,dynamic>? data) {
     // id = data?['id'];
     name = data?['name'];
     email = data?['email'];
     address = data?['address'];
     phone = data?['phone'];
     fax = data?['fax'];
     landline = data?['landline'];
     office = data?['office'];
     renewal_date = DateTime.parse(data?['renewal_date']) ;
     if(data?['created_date'] != null)
        created_date = DateTime.parse(data?['created_date']);
     else
       created_date = DateTime(2023,1,1);
     if(data?['password'] == null){
       password = '';
     }
     else{
       password = data?['password'];
     }
     if(data?['show_asset_type'] == null){
       show_asset_types = false;
     }
     else{
       show_asset_types = data?['show_asset_type'];
     }
     if(data?['cut_off_level'] == null){
       cut_off_level = '1';
     }
     else{
       cut_off_level = data?['cut_off_level'];
     }
     if(data?['country'] == null){
       country = '';
     }
     else{
       country = data?['country'];
     }
     if(data?['firstname'] == null){
       firstname = '';
     }
     else{
       firstname = data?['firstname'];
     }
     if(data?['lastname'] == null){
       lastname = '';
     }
     else{
       lastname = data?['lastname'];
     }
     if(data?['hasOffice'] == null){
       hasOffice = false;
     }
     else{
       hasOffice = data?['hasOffice'];
     }
     active = data?['active'];

     user_id = data?['user_id'];
     logo = data?['logo'];

   }
  Tenant({
     // this.id,
     this.name,
     this.email,
     this.active,
     this.address,
     this.phone,
     this.fax,
     this.landline,
     this.office,
     this.renewal_date,
     this.user_id,
     this.logo,
     this.created_date,
     this.password
  });

}