import 'package:flutter/material.dart';

class ButtonSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonColumn(
            icon: Icons.call,
            label: "CALL",
          ),
          ButtonColumn(
            icon: Icons.near_me,
            label: 'ROUTE',
          ),
          ButtonColumn(
              icon: Icons.share,
              label: 'SHARE'
          )
        ],
      ),
    );
  }
}

class ButtonColumn extends StatelessWidget {

  ButtonColumn({this.icon, this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
                label,
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: color
                )
            )
        )
      ],
    );
  }
}