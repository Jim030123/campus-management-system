import "package:flutter/material.dart";

class MyComponent extends StatelessWidget {
  const MyComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Campus Management System"), centerTitle: true,

        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Image.asset(
        //     'lib/images/logo.png',
        //   ),
        // ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'lib/images/logo.png',
              width: 150,
            ),
          ),

        ],
      ),
    );
  }
}
