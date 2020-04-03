import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:wallet/db/db_provider.dart';
import 'package:wallet/models/item.dart';
import 'package:wallet/widget/item_list.dart';
import 'package:flutter/src/material/date_picker.dart';

class Painel extends StatefulWidget {
  @override
  _PainelState createState() => _PainelState();
}

class _PainelState extends State<Painel> {
  List<ItemModel> itens;

  final f = new DateFormat.yMd();
  final _formKey = GlobalKey<FormState>();

  TextEditingController txtNome = new TextEditingController();
  final txtValor = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', leftSymbol: 'R\$ ');

  String dropdownValue = 'Alimentação';
  DateTime initialDate = new DateTime.now();

  String userName = "";

  LocalStorage localStorage = new LocalStorage("user");

  _PainelState() {
    this.getItens();
    userName = localStorage.getItem("user") != null
        ? localStorage.getItem("user")
        : "";
  }

  getItens() async {
    var res = await DBProvide.db.getItens();
    setState(() {
      itens = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                this.localStorage.getItem("user") != null
                    ? Text(
                        "Seja Bem-vindo " + this.userName,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        "Seja Bem-vindo ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                IconButton(
                  icon: Icon(Icons.person_pin),
                  color: Theme.of(context).primaryColor,
                  iconSize: 32,
                  onPressed: () {
                    this._showDialog();
                  },
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Material(
              elevation: 3,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black87,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Despesa Total",
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      itens != null
                          ? itens.length > 0
                              ? Text(
                                  "R\$ " +
                                      itens
                                          .map((f) => f.valor)
                                          .reduce((acc, v) => acc + v)
                                          .toStringAsFixed(2),
                                  style: TextStyle(
                                      fontSize: 42, color: Colors.white),
                                )
                              : Text(
                                  "R\$ 00.00",
                                  style: TextStyle(
                                      fontSize: 42, color: Colors.white),
                                )
                          : Text(
                              "R\$ 00.00",
                              style:
                                  TextStyle(fontSize: 42, color: Colors.white),
                            )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Align(
              alignment: Alignment.center,
              child: FlatButton.icon(
                onPressed: () {
                  _settingModalBottomSheet(context, null);
                },
                color: Theme.of(context).primaryColor,
                label: Text(
                  "Despesa",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Lista de itens",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white54),
                ),
                Icon(
                  Icons.filter_list,
                  color: Colors.white,
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: itens != null
                  ? itens.length > 0
                      ? ListView.separated(
                          itemCount: itens.length,
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.white70,
                            );
                          },
                          itemBuilder: (context, index) {
                            return Dismissible(
                              onDismissed: (direction) async {
                                await DBProvide.db.deleteItem(itens[index]);
                                this.getItens();
                              },
                              background: Container(color: Colors.red),
                              key: UniqueKey(),
                              child: InkWell(
                                  onTap: () {
                                    this._settingModalBottomSheet(
                                        context, itens[index]);
                                  },
                                  child: ItemList(itens[index])),
                            );
                          })
                      : Center(
                          child: Text(
                          "Nenhum item adicionado",
                          style: TextStyle(color: Colors.white54, fontSize: 18),
                        ))
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context, ItemModel item) {
    int id = item != null ? item.id : 0;
    txtNome.text = item != null ? item.nome : "";
    txtValor.text = item != null ? item.valor.toString() : "";
    initialDate = item != null
        ? DateTime.fromMillisecondsSinceEpoch(item.data)
        : DateTime.now();
    dropdownValue = item != null ? item.categoria : "Alimentação";

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        isScrollControlled: false,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: txtNome,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Digite um nome valido";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            labelText: "Nome",
                            labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor)),
                      ),
                      TextField(
                        controller: txtValor,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            labelText: "Valor",
                            labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor)),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          DropdownButton<String>(
                            hint: Text("Categoria"),
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            underline: Container(
                              height: 2,
                              color: Colors.white,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>[
                              'Alimentação',
                              'Educação',
                              'Lazer',
                              'Transporte',
                              'Saúde',
                              'Outros'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                f.format(initialDate),
                                style: TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () async {
                                  final dtPick = await showDatePicker(
                                      context: context,
                                      initialDate: this.initialDate,
                                      firstDate: new DateTime(2000),
                                      lastDate: new DateTime(2100));

                                  if (dtPick != null) {
                                    setState(() {
                                      this.initialDate = dtPick;
                                    });
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            ItemModel item = new ItemModel(
                                id: id,
                                nome: txtNome.value.text,
                                valor: txtValor.numberValue,
                                categoria: dropdownValue,
                                data: initialDate.millisecondsSinceEpoch);
                            try {
                              if (id == 0) {
                                DBProvide.db.insertItem(item);
                                Fluttertoast.showToast(
                                    msg: "Adicionado com sucesso",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                DBProvide.db.updateItem(item);
                                Fluttertoast.showToast(
                                    msg: "Alterado com sucesso",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              this.getItens();
                            } catch (ex) {} finally {
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text(
                          "Salva item",
                          style: TextStyle(fontSize: 16),
                        ),
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void _showDialog() {
    final txtNomeUsuario = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          backgroundColor: Colors.black87,
          content: Container(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text(
                  "Digite seu nome",
                  style: TextStyle(color: Colors.white),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Digite um nome valído";
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      )),
                  controller: txtNomeUsuario,
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Cancelar",
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Salvar"),
              onPressed: () {
                localStorage.setItem("user", txtNomeUsuario.text);
                setState(() {
                  this.userName = localStorage.getItem("user");
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
