import 'package:flutter/material.dart';

class TestingScrn extends StatelessWidget {
  const TestingScrn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                color: Colors.amber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}