import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final myController = TextEditingController();

  void _startQuiz() {
//    Navigator.of(context).pushNamed(HomePage)

  Firestore.instance.collection('users').document(myController.text).setData({});

    /*Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) {

              return new Scaffold(
                appBar: new AppBar(
                  title: const Text('Quiz'),
                  centerTitle: true,
                ),
                body: Center(
                  child: Text(
                    "Hello there",
                    style: TextStyle(
                      fontSize: 15.0
                    ),
                  )
                )
              );
            }
        )
    );*/
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

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
                  controller: myController,
                )
              )
            ),
            RaisedButton(
              onPressed: _startQuiz,
              child: Text("Start Quiz"),
            )
          ],
        ),
      ),
    );
  }
}

