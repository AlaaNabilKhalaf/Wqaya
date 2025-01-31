import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Testing Page",style: TextStyle(fontSize: 50,color: Colors.blueGrey),),
      ),
    );
  }
}
