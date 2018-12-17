import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Quiz'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300.0,
              child: (
                TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        style: BorderStyle.solid,
                        color: Colors.blue,
                      ),
                    ),
                    hintText: 'Please enter your name.',
                  ),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  }
}

