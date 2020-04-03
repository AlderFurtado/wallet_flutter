import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:wallet/db/db_provider.dart';
import 'package:wallet/models/item.dart';
import 'package:wallet/utils/utils.dart';
import 'package:wallet/widget/card_box.dart';
import 'package:wallet/widget/chart_pizza.dart';

class Statistic extends StatefulWidget {
  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  int touchedIndex;

  List<ItemModel> itens;

  bool _showMoney = false;

  _StatisticState() {
    this.getItens();
  }

  ItemModel lastItemByBuy() {
    ItemModel itemModel = new ItemModel();

    itemModel.data = 0;

    if (this.itens != null && this.itens.isNotEmpty) {
      for (var i = 0; i < this.itens.length; i++) {
        if (itemModel.data < this.itens[i].data) {
          itemModel = this.itens[i];
        }
      }
      return itemModel;
    }

    return null;
  }

  ItemModel getBiggerBuy() {
    if (this.itens != null && this.itens.isNotEmpty) {
      ItemModel max = this.itens.first;
      this.itens.forEach((e) {
        if (e.valor > max.valor) max = e;
      });
      return max;
    }

    return null;
  }

  // sortList(List list, property) {
  //   var listTemp = [];

  // }

  Map<String, dynamic> getExpensiveCategoria() {
    if (this.itens != null && this.itens.isNotEmpty) {
      HashMap<String, double> categoriasValue = new HashMap();
      var sortedList = [];
      this
          .itens
          .map((f) => categoriasValue[f.categoria] =
              categoriasValue[f.categoria] != null
                  ? categoriasValue[f.categoria] + f.valor
                  : f.valor)
          .toList();

      sortedList = categoriasValue.keys.toList()
        ..sort((b, a) => categoriasValue[a].compareTo(categoriasValue[b]));

      var categoria = {
        "nome": sortedList[0],
        "valor": categoriasValue[sortedList[0]],
      };
      return categoria;
    }
    return null;
  }

  Future getItens() async {
    var res = await DBProvide.db.getItens();
    setState(() {
      itens = res;
    });
  }

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: itens != null
          ? itens.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Gastos por categoria",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Switch(
                              value: _showMoney,
                              onChanged: (value) {
                                setState(() {
                                  _showMoney = !_showMoney;
                                });
                              })
                        ],
                      ),
                      ChartPizza(showingSections()),
                      SizedBox(
                        height: 14,
                      ),
                      CardBox(
                          Colors.blue,
                          Icons.calendar_today,
                          "Data da ultima compra",
                          Utils.formatData(
                                  new DateTime.fromMillisecondsSinceEpoch(
                                      lastItemByBuy().data)) +
                              " - " +
                              lastItemByBuy().nome),
                      SizedBox(
                        height: 14,
                      ),
                      CardBox(
                          Colors.green,
                          Icons.attach_money,
                          "Compra mais cara",
                          getBiggerBuy().nome +
                              ": R\$ " +
                              getBiggerBuy().valor.toString()),
                      SizedBox(
                        height: 14,
                      ),
                      CardBox(
                          Colors.yellow,
                          Icons.category,
                          "Categoria mais gastas",
                          getExpensiveCategoria()["nome"].toString() +
                              ": R\$ " +
                              getExpensiveCategoria()["valor"].toString()),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    "Nenhum item computado",
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> listPieChartSectionData = new List();

    HashMap<String, double> categoriasValue = new HashMap();
    this
        .itens
        .map((f) => categoriasValue[f.categoria] =
            categoriasValue[f.categoria] != null
                ? categoriasValue[f.categoria] + f.valor
                : f.valor)
        .toList();

    for (var item in categoriasValue.keys) {
      listPieChartSectionData.add(new PieChartSectionData(
        color: Utils.getColor(item),
        value: categoriasValue[item],
        title: _showMoney
            ? "R\$ " + categoriasValue[item].toStringAsFixed(2)
            : item,
        radius: 60,
        titleStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      ));
    }

    return listPieChartSectionData;
  }
}
