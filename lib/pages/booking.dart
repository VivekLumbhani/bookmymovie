import 'package:bookmymovie/pages/choose.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class bookings extends StatefulWidget {
  const bookings({Key? key}) : super(key: key);

  @override
  State<bookings> createState() => _bookings();
}

class _bookings extends State<bookings> {
  var user = FirebaseAuth.instance.currentUser;
  double scale = 1.0;
  List<bool> selectedSeats = List.generate(100, (index) => false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        appBar: AppBar(
          toolbarHeight: 60, // Set the height of the AppBar
          leading: Align(
            alignment: Alignment.centerLeft, // Adjust the alignment as needed
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => chooseshow()),
                );
              }, child: Text('Back'),
              
            ),
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
                width: 400, // Adjust the container size
                height: 600, // Adjust the container size
                transformAlignment: Alignment.center,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10, // Number of seats in a row
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSeats[index] = !selectedSeats[index];
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5.0), // Adjust spacing between seats
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
                          gradient: LinearGradient(
                            colors: [
                              selectedSeats[index]
                                  ? Colors.blue.withOpacity(0.8)
                                  : Colors.green.withOpacity(0.8),
                              selectedSeats[index]
                                  ? Colors.blue.withOpacity(0.9)
                                  : Colors.green.withOpacity(0.9),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
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
                  itemCount: 100, // Total number of seats
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
