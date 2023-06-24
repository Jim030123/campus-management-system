import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_facility_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FacilityInformationPage extends StatelessWidget {
  const FacilityInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'lib/images/TripleSharing_old.png',
                            width: 300,
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            width: 300,
                            height: 200,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Text(
                                  'Twin Sharing Room \n(Non Air Conditioned)',
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '-	Block A & C \n-	RM 990 (Long Trimester)\n- RM 660 (Short Trimester)',
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/room_information_A_C');
                                    },
                                    child:
                                        Text("Click here to get more detailed",
                                            style: TextStyle(
                                              color: Colors.blue,
                                            )),
                                  ),
                                  alignment: Alignment.bottomRight,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),

                      // 2
                      Container(
                          child: Column(
                        children: [
                          Image.asset(
                            'lib/images/Twin_Sharing_old.png',
                            width: 300,
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            width: 300,
                            height: 200,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Text(
                                  'Twin Sharing Room \n(Air Conditioned)',
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '-	Block B & D \n-	RM 1 260 (Long Trimester)\n- RM 840 (Short Trimester)',
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/room_information_B_D');
                                    },
                                    child:
                                        Text("Click here to get more detailed",
                                            style: TextStyle(
                                              color: Colors.blue,
                                            )),
                                  ),
                                  alignment: Alignment.bottomRight,
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'lib/images/TripleSharing_old.png',
                            width: 300,
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            width: 300,
                            height: 200,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Text(
                                  'Twin Sharing Room \n(Non Air Conditioned)',
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '-	Block A & C \n-	RM 990 (Long Trimester)\n- RM 660 (Short Trimester)',
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/room_information_A_C');
                                    },
                                    child:
                                        Text("Click here to get more detailed",
                                            style: TextStyle(
                                              color: Colors.blue,
                                            )),
                                  ),
                                  alignment: Alignment.bottomRight,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),

                      // 2
                      Container(
                          child: Column(
                        children: [
                          Image.asset(
                            'lib/images/Twin_Sharing_old.png',
                            width: 300,
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            width: 300,
                            height: 200,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Text(
                                  'Twin Sharing Room \n(Air Conditioned)',
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '-	Block B & D \n-	RM 1 260 (Long Trimester)\n- RM 840 (Short Trimester)',
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/room_information_B_D');
                                    },
                                    child:
                                        Text("Click here to get more detailed",
                                            style: TextStyle(
                                              color: Colors.blue,
                                            )),
                                  ),
                                  alignment: Alignment.bottomRight,
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
