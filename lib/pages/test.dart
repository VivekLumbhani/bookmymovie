import 'package:bookmymovie/pages/navbar.dart';
import 'package:bookmymovie/pages/serv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'serv.dart';

class home extends StatelessWidget {
  home({Key? key}) : super(key: key);
  final username=FirebaseAuth.instance.currentUser;
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  final serv storing=serv();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          drawer: navbar(email: username!.email.toString(),),
          appBar: AppBar(centerTitle: true,title: Text('Home' ,style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,actions: [],),
          body:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text('text'),
                    ],
                  ),


                  FutureBuilder<firebase_storage.ListResult>(
                    future: serv().ListFile(),
                    builder: (BuildContext context, AsyncSnapshot<firebase_storage.ListResult> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                        return Text('No files available');
                      } else {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.items.length,
                                itemBuilder: (BuildContext context, int index) {

                                },
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: snapshot.data!.items.map((item) {
                                  return FutureBuilder<String>(
                                    future: serv().downloadurl(item.name),
                                    builder: (BuildContext context, AsyncSnapshot<String> imageSnapshot) {
                                      if (imageSnapshot.connectionState == ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (imageSnapshot.hasError) {
                                        return Text('Error: ${imageSnapshot.error}');
                                      } else if (!imageSnapshot.hasData) {
                                        return Text('No image data available');
                                      } else {
                                        return Container(
                                          margin: EdgeInsets.all(15),
                                          height: 320,
                                          width: 200,
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.blue,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 250,
                                                child: Image.network(
                                                  imageSnapshot.data!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Text(
                                                'Movie Name',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
                            ),

                          ],
                        );
                      }
                    },
                  ),


                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text('Vertical'),
                    ],
                  ),



                  Container(
                    height: 500,
                    child: SingleChildScrollView(child: Column(children: [
                      Container(margin: EdgeInsets.all(15), height: 200, width: 300, padding: EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue,), child: Center(child: Text('tesxt'),),),
                      Container(margin: EdgeInsets.all(15), height: 200, width: 300, padding: EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue,), child: Center(child: Text('tesxt'),),),
                      Container(margin: EdgeInsets.all(15), height: 200, width: 300, padding: EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue,), child: Center(child: Text('tesxt'),),),
                      Container(margin: EdgeInsets.all(15), height: 200, width: 300, padding: EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue,), child: Center(child: Text('tesxt'),),),
                      Container(margin: EdgeInsets.all(15), height: 200, width: 300, padding: EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue,), child: Center(child: Text('tesxt'),),),
                      Container(margin: EdgeInsets.all(15), height: 200, width: 300, padding: EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue,), child: Center(child: Text('tesxt'),),),
                      Container(margin: EdgeInsets.all(15), height: 200, width: 300, padding: EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue,), child: Center(child: Text('tesxt'),),),
                      Container(margin: EdgeInsets.all(15), height: 200, width: 300, padding: EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue,), child: Center(child: Text('tesxt'),),),
                      Container(margin: EdgeInsets.all(15), height: 200, width: 300, padding: EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue,), child: Center(child: Text('tesxt'),),),
                      Container(margin: EdgeInsets.all(15), height: 200, width: 300, padding: EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue,), child: Center(child: Text('tesxt'),),),

                    ],),),
                  ),

                  SizedBox(height: 20,),

                ],
              ),
            ),
          )
      ),
    );
  }
}