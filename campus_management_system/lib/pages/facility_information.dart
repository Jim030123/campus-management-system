import 'package:campus_management_system/components/my_appbar.dart';
import 'package:flutter/material.dart';

class FacilityInformationPage extends StatefulWidget {
  FacilityInformationPage({super.key});

  @override
  State<FacilityInformationPage> createState() =>
      _FacilityInformationPageState();
}

class _FacilityInformationPageState extends State<FacilityInformationPage> {
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
                    "Outdoor Facility",
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                Container(
                  child: Wrap(
                    runSpacing: 25,
                    spacing: 25,
                    children: [
                      Image.asset(
                        'lib/images/basketball.jpg',
                        width: 300,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        width: 300,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Text(
                              'Basketball Court',
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Location: Sport field \n Opening Hour : 8AM - 6PM\n Number of Court : 2',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/check_facility_available');
                                },
                                child: Text("Booking Now",
                                    style: TextStyle(
                                      color: Colors.blue,
                                    )),
                              ),
                              alignment: Alignment.bottomRight,
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 25,
                      ),
                      // 2
                      Container(
                          child: Column(
                        children: [
                          Image.asset(
                            'lib/images/tennis.jpg',
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
                                  'Tennis Court',
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Location: Sport Field \n Opening Hour : 8AM - 6PM\n Number of Court : 3',
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Indoor Facility",
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                Container(
                  child: Wrap(
                    spacing: 25,
                    runSpacing: 25,
                    children: [
                      Image.asset(
                        'lib/images/badminton.png',
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
                              'Badminton Court',
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Location: Multipurpose Hall  \n Opening Hour : 8AM - 6PM\n Number of Court : 4',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),

                      // 2
                      Container(
                          child: Column(
                        children: [
                          Image.asset(
                            'lib/images/gymcenter.png',
                            width: 300,
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            width: 300,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Text(
                                  'Gym Center',
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Location: International Education Building (IEB)\n Opening Hour : 8AM - 6PM\nFacility:\n- Cardio Area \n- Cycling studio\n- Strength area\n- Locker ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ])),
        ));
  }
}
