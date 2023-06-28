import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_divider.dart';
import 'package:flutter/material.dart';

class TwinSharingRoomBlock_A_C extends StatelessWidget {
  const TwinSharingRoomBlock_A_C({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Twin Sharing Room \n(Non Air Contioned)",
                      style: TextStyle(fontSize: 30))),
              MyDivider(),
              Center(
                  child: Column(
                children: [
                  Image.asset('lib/images/Twin_Sharing_old.png'),
                  Divider(
                    color: Colors.black,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Room Facility",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(25)),
                    child: Wrap(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      spacing: 25,
                      runSpacing: 25,
                      children: [
//1
                        Column(children: [
                          Text(
                            '- Single Bed & Bunk Bed\n- Wardrobe\n- Curtain\n- Individual study table & chair\n- Fan\n - Basin ',
                            style: TextStyle(fontSize: 20),
                          )
                        ]),

                        // 2
                        Column(children: [
                          Text(
                            'Sharing Facilities',
                            style: TextStyle(fontSize: 30),
                          ),
                          MyDivider(),
                          Text(
                              '- Water Heater\n- Refrigerator\n- Water Dispender\n - Coin-operated Washing Wachine and Dryer\n- WIFI \n- Study Room',
                              style: TextStyle(fontSize: 20))
                        ]),
                      ],
                    ),
                  )
                ],
              )),
              SizedBox(
                height: 25,
              ),
              Wrap(
                runAlignment: WrapAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'lib/images/room_facility.jpg',
                    width: 400,
                  ),
                  Image.asset(
                    'lib/images/room_facility2.jpg',
                    width: 400,
                  ),
                  Image.asset(
                    'lib/images/room_facility3.jpg',
                    width: 400,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TwinSharingRoomBlock_B_D extends StatelessWidget {
  const TwinSharingRoomBlock_B_D({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Twin Sharing Room \n(Air Contioned)",
                      style: TextStyle(fontSize: 30))),
              MyDivider(),
              Center(
                  child: Column(
                children: [
                  Image.asset('lib/images/Twin_Sharing_old.png'),
                  Divider(
                    color: Colors.black,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Room Facility",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(25)),
                    child: Wrap(
                      runSpacing: 25,
                      spacing: 25,
                      children: [
//1
                        Column(children: [
                          Text(
                            '- Single Bed & Bunk Bed\n- Wardrobe\n- Curtain\n- Individual study table & chair\n- Fan\n - Basin ',
                            style: TextStyle(fontSize: 20),
                          )
                        ]),

                        // 2
                        Column(children: [
                          Text(
                            'Sharing Facilities',
                            style: TextStyle(fontSize: 30),
                          ),
                          MyDivider(),
                          Text(
                              '- Water Heater\n- Refrigerator\n- Water Dispender\n - Coin-operated Washing Wachine and Dryer\n- WIFI \n- Study Room',
                              style: TextStyle(fontSize: 20))
                        ]),
                      ],
                    ),
                  )
                ],
              )),
              SizedBox(
                height: 25,
              ),
              Wrap(
                runAlignment: WrapAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'lib/images/room_facility.jpg',
                    width: 400,
                  ),
                  Image.asset(
                    'lib/images/room_facility2.jpg',
                    width: 400,
                  ),
                  Image.asset(
                    'lib/images/room_facility3.jpg',
                    width: 400,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TwinSharingRoomIEB extends StatelessWidget {
  const TwinSharingRoomIEB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Twin Sharing Room \n(Air Contioned)",
                      style: TextStyle(fontSize: 30))),
              MyDivider(),
              Center(
                  child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      spacing: 25,
                      runSpacing: 25,
                      children: [
                        Image.asset('lib/images/twinieb_area.png'),
                        Image.asset('lib/images/twinieb.png'),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Room Facility",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(25)),
                    child: Wrap(
                      runSpacing: 25,
                      spacing: 25,
                      children: [
//1
                        Column(children: [
                          Text(
                            'Room Facility',
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(
                            '- Single Bed & Bunk Bed\n- Wardrobe\n- Curtain\n- Individual study table & chair\n- Fan\n - Basin ',
                            style: TextStyle(fontSize: 20),
                          )
                        ]),

                        // 2
                        Column(children: [
                          Text(
                            'Sharing Facilities',
                            style: TextStyle(fontSize: 30),
                          ),
                          MyDivider(),
                          Text(
                              '- Water Heater\n- Refrigerator\n- Water Dispender\n - Coin-operated Washing Wachine and Dryer\n- WIFI \n- Study Room',
                              style: TextStyle(fontSize: 20))
                        ]),
                      ],
                    ),
                  )
                ],
              )),
              SizedBox(
                height: 25,
              ),
              Wrap(
                runAlignment: WrapAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'lib/images/ieb_room_facility.png',
                    width: 400,
                  ),
                  Image.asset(
                    'lib/images/ieb_room_facility2.png',
                    width: 400,
                  ),
                  Image.asset(
                    'lib/images/ieb_room_facility3.png',
                    width: 400,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrioSharingRoomIEB extends StatelessWidget {
  const TrioSharingRoomIEB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Trio Sharing Room \n(Air Contioned)",
                      style: TextStyle(fontSize: 30))),
              Center(
                  child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      runSpacing: 25,
                      spacing: 25,
                      children: [
                        Image.asset('lib/images/trioieb_area.png'),
                        Image.asset('lib/images/trioieb.png'),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Room Facility",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(25)),
                    child: Wrap(
                      spacing: 25,
                      runSpacing: 25,
                      children: [
//1
                        Column(children: [
                          Text(
                            '- Single Bed & Bunk Bed\n- Wardrobe\n- Curtain\n- Individual study table & chair\n- Fan\n - Basin ',
                            style: TextStyle(fontSize: 20),
                          )
                        ]),

                        // 2
                        Column(children: [
                          Text(
                            'Sharing Facilities',
                            style: TextStyle(fontSize: 30),
                          ),
                          MyDivider(),
                          Text(
                              '- Water Heater\n- Refrigerator\n- Water Dispender\n - Coin-operated Washing Wachine and Dryer\n- WIFI \n- Study Room',
                              style: TextStyle(fontSize: 20))
                        ]),
                      ],
                    ),
                  )
                ],
              )),
              SizedBox(
                height: 25,
              ),
              Wrap(
                runAlignment: WrapAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'lib/images/ieb_room_facility.png',
                    width: 400,
                  ),
                  Image.asset(
                    'lib/images/ieb_room_facility2.png',
                    width: 400,
                  ),
                  Image.asset(
                    'lib/images/ieb_room_facility3.png',
                    width: 400,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
