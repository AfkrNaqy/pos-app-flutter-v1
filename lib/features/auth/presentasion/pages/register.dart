import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: 300,
          height: 700,
          padding: EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("Register"),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text("Email"),
                        TextFormField(),
                        SizedBox(height: 5),
                        Text("Username"),
                        TextFormField(),
                        SizedBox(height: 5),
                        Text("Password"),
                        TextFormField(),
                        SizedBox(height: 5),
                        Text("Password Confirmation"),
                        TextFormField(),
                      ],
                    ),
                  ),
                ],
              ),
              ElevatedButton(onPressed: () {}, child: Text("Register")),
            ],
          ),
        ),
      ),
    );
  }
}
