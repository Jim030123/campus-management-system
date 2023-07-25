import 'package:cloud_firestore/cloud_firestore.dart';

List role = ['Student', 'Management', 'Visitor'];



Future<DocumentSnapshot> findUserById(String userid) async {
    DocumentSnapshot user =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();
    return user;
  }

  class MyDatabase {
     final _vehicleBrand = [
    'Perodua',
    'Proton',
    'Honda',
    'Toyota',
    'BMW',
    'Audi',
    'Lexus',
    'Mazda',
    'Mercedes-Benz',
    'Nissan',
    'Suzuki',
    'Volvo',
    'Ford',
    'Subaru',
    'Porsche',
    'Mitsubishi',
    'Infiniti',
    'Hyundai',
    'Chevrolet',
    'Isuzu'
  ];

  }

   
