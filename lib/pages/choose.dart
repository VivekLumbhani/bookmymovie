import 'package:bookmymovie/pages/booking.dart';
import 'package:bookmymovie/pages/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class chooseshow extends StatefulWidget {
  const chooseshow({Key? key}) : super(key: key);

  @override
  State<chooseshow> createState() => _chooseshowState();
}

class _chooseshowState extends State<chooseshow> {
  var user=FirebaseAuth.instance.currentUser;
  late TabController controller;
  final List<String> dateList = [
    '01 January',
    '05 February',
    '10 March',
    '15 April',
    '20 May',
    '25 June',
    '03 July',
    '08 August',
    
  ];
  List<IconData> icons = [
    Icons.home,
    Icons.explore,
    Icons.search,
    Icons.feed,
    Icons.post_add,
    Icons.local_activity,
    Icons.settings,
    Icons.person
  ];
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navbar(email: user!.email.toString(),),
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
                              visible:current==index,

                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.deepPurple
                                ),

                            ),);
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
                              child: Text(dateList[index],style: TextStyle(fontWeight: FontWeight.w500,color: current==index?Colors.deepPurple:Colors.black),),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

              ),
              Container(
                child:
                Column(
                  children: [
                    Center(
                      child:
                      Card(
                        margin: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const ListTile(
                              leading: Icon(Icons.alarm),
                              title: Text('Theater Name ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            ),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final numberOfSlots = 14;
                                final slotsPerRow = 5;
                                final slotWidth = constraints.maxWidth / slotsPerRow;

                                final timeSlots = List.generate(numberOfSlots, (index) {
                                  final time = '${index + 1}:00';
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => bookings()),);
                                    },
                                    child: Container(
                                      width: slotWidth,
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
                                  );
                                });

                                return Wrap(
                                  children: timeSlots,
                                  spacing: 8.0, // Adjust the spacing as needed
                                  runSpacing: 8.0, // Adjust the runSpacing as needed
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(),
                    Container(margin: EdgeInsets.only(top: 30),
                      width: double.infinity,
                      height: 500,
                      color: Colors.deepPurple,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(icons[current],size: 200,color: Colors.black,),SizedBox(height: 10,),Text(dateList[current],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 30,color: Colors.black),)],
                      ),
                    )
                  ],

                ),

              ),
            ],
          ),
        ),
      ),

    );
  }
}
