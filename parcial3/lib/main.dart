import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parcial3/datos.dart';

void main() {
  runApp(const Inicio());
}

class Inicio extends StatelessWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Parcial 3",
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Resultado>> _getListado() async {
    var url = Uri.parse("https://jsonplaceholder.typicode.com/photos");
    final respuesta = await http.get(url);
    if (respuesta.statusCode == 200) {
      String body = utf8.decode(respuesta.bodyBytes);
      final jsonDatos = jsonDecode(body);

      for (var item in jsonDatos) {
        resultado.add(Resultado(item["albumId"], item["id"], item["title"],
            item["url"], item["thumbnailUrl"]));
      }
      return resultado;
    } else {
      return throw Exception("Error de conexión");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Parcial 3"),
        ),
        body: detalle());
  }

  Widget titulo() {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          texto("ID"),
          texto("Titulo"),
          texto("Imagen 1"),
          texto("Imagen 2")
        ],
      ),
    );
  }

  Widget texto(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget detalle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 500,
        child: ListView(
          children: [titulo(), listado()],
        ),
      ),
    );
  }

  Widget listado() {
    return FutureBuilder(
      future: _getListado(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: 600,
            child: ListView(
              children: _mostrarDatos(snapshot.data),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Actualize nuevamente"),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  List<Widget> _mostrarDatos(data) {
    int i = 0;
    List<Widget> datosResultado = [];

    for (var item in data) {
      datosResultado.add(Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color.fromARGB(255, 167, 166, 166)))),
        height: 100,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(resultado[i].id.toString()),
          SizedBox(width: 75, child: Text(resultado[i].titulo)),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                    image: NetworkImage(resultado[i].img1), fit: BoxFit.cover)),
            width: 70,
            height: 70,
          ),
          SizedBox(
              width: 50,
              height: 50,
              child: Image(image: NetworkImage(resultado[i].img2)))
        ]),
      ));
      i++;
    }
    return datosResultado;
  }
}
