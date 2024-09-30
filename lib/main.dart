import 'package:flutter/material.dart'; // Proporciona Widgets y temas preferidos de Material Design
import 'UserListScreen.dart'; // Importa la pantalla de lista a los usuarios que sera la pantalla principal

void main() {
  runApp(MyApp()); //Inicia la aplicación ejecutando el widget MyApp
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget { //extiende de StatelessWidget para que indice que este widget no mantiene estado
  @override
  Widget build(BuildContext context) { //Retorna un MaterialApp con Propiedades title,theme:define el tema de la aplicacion usando primarySwatch azul y visualDensity  que es adaptiva, home:Establece
  //UserListScreen() como la pantalla principal
    return MaterialApp(
      title: 'Gestión de Usuarios',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserListScreen(),
    );
  }
}
