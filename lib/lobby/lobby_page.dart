import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iska_quiz/firestore_helper.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iska_quiz/lobby/lobby_bloc.dart';
import 'package:iska_quiz/quiz/quiz_page.dart';

class LobbyPage extends StatefulWidget {
  static String tag = "lobbypage";

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  final LobbyBLoC bloc = LobbyBLoC();

  @override
  void initState() {
    super.initState();
    bloc.streamGameState.listen((gameStarted) {
      if (gameStarted) Navigator.of(context).pushReplacementNamed(QuizPage.tag);
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          waitingDescription(),
          playerList(),
        ],
      ),
    );
  }

  Widget waitingDescription() {
    return Material(
      elevation: 16,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          width: 50,
          height: 50,
          child: SpinKitPouringHourglass(color: Colors.blue),
          padding: EdgeInsets.only(right: 12),
        ),
        title: Text('Waiting for quiz master to start'),
        subtitle: StreamBuilder(
          stream: FirestoreHelper.players.snapshots(),
          builder: (context, snapshot) {
            final num amountOfPlayers = snapshot.data?.documents?.length ?? 0;
            return Text(
                '$amountOfPlayers player${amountOfPlayers > 1 ? 's' : ''} joined');
          },
        ),
      ),
    );
  }

  Widget playerList() {
    return Expanded(
      child: StreamBuilder(
        stream: FirestoreHelper.players
            .orderBy('created', descending: true)
            .snapshots(),
        builder: (context, snapshot) => ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) => Align(
                    alignment: Alignment.center,
                    child: playerTile(
                      index,
                      snapshot.data.documents[index].data,
                    ),
                  ),
              separatorBuilder: (context, index) => Container(height: 5),
              itemCount: snapshot.data?.documents?.length ?? 0,
            ),
      ),
    );
  }

  Widget playerTile(num index, dynamic document) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Image(
                width: 64,
                height: 64,
                image: AssetImage("assets/img/${document['icon']}_icon.png"),
              ),
            ),
            Text(
              document['name'],
              style: TextStyle(fontSize: 20),
            ),
            Container(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Text(
                    document['score'].toString(),
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
