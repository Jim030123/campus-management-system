import 'package:campus_management_system/components/my_appbar.dart';
import 'package:flutter/material.dart';

class ResidentInformationPage extends StatefulWidget {
  ResidentInformationPage({super.key});

  @override
  State<ResidentInformationPage> createState() =>
      _ResidentInformationPageState();
}

class _ResidentInformationPageState extends State<ResidentInformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: MyAppBar(),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(25),
              child: Column(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Block A - D",
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider(
                  color: Colors.black,
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
                                  child: Text("Click here to get more detailed",
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
                                  child: Text("Click here to get more detailed",
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
                  height: 25,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Block E (IEB)",
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'lib/images/TwinSharing.jpg',
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
                                '-	Location: Block E \n-	RM 2 250 (Long Trimester)\n- RM 1 500 (Short Trimester) ',
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/room_information_E');
                                  },
                                  child: Text("Click here to get more detailed",
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
                          'lib/images/TrioSharing.jpg',
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
                                'Trio Sharing Room \n(Air Conditioned)',
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
                                        context, '/room_information_trio_E');
                                  },
                                  child: Text("Click here to get more detailed",
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
              ])),
        ));
  }
}
