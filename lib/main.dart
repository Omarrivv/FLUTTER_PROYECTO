import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter & Spring Boot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserManagementPage(),
    );
  }
}

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final String apiUrl = 'http://localhost:8080/usuarios'; // URL del API
  List<dynamic> _usuarios = [];
  bool _loading = false;
  

  // Método para obtener usuarios (GET)
  Future<void> _fetchUsuarios() async {
    setState(() {
      _loading = true;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          _usuarios = json.decode(response.body);
        });
      } else {
        throw Exception('Error al obtener usuarios');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  // Método para mostrar un diálogo con los detalles del usuario
  void _showUserDetailsDialog(Map<String, dynamic> usuario) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${usuario['nombre']} ${usuario['apellido']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Documento: ${usuario['tipoDeDocumento']} - ${usuario['numeroDeDocumento']}'),
              Text('Celular: ${usuario['celular']}'),
              Text('Email: ${usuario['email']}'),
              Text('Rol: ${usuario['rol']}'),
              Text('Estado: ${usuario['activo'] == 1 ? 'Activo' : 'Inactivo'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Método para eliminar usuario con alerta de confirmación
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar eliminación"),
          content: const Text("¿Estás seguro de que quieres eliminar este usuario?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Eliminar"),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                _eliminarUsuario(id); // Llamar al método de eliminar
              },
            ),
          ],
        );
      },
    );
  }

  // Método para eliminar usuario (DELETE)
  Future<void> _eliminarUsuario(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));
      if (response.statusCode == 204) {
        _fetchUsuarios(); // Refrescar la lista
      } else {
        throw Exception('Error al eliminar usuario');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUsuarios(); // Cargar usuarios al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _usuarios.length,
              itemBuilder: (context, index) {
                final usuario = _usuarios[index];
                return ListTile(
                  title: Text('${usuario['nombre']} ${usuario['apellido']}'),
                  subtitle: Text(usuario['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showUserDetailsDialog(usuario);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _confirmDelete(usuario['idUsuario']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí puedes agregar funcionalidad para crear un usuario
        },
        tooltip: 'Agregar Usuario',
        child: const Icon(Icons.add),
      ),
    );
  }
}
