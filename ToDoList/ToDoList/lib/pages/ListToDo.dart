import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ListToDo extends StatefulWidget {
  @override
  ToDoListState createState() => ToDoListState();
}

class ToDoListState extends State<ListToDo> {
  List todos = List();
  String input = "";

  recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, 'banco3.bd');
    var bd = await openDatabase(localBancoDados, version: 1,
        onCreate: (db, dbVersaoRecente) {
      String sql =
          'CREATE TABLE itens (id INTEGER PRIMARY KEY AUTOINCREMENT, item VARCHAR) ';
      db.execute(sql);
    });
    return bd;
  }

  salvarDados(String input) async {
    Database bd = await recuperarBancoDados();
    Map<String, dynamic> itens = {
      'item': input,
    };
    int id = await bd.insert('Lista', itens);
    print('Salvo: $id ');
  }

  @override
  void initState() {
    super.initState();
    /*
    todos.add('Tarefa 1');
    todos.add('Tarefa 2');
    todos.add('Tarefa 3');
    todos.add('Tarefa 4');
*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saliba's ToDo List"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("Add ToDo List"),
                  content: TextField(
                    onChanged: (String value) {
                      input = value;
                      salvarDados(input);
                    },
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            todos.add(input);
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text("Add"))
                  ],
                );
              });
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(todos[index]),
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    title: Text(todos[index]),
                    onLongPress: () {
                      todos.removeAt(index);
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        title: Text("Change ToDo List"),
                        content: TextField(
                          onChanged: (String value) {
                            input = value;
                            salvarDados(input);
                          },
                        ),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  todos.add(input);
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text("Change"))
                        ],
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          todos.removeAt(index);
                        });
                      },
                    ),
                  ),
                ));
          }),
    );
  }
}
