import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ListToDo.dart';

class PaginaLogin extends StatefulWidget {
  @override
  _PaginaLoginState createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  TextEditingController _controllerLogin = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  salvarDados() async {
    String valorDigitado = _controllerLogin.text;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("login", valorDigitado);
    print("Salvar: $valorDigitado");

    String valorDigitado2 = _controllerSenha.text;
    final prefs2 = await SharedPreferences.getInstance();
    await prefs2.setString("senha", valorDigitado2);
    print("Salvar: $valorDigitado2");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo List"),
      ),
      body: Form(
        //consegue armazenar o estado dos campos de texto e além disso, fazer a validação
        key: _formKey, //estado do formulário
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: "Login:",
                hintText: "Digite o login",
              ),
              controller: _controllerLogin,
              validator: (String text) {
                if (text.isEmpty) {
                  return "Digite o texto";
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Senha:", hintText: "Digite a senha"),
              obscureText: true,
              controller: _controllerSenha,
              validator: (String text) {
                if (text.isEmpty) {
                  return "Digite a senha ";
                }
                if (text.length < 4) {
                  return "A senha tem pelo menos 4 dígitos";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 46,
              child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () {
                    salvarDados();
                    bool formOk = _formKey.currentState.validate();
                    if (!formOk) {
                      return;
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListToDo()),
                      );
                    }
                    print("Login " + _controllerLogin.text);
                    print("Senha " + _controllerSenha.text);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
