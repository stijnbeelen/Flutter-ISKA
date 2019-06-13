import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iska_quiz/firestore_helper.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iska_quiz/lobby/lobby_bloc.dart';
import 'package:iska_quiz/quiz/quiz_page.dart';

import 'package:cached_network_image/cached_network_image.dart';

class LobbyPage extends StatefulWidget {
  static String tag = 'lobbypage';

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  final LobbyBLoC _lobbyBloc = LobbyBLoC();

  @override
  void initState() {
    super.initState();
    _lobbyBloc.streamGameState.listen((currentQuestion) {
      if (currentQuestion != 0)
        Navigator.of(context).pushNamed(QuizPage.tag, arguments: {'questionIndex': currentQuestion});
    });
  }

  @override
  void dispose() {
    _lobbyBloc.dispose();
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
          _waitingDescription(),
          _playerList(),
        ],
      ),
    );
  }

  Widget _waitingDescription() =>
      Material(
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
              return Text('$amountOfPlayers player${amountOfPlayers > 1 ? 's' : ''} joined');
            },
          ),
        ),
      );

  Widget _playerList() =>
      Expanded(
        child: StreamBuilder(
            stream: FirestoreHelper.players
                .orderBy('created', descending: true)
                .snapshots(),
            builder: this._buildPlayerListView
        ),
      );

  Widget _buildPlayerListView(BuildContext context, AsyncSnapshot snapshot) =>
      ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (context, index) =>
            Align(
              alignment: Alignment.center,
              child: _playerTile(index, snapshot.data.documents[index].data),
            ),
        separatorBuilder: (context, index) => Container(height: 5),
        itemCount: snapshot.data?.documents?.length ?? 0,
      );

  Widget _playerTile(num index, dynamic document) =>
      Card(
        elevation: 8,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: FutureBuilder(
                  future: document['avatar'] != null
                      ? FirebaseStorage.instance.ref().child(document['avatar']).getDownloadURL()
                      : Future.value(),
                  builder: this._buildPlayerIcon(document),
                ),
              ),
              Text(document['name'], style: TextStyle(fontSize: 20)),
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    Text(document['score'].toString(), style: TextStyle(fontSize: 20))
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget Function(BuildContext, AsyncSnapshot<dynamic>) _buildPlayerIcon(dynamic document) {
    return (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      if (document['avatar'] != null) {
        return ClipOval(
          child: CachedNetworkImage(
            width: 54,
            height: 54,
            fit: BoxFit.fitWidth,
            imageUrl: snapshot?.data ?? 'https://static.thenounproject.com/png/630729-200.png',
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => CircularProgressIndicator(),
          ),
        );
      }
      return Image(width: 64, height: 64, image: AssetImage("assets/img/${document['icon']}_icon.png"));
    };
  }
}
