import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
class serv{
  final firebase_storage.FirebaseStorage storage=firebase_storage.FirebaseStorage.instance;
  Future<void> uploadfile(String filepath, String filename)async{
    File file=File(filepath);
    try{
      await storage.ref('/movies/$filename').putFile(file);
    }on firebase_core.FirebaseException catch(e){
      print(e);
    }
  }

  Future<firebase_storage.ListResult> listFiles() async{

      firebase_storage.ListResult res = await storage.ref('movies').listAll();
      res.items.forEach((firebase_storage.Reference ref){
        print("found ref are $ref");
      });
      return res;

  }

  Future<firebase_storage.ListResult> ListFile() async{

    firebase_storage.ListResult res = await storage.ref('movies').listAll();
    res.items.forEach((firebase_storage.Reference ref){
      print("found ref are $ref");
    });
    return res;
  }
  Future<String> downloadurl(String imagename) async {
    try {
      String download = await storage.ref('movies/$imagename').getDownloadURL();
      return download;
    } catch (error) {
      // Handle any potential errors here
      print('Error fetching download URL: $error');
      return 'heelo';
    }
  }

}
