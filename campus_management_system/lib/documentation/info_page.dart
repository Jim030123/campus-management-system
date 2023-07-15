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
                  'Campus Address: PTD 64888, Jalan Selatan Utama, KM 15, Off, Skudai Lbh, 81300 Skudai, Johor \nOnline Banking:\n CIMB XXXX_XXXX_XXXX_XXXX',
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
