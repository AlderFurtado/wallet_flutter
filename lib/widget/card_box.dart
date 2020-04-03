import 'package:flutter/material.dart';

class CardBox extends StatelessWidget {
  Color color;
  IconData icon;
  String titulo;
  String subtitulo;

  CardBox(this.color, this.icon, this.titulo, this.subtitulo);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white12,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: this.color,
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  this.icon,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    this.titulo.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    this.subtitulo,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
