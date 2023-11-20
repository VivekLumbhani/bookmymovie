import 'dart:convert';
import 'package:bookmymovie/pages/serv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookmymovie/pages/navbar.dart';

class admin extends StatefulWidget {
  admin({Key? key}) : super(key: key);

  @override
  _admin createState() => _admin();
}

class _admin extends State<admin> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController movieName = TextEditingController();
  final TextEditingController movieprice = TextEditingController();
  final TextEditingController seatscontrol = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController imgname = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  DateTime _selectedExpiry = DateTime.now();

  List<Map<String, dynamic>> theaters = [];
  var imgpath;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        dateController.text = _dateFormat.format(_selectedDate);
      });
  }

  Future<void> _selectExpiry(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedExpiry,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedExpiry)
      setState(() {
        _selectedExpiry = picked;
        expiryDateController.text = _dateFormat.format(_selectedExpiry);
      });
  }

  Future<void> _selectDynamicTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        theaters[index]['dynamicTime'] = picked;
      });
    }
  }

  void addTheatre() {
    setState(() {
      theaters.add({
        'cinemaName': '',
        'dynamicTime': null,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    String formattedExpiryDate = DateFormat('yyyy-MM-dd').format(_selectedExpiry);
    var user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: navbar(email: user!.email.toString()),
      appBar: AppBar(title: Text('Admin'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter Movie Name*'), // Add an asterisk (*) to indicate required
                  controller: movieName,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter a movie name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selected Date*: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select Date'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Change the button color as needed
                        onPrimary: Colors.white, // Change the text color as needed
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pick Poster for Movie*',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final source = ImageSource.gallery;
                        final pickedImage = await ImagePicker().pickImage(source: source);

                        if (pickedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No image selected')),
                          );
                        } else {
                          final path = pickedImage.path;
                          final fileName = pickedImage.name;
                          imgpath = fileName;
                          final serve = serv();
                          await serve.uploadfile(path, fileName);

                          print('Path is $path and filename is $fileName');
                        }
                      },
                      child: Text('Pick from Gallery'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Expiry Date*: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      formattedExpiryDate,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => _selectExpiry(context),
                      child: Text('When to Expire'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Change the button color as needed
                        onPrimary: Colors.white, // Change the text color as needed
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: addTheatre,
                  child: Text('Add A Theater'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Change the button color as needed
                    onPrimary: Colors.white, // Change the text color as needed
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: theaters.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Enter Cinema Name*'), // Add an asterisk (*) to indicate required
                          onChanged: (value) {
                            theaters[index]['cinemaName'] = value;
                            print("array is $theaters");
                          },
                        ),
                        ElevatedButton(
                          onPressed: () => _selectDynamicTime(context, index),
                          child: Text('Pick Dynamic Time'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue, // Change the button color as needed
                            onPrimary: Colors.white, // Change the text color as needed
                          ),
                        ),
                        Divider(color: Colors.blue),
                      ],
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter Seats*'), // Add an asterisk (*) to indicate required
                  controller: seatscontrol,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter the number of seats';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter Price*'), // Add an asterisk (*) to indicate required
                  controller: movieprice,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter the movie price';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                      String movieNameValue = movieName.text;
                      String moviePriceValue = movieprice.text;
                      int seats = int.tryParse(seatscontrol.text) ?? 0;
                      String dateValue = dateController.text;
                      String expiryDateValue = expiryDateController.text;

                      List<Map<String, dynamic>> theatersData = [];
                      theaters.forEach((theater) {
                        theatersData.add({
                          'cinemaName': theater['cinemaName'],
                          'dynamicTime': {
                            'hour': theater['dynamicTime'] != null ? theater['dynamicTime'].hour : 0,
                            'minute': theater['dynamicTime'] != null ? theater['dynamicTime'].minute : 0,
                          },
                        });
                      });

                      String theatersDataJson = jsonEncode(theatersData);

                      try {
                        await FirebaseFirestore.instance.collection('buscollections').add({
                          'movieName': movieNameValue,
                          'date': dateValue,
                          'expiryDate': expiryDateValue,
                          'price': moviePriceValue,
                          'seats': seats,
                          'imgname': imgpath,
                          'theaters': theatersDataJson,
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data inserted successfully')),
                        );
                      } catch (e) {
                        print('Error inserting data: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error inserting data')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Validation failed')),
                      );
                    }
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Change the button color as needed
                    onPrimary: Colors.white, // Change the text color as needed
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
