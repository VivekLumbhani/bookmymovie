import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class bookings extends StatefulWidget {
  final String? movieename;
  final String? date;
  final String? timeof;
  final String? oriname;
  const bookings({required this.movieename, required this.date, this.timeof, this.oriname});

  @override
  State<bookings> createState() => _bookings();
}

class _bookings extends State<bookings> {
  double scale = 1.0;
  String? docid;
  String? date;
  String? timeof;
  String? oriname;
  List<bool> selectedSeats = List.generate(100, (index) => false);
  List<int> selectedSeatIndices = [];
  List<int> reservedSeats = []; // List to store reserved seat indices

  var username = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    date = widget.date;
    timeof = widget.timeof;
    oriname=widget.oriname;
    final username = FirebaseAuth.instance.currentUser;
    final docid = widget.movieename;
    final idtochek = docid! + timeof!+date!;



    print("docid is $docid and date is $date $username $timeof $idtochek ");

    // Check if the document with movieId equal to idtochek exists
    FirebaseFirestore.instance
        .collection('bookings')
        .where('movieId', isEqualTo: idtochek)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Document with movieId equal to idtochek exists
        // Parse the array and update reservedSeats list
        List<int> reserved = [];
        for (var doc in querySnapshot.docs) {
          String seats = doc['selectedSeats'];
          List<int> selectedSeats = jsonDecode(seats).cast<int>();

          for (var seat in selectedSeats) {
            reserved.add(int.parse(seat.toString()));
          }
        }
        setState(() {
          reservedSeats = reserved;
          print("reserved seats are $reservedSeats");
        });
      }
    });
  }

  void toggleSeatSelection(int index) {
    setState(() {
      // Check if the seat is reserved
      if (reservedSeats.contains(index)) {
        return; // Don't allow selection for reserved seats
      }

      selectedSeats[index] = !selectedSeats[index];
      if (selectedSeats[index]) {
        selectedSeatIndices.add(index);
      } else {
        selectedSeatIndices.remove(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Bookings'),
          centerTitle: true,
        ),
        body: Center(
          child: GestureDetector(
            onScaleUpdate: (details) {
              setState(() {
                scale = details.scale.clamp(0.5, 2.0);
              });
            },
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 400,
                height: 600, // Set a fixed height for the container
                transformAlignment: Alignment.center,
                child: Column(
                  children: [

                    ElevatedButton(
                      onPressed: selectedSeatIndices.isEmpty
                          ? null
                          : () async {
                        final username = FirebaseAuth.instance.currentUser;
                        final docid = widget.movieename;
                        final date = widget.date;

                        final id = docid! + timeof!+date!;
                        final selectedSeatsString =
                            '[' + selectedSeatIndices.map((index) => index.toString()).join(',') + ']';

                        // Check if a booking with the same ID already exists
                        final bookingSnapshot = await FirebaseFirestore.instance
                            .collection('bookings')
                            .where('movieId', isEqualTo: id)
                            .get();

                        if (bookingSnapshot.docs.isNotEmpty) {
                          // Booking with the same ID exists, append new seats to the existing array
                          final existingBookingDoc = bookingSnapshot.docs.first;
                          final existingBookingId = existingBookingDoc.id;
                          final existingSeats = existingBookingDoc['selectedSeats'] as String;
                          final updatedSeatsString = existingSeats.replaceFirst(']', ',') + selectedSeatsString.substring(1);

                          // Update the existing booking document with the new seats data
                          await FirebaseFirestore.instance.collection('bookings').doc(existingBookingId).update({'selectedSeats': updatedSeatsString});

                          final personalbook = {
                            'username': username!.email.toString(),
                            'movieId': id,
                            'date': date,
                            'movieName':oriname,
                            'timeof': timeof,
                            'selectedSeats': selectedSeatsString,
                          };
                          await FirebaseFirestore.instance.collection('personalbooking').add(personalbook);

                          // Notify the user that the booking was updated
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Booking Updated'),
                                content: Text('Your booking has been updated with the new seat information.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // Booking with the same ID doesn't exist, so add a new booking
                          final bookingData = {
                            'movieId': id,
                            'selectedSeats': selectedSeatsString,
                          };
                          await FirebaseFirestore.instance.collection('bookings').add(bookingData);

                          final personalbook = {
                            'username': username!.email.toString(),
                            'movieId': id,
                            'date': date,
                            'movieName':oriname,
                            'timeof': timeof,
                            'selectedSeats': selectedSeatsString,
                          };
                          await FirebaseFirestore.instance.collection('personalbooking').add(personalbook);

                          // Notify the user that the booking was successful
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Booking Successful'),
                                content: Text('Your booking has been successfully added.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text('Print Selected Seats'),
                    ),

                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                        ),
                        itemBuilder: (context, index) {
                          final isReserved = reservedSeats.contains(index);
                          final isSelected = selectedSeats[index];
                          return GestureDetector(
                            onTap: () {
                              toggleSeatSelection(index);
                            },
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                color: isReserved
                                    ? Colors.red // Reserved seats are in red
                                    : isSelected
                                    ? Colors.blue // Selected seats are in blue
                                    : Colors.green, // Available seats are in green
                              ),
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
