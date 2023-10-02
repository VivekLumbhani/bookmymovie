import 'package:bookmymovie/pages/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class booked extends StatefulWidget {
  const booked({Key? key}) : super(key: key);

  @override
  State<booked> createState() => _bookedState();
}

class _bookedState extends State<booked> {
  var emailof = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bookings"), centerTitle: true),
      drawer: navbar(email: emailof!.email.toString()),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('personalbooking')
            .where('username', isEqualTo: emailof!.email.toString())
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
            final movieId = data['movieName'];
            final date = data['date'];
            final timeof = data['timeof'];
            final selectedSeatsString = data['selectedSeats'];


            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text('Movie: $movieId'),
                subtitle: Text('Date: $date, Time: $timeof'),
                trailing: ElevatedButton.icon(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  label: Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    // Add the code here to delete the booking when the button is pressed
                  },
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
