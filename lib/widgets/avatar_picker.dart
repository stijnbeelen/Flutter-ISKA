import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

final List<String> images = [
  'mario',
  'luigi',
  'wario',
  'peach',
  'bowser',
  'toad',
  'yoshi'
];

class AvatarPicker extends StatefulWidget {
  final Sink<File> imageListenerSink;
  final Sink<String> iconNameListenerSink;

  const AvatarPicker({@required this.imageListenerSink, @required this.iconNameListenerSink});

  @override
  _AvatarPickerState createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  num pickedIndex = 1;
  Future<File> img;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.keyboard_arrow_left),
        Expanded(
          child: Container(
            height: 84,
            child: ListView.builder(
              itemCount: 7,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, num index) {
                if (index == 0) {
                  return Container(
                    width: index == pickedIndex ? 74 : 54,
                    height: index == pickedIndex ? 74 : 54,
                    decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle, border: Border.all()),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          pickedIndex = index;
                          img = ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 250, maxHeight: 250);
                        });
                      },
                      child: pickedIndex != 0 || img == null
                          ? Icon(Icons.photo_camera, size: index == pickedIndex ? 52 : 36, color: Colors.white)
                          : FutureBuilder(
                        future: img,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                            super.widget.imageListenerSink.add(snapshot.data);
                            return Center(child: CircleAvatar(radius: 36, backgroundImage: FileImage(snapshot.data)));
                          }
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(backgroundColor: Colors.black),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }

                return Container(
                  width: index == pickedIndex ? 84 : 64,
                  child: GestureDetector(
                    onTap: () =>
                        setState(() {
                          pickedIndex = index;
                          widget.iconNameListenerSink.add(images[index - 1]);
                        }),
                    child: Opacity(
                      opacity: index == pickedIndex ? 1 : .4,
                      child: Image(image: AssetImage('assets/img/${images[index - 1]}_icon.png'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Icon(Icons.keyboard_arrow_right),
      ],
    );
  }
}
