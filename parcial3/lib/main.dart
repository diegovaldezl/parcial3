import 'dart:convert';
import 'dart:ffi';

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
    var url =
        Uri.parse("http://www.thecocktaildb.com/api/json/v1/1/search.php?f=a");
    final respuesta = await http.get(url);
    if (respuesta.statusCode == 200) {
      String body = utf8.decode(respuesta.bodyBytes);
      final jsonDatos = jsonDecode(body);

      for (var item in jsonDatos["drinks"]) {
        resultado.add(Resultado(item["strDrink"], item["strCategory"],
            item["strGlass"], item["strDrinkThumb"], item["strIngredient2"]));
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
          backgroundColor: const Color.fromARGB(255, 44, 24, 48),
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
      child: SizedBox(
        height: 575,
        child: ListView(
          children: [buscar(), listado()],
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
            height: 575,
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
      datosResultado.add(
        Center(
            child: SizedBox(
          width: 400,
          child: Column(children: [
            Card(
              elevation: 8,
              shadowColor: Colors.purple,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 231, 92, 92), width: 1)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 25, bottom: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                                image: NetworkImage(resultado[i].imagen),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            children: [
                              Text(
                                resultado[i].ingredientes,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      texto("Categoria"),
                                      SizedBox(
                                          width: 60,
                                          child: Text(resultado[i].categoria)),
                                    ],
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    children: [
                                      texto("Tipo de vaso"),
                                      SizedBox(
                                          width: 100,
                                          child: Text(resultado[i].strGlass)),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ]),
        )),
      );
      i++;
    }
    return datosResultado;
  }

  Widget buscar() {
    return Container(
      padding: const EdgeInsets.all(25),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Buscar coctel',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
