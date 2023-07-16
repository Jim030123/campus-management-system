import 'package:flutter/material.dart';

class PaymentInfoPage extends StatelessWidget {
  const PaymentInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    textAlign: TextAlign.center,
                    'Please proceed the Payment at AFO or using online Banking',
                    style: TextStyle(fontSize: 30)),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Campus Address: PTD 64888, Jalan Selatan Utama, KM 15, Off, Skudai Lbh, 81300 Skudai, Johor \nPayee Name: Kolej University Selatan\nOnline Banking:\nCIMB 800 628 951 5\nPublic Bank 315 001 226 6\nRHB Bank 201 400 000 497 39\nPlease fax (07-558 9986) or email (accfin@sc.edu.my) payment notice together with bank in slip which indicates student name, student ID, contact number and payment details.',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Go back to Main Page'))
              ],
            )),
      ),
    );
  }
}
