import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _campoTexto = "";
  TextEditingController _cepText = TextEditingController();

  _buscaCep() async{
    String cepDigitado = _cepText.text;
    String url ="https://viacep.com.br/ws/${cepDigitado}/json/";
    
    http.Response response;

    response = await http.get(url);

    Map<String, dynamic>retorno = json.decode(response.body);

    String logradouro = retorno["logradouro"];
    String bairro = retorno["bairro"];
    String localidade = retorno["localidade"];
    bool erro = retorno["erro"];

    if(erro == true){
      setState(() {
        _campoTexto = "CEP não cadastrado";
        _cepText.text = "";
      });
    }
    else{
      setState(() {
       _cepText.text = "";
      _campoTexto = "Rua: ${logradouro}, Bairro: ${bairro}, Localidade: ${localidade}";
    });
    }
  }

  void _limparCampo(){
    setState(() {
      _campoTexto = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consulta de Ceps"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: <Widget>[
            Image.asset("images/busca_cep.png"),
            TextField(
              controller: _cepText,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Insira um cep sem pontos"
              ),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              ),
            Text(
                _campoTexto,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: Colors.lightBlue,
                  onPressed:_buscaCep,
                  child: Text("Buscar Cep"), 
                ),
                RaisedButton(
                  color: Colors.lightBlue,
                  onPressed: _limparCampo,
                  child: Text(
                    "Limpar Campo",
                    ),
                )
              ],
            )
          ],
        ),
      ),
      
    );
  }
}