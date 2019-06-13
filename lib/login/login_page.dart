import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iska_quiz/firestore_helper.dart';
import 'package:iska_quiz/lobby/lobby_page.dart';
import 'package:iska_quiz/login/login_bloc.dart';
import 'package:iska_quiz/widgets/avatar_picker.dart';
import 'package:iska_quiz/widgets/iska_logo.dart';
import 'package:iska_quiz/widgets/strings.dart';
import 'package:uuid/uuid.dart';

import 'package:rxdart/rxdart.dart';

import 'package:progress_button/progress_button.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'loginpage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginBLoC _loginBloc = LoginBLoC();

  final TextEditingController _usernameController = TextEditingController();

  final StreamController<File> _avatarPickerImageStreamController = StreamController<File>();
  final StreamController<String> _avatarPickerIconNameStreamController = StreamController<String>();

  final StreamController<ButtonState> _progressButtonStream = StreamController<ButtonState>();

  Observable<ButtonState> buttonStateStream;

  File _avatarImage;
  String _iconName;

  @override
  void initState() {
    super.initState();

    _loginBloc.streamLoginSuccess.listen(this._onLoginSuccess);
    _avatarPickerImageStreamController.stream.listen((file) => _avatarImage = file);
    _avatarPickerIconNameStreamController.stream.listen((iconName) => _iconName = iconName);
    buttonStateStream = this._mergeStreams();
    _loginBloc.streamLoginError.listen(this._resetButtonAfter(Duration(milliseconds: 250)));
  }

  void _onLoginSuccess(bool loginSucceeded) async {
    if (loginSucceeded) {
      if (_avatarImage != null) {
        var uuid = Uuid().v4();
        var firebaseStorageRef = FirebaseStorage.instance.ref().child('$uuid.jpg');
        await firebaseStorageRef
            .putFile(_avatarImage)
            .onComplete;
        await FirestoreHelper.currentPlayer.updateData({'avatar': '$uuid.jpg'});
      }
      Navigator.of(context).pushReplacementNamed(LobbyPage.tag);
    }
  }

  Observable<ButtonState> _mergeStreams() {
    return Observable.merge([
      _loginBloc.streamLoginEvent.map((event) => ButtonState.inProgress),
      _loginBloc.streamLoginSuccess.map((event) => ButtonState.normal),
      _loginBloc.streamLoginError.map((event) => ButtonState.error),
      _progressButtonStream.stream,
    ]);
  }

  Future<void> Function(String error) _resetButtonAfter(Duration duration) =>
          (String error) async => Future.delayed(duration, () => _progressButtonStream.sink.add(ButtonState.normal));

  @override
  void dispose() {
    _usernameController.dispose();
    _loginBloc.dispose();
    _avatarPickerImageStreamController.close();
    _avatarPickerIconNameStreamController.close();
    _progressButtonStream.close();
    super.dispose();
  }

  void _attemptLogin() {
    final String username = _usernameController.text;
    final String iconName = _iconName;
    if (username.isNotEmpty) {
      _loginBloc.loginEventSink.add(LoginEvent(username, iconName));
    } else {
      _loginBloc.loginErrorStreamSink.add('Please enter a username');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.title),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                child: IskaLogo(),
              ), // logo
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  Strings.hypeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ), // hype text
              Container(
                width: 250,
                margin: EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: this._usernameController,
                  decoration: InputDecoration(hintText: 'Username'),
                ),
              ), // username field
              Container(
                width: 250,
                margin: EdgeInsets.all(10),
                child: StreamBuilder(
                  stream: _loginBloc.streamLoginError,
                  initialData: null,
                  builder: (context, snapshot) =>
                  snapshot.data != null
                      ? Text(
                    snapshot.data,
                    style: TextStyle(color: Colors.red),
                  )
                      : Container(),
                ),
              ), // login error
              AvatarPicker(
                imageListenerSink: _avatarPickerImageStreamController.sink,
                iconNameListenerSink: _avatarPickerIconNameStreamController.sink
              ), // avatar picker
              Padding(
                padding: EdgeInsets.fromLTRB(60, 30, 60, 30),
                child: StreamBuilder(
                  initialData: ButtonState.normal,
                  stream: buttonStateStream,
                  builder: (context, snapshot) =>
                      ProgressButton(
                        child: Text(
                          Strings.startQuiz,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: _attemptLogin,
                        buttonState: snapshot.data,
                        backgroundColor: Theme
                            .of(context)
                            .primaryColor,
                        progressColor: Colors.white,
                      ),
                ),
              ), // button
            ],
          ),
        ),
      ),
    );
  }
}
