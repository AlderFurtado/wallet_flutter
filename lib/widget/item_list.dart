import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/models/item.dart';
import 'package:wallet/utils/utils.dart';

class ItemList extends StatelessWidget {
  ItemModel item;

  ItemList(this.item);
  final f = new DateFormat.yMd();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  item.nome,
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
              Chip(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                backgroundColor: Utils.getColor(item.categoria),
                label: Text(
                  item.categoria,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                f.format(new DateTime.fromMillisecondsSinceEpoch(item.data)),
                style: TextStyle(color: Colors.white54),
              ),
              Text("R\$ " + item.valor.toStringAsFixed(2),
                  style: TextStyle(color: Colors.white, fontSize: 14))
            ],
          ),
        )
      ],
    );
  }
}
