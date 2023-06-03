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
            child: const Column(children: [
              Row(
                children: [
                  MyFacilityTile(),
                  Text(
                    'Physical fitness: Playing tennis on a tennis court is a great way to improve your overall physical fitness. The game involves running, jumping, and quick movements, which can enhance cardiovascular endurance, agility, and coordination. \nStrength building: Tennis requires you to use various muscle groups, such as the legs, arms, core, and back. Regular play on a tennis court can help strengthen these muscles, leading to improved overall strength and power.\nSkill development: Tennis is a skill-based sport that requires practice and technique. Regular play on a tennis court can help improve hand-eye coordination, timing, reflexes, and motor skills, which can be beneficial not only in tennis but also in other areas of life.\nAccessibility: Tennis courts are available in many communities, making the sport accessible to a wide range of individuals. Whether it\'s public park, a sports facility, or a private club, the presence of tennis courts provides an opportunity for people of all ages and skill levels to engage in physical activity and enjoy the sport.',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
