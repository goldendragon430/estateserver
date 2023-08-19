import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'dart:html';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:math';
import 'package:dio/dio.dart';
bool isEmailValid(String email) {
  // Regular expression pattern for email validation
  final pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
  final regex = RegExp(pattern);
  return regex.hasMatch(email);
}
void showSuccess(String str) {
  AlertController.show("Success", str, TypeAlert.success);
}
void showWarning(String str) {
  AlertController.show("Warning", str, TypeAlert.warning);
}
void showError(String str) {
  AlertController.show("Error", str, TypeAlert.error);
}

void saveStorage(String key, String value){
  final Storage _localStorage = window.localStorage;
  _localStorage[key] = value;
}

String? getStorage(String key){
  final Storage _localStorage = window.localStorage;
  return _localStorage[key];
}

String generateID() {
  int length = 10;
  final random = Random();
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  String result = '';

  for (int i = 0; i < length; i++) {
    result += chars[random.nextInt(chars.length)];
  }
  return result;
}

Future<String> uploadFile(Uint8List? imageData) async{
  final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.png';
  final firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref().child(fileName);

  final uploadTask = firebaseStorageRef.putData(imageData!);
  await uploadTask.whenComplete(() => null);
  final downloadUrl = await firebaseStorageRef.getDownloadURL();
  return downloadUrl;
}

Future<bool> sendEmail(to,title,body) async{
  final dio = Dio();
  final response = await dio.post('http://154.38.161.183:5000/mail/active', data : {
    'to'   : to ,
    'title' : title,
    'body'  : body
  });
  if(response.data['result'] == 'success'){
    return true;
  }else{
   return false;
  }
}