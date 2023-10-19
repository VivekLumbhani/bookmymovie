import 'dart:convert';
import 'package:bookmymovie/pages/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class booked extends StatefulWidget {
  const booked({Key? key}) : super(key: key);

  @override
  State<booked> createState() => _BookedScreenState();
}

class _BookedScreenState extends State<booked> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bookings"), centerTitle: true),
      drawer: navbar(email: _user!.email.toString()),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('personalbooking')
            .where('username', isEqualTo: _user!.email.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("You haven't made any bookings yet."),
            );
          }

          List<Widget> bookingCards = snapshot.data!.docs.map((document) {
            final data = document.data() as Map<String, dynamic>;
            final movieId = data['movieId'];
            final date = data['date'];
            final movieName=data['movieName'];
            final timeOf = data['timeof'];
            final selectedSeats = data['selectedSeats'];

            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text('Movie: $movieName'),
                subtitle: Text('Date: $date, Time: $timeOf \n Seats: $selectedSeats'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text('Are you sure you want to cancel your ticket fully?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  QuerySnapshot<Map<String, dynamic>> queryUpdate =
                                  await _firestore
                                      .collection('bookings')
                                      .where('movieId', isEqualTo: movieId)
                                      .get();

                                  for (QueryDocumentSnapshot documentSnapshot
                                  in queryUpdate.docs) {
                                    var existingDoc = documentSnapshot.data() as Map<String, dynamic>?;
                                    if (existingDoc != null) {
                                      var seatsString = existingDoc['selectedSeats'] as String;
                                      var seatsList = jsonDecode(seatsString) as List<dynamic>;
                                      var userSeats = jsonDecode(selectedSeats) as List<dynamic>;

                                      seatsList.removeWhere((seat) => userSeats.contains(seat));

                                      await documentSnapshot.reference.update({'selectedSeats': jsonEncode(seatsList)});
                                    } else {
                                      print("id not found $movieId");
                                    }
                                  }

                                  QuerySnapshot<Map<String, dynamic>> querySnapshot =
                                  await _firestore
                                      .collection('personalbooking')
                                      .where('username', isEqualTo: _user!.email.toString())
                                      .where('movieId', isEqualTo: movieId)
                                      .get();

                                  for (QueryDocumentSnapshot documentSnapshot
                                  in querySnapshot.docs) {
                                    print("id found to be deleted $movieId");
                                    await documentSnapshot.reference.delete();
                                  }
                                  Navigator.of(dialogContext).pop();
                                } catch (e) {
                                  print("error is $e");
                                }
                              },
                              child: Text('Yes'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print("no clicked $movieId");
                                Navigator.of(dialogContext).pop();
                              },
                              child: Text('No'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Cancel my ticket fully'),
                ),
              ),
            );
          }).toList();

          return ListView(
            children: bookingCards,
          );
        },
      ),
    );
  }
}
