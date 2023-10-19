import 'dart:convert';
import 'package:bookmymovie/pages/booking.dart';
import 'package:bookmymovie/pages/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class chooseshow extends StatefulWidget {
  final String? movieename;

  const chooseshow({required this.movieename});

  @override
  State<chooseshow> createState() => _chooseshowState();
}

class _chooseshowState extends State<chooseshow> {
  var user = FirebaseAuth.instance.currentUser;
  late TabController controller;
  String? docid;
  String? date;

  @override
  void initState() {
    super.initState();
    docid = widget.movieename;
    fetchData();
  }

  var movieTitle = "";
  var datesof = "";
  var expdate = "";
  var priceofseat="";

  void changeAppBarTitle() {
    String appBarTitle = "Initial Title";

    setState(() {
      appBarTitle  = "New Title";
    });
  }
  List<String> generateDateList(String startDate, String endDate) {
    List<String> dateList = [];
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);
    DateTime currentDate = DateTime.now();


      for (var i = currentDate; i.isBefore(end); i = i.add(Duration(days: 1))) {
        if(currentDate.isBefore(start)){
         }else{
            String formattedDate =
                '${i.day}/${i.month} \n ${_getWeekdayName(i.weekday)}';
            dateList.add(formattedDate);
            print("start is $start and current is $currentDate");
        }
      }
    print('datelist that is $dateList');
    return dateList;
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Sun';
      case 2:
        return 'Mon';
      case 3:
        return 'Tue';
      case 4:
        return 'Wed';
      case 5:
        return 'Thu';
      case 6:
        return 'Fri';
      case 7:
        return 'Sat';
      default:
        return '';
    }
  }

  List<Map<String, dynamic>> theatersList = [];

  Future<void> fetchData() async {
    try {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('buscollections').doc(docid).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          movieTitle = data['movieName'] ?? '';
          datesof = data['date'] ?? '';
          expdate = data['expiryDate'] ?? '';
          dateList = generateDateList(datesof, expdate);
          priceofseat = data['price'] ?? '';

          final theatersData = jsonDecode(data['theaters']);
          if (theatersData is List) {
            theatersList = theatersData.cast<Map<String, dynamic>>();
          }

          print('$movieTitle and ${widget.movieename.toString()} and $datesof and $expdate)');
          setState(() {});
        }
      } else {
        print('Document does not exist');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  List<String> dateList = [];

  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navbar(email: user!.email.toString()),
      appBar: AppBar(
        title: Text('Choose Date'),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(5),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: dateList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Visibility(
                              visible: current == index,
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            );
                            setState(() {
                              current = index;
                            });
                          },
                          child: AnimatedContainer(
                            margin: EdgeInsets.all(1),
                            width: 80,
                            height: 45,
                            decoration: BoxDecoration(
                              color: current == index
                                  ? Colors.white70
                                  : Colors.white54,
                              borderRadius: current == index
                                  ? BorderRadius.circular(15)
                                  : BorderRadius.circular(10),
                              border: current == index
                                  ? Border.all(
                                  color: Colors.deepPurpleAccent, width: 2)
                                  : null,
                            ),
                            duration: Duration(milliseconds: 300),
                            child: Center(
                              child: Text(
                                dateList[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: current == index
                                      ? Colors.deepPurple
                                      : Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Column(
                children: theatersList.map((theater) {
                  final cinemaName = theater['cinemaName'];
                  final dynamicTime = theater['dynamicTime'];

                  List<Widget> timeSlots = [];

                  if (dynamicTime != null) {
                    int hour = dynamicTime['hour'];
                    int minute = dynamicTime['minute'];

                    String time = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

                    timeSlots.add(
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => bookings(movieename:docid, date: dateList[current],timeof: time, oriname:movieTitle,priceofseat:priceofseat,cinemaname:cinemaName)),
                          );
                        },
                        child: Container(
                          width: 80,
                          height: 50.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              time,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return Card(
                    margin: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(
                            '$cinemaName',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            children: timeSlots,
                            spacing: 8.0,
                            runSpacing: 8.0,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
