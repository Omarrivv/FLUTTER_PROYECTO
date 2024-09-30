/*
Esta pantalla muestra una lista de usuarios. 
Permite filtrar los usuarios por estado (todos, activos, inactivos),
eliminar o restaurar usuarios, y navegar a la pantalla de detalles o creación de usuarios.
*/

import 'package:flutter/material.dart';
import 'UsuarioService.dart';
import 'usuario.dart';
import 'UserDetailScreen.dart';
import 'UserCreateScreen.dart';

// ignore: use_key_in_widget_constructors
class UserListScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<Usuario>> futureUsuarios;
  final UsuarioService usuarioService = UsuarioService();
  String filter = 'todos'; // Estado del filtro actual

  @override
  void initState() {
    super.initState();
    futureUsuarios = usuarioService.listarUsuarios(); // Cargar todos los usuarios por defecto
  }

  void _filterUsers(String type) {
    setState(() {
      filter = type; // Actualizar el filtro actual
      if (type == 'activos') {
        futureUsuarios = usuarioService.listarUsuariosActivos();
      } else if (type == 'inactivos') {
        futureUsuarios = usuarioService.listarUsuariosInactivos();
      } else {
        futureUsuarios = usuarioService.listarUsuarios(); // Cargar todos los usuarios
      }
    });
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Usuario'),
          content: const Text('¿Estás seguro de que deseas eliminar este usuario?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () async {
                try {
                  await usuarioService.eliminarUsuario(id);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario eliminado')));
                  _filterUsers(filter); // Actualizar la lista según el filtro actual
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showRestoreConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restaurar Usuario'),
          content: const Text('¿Estás seguro de que deseas restaurar este usuario?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Restaurar'),
              onPressed: () async {
                try {
                  await usuarioService.recuperarCuenta(id);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario restaurado')));
                  _filterUsers('inactivos'); // Opcional: Cargar inactivos después de restaurar
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
      ),
      body: Column(
        children: [
          // Filtros
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _filterUsers('todos'),
                  child: const Text('Todos'),
                ),
                ElevatedButton(
                  onPressed: () => _filterUsers('activos'),
                  child: const Text('Activos'),
                ),
                ElevatedButton(
                  onPressed: () => _filterUsers('inactivos'),
                  child: const Text('Inactivos'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Usuario>>(
              future: futureUsuarios,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final usuarios = snapshot.data!;
                  return ListView.builder(
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = usuarios[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text('${usuario.nombre} ${usuario.apellido}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(usuario.email ?? '', style: const TextStyle(color: Colors.grey)),
                          trailing: usuario.activo == 0
                              ? IconButton(
                                  icon: const Icon(Icons.restore, color: Colors.green),
                                  tooltip: 'Restaurar',
                                  onPressed: () => _showRestoreConfirmation(usuario.idUsuario!),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'Eliminar',
                                  onPressed: () => _showDeleteConfirmation(usuario.idUsuario!),
                                ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDetailScreen(usuario: usuario),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserCreateScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
/*
Importaciones:

flutter/material.dart: Widgets y temas de Material Design.
UsuarioService.dart: Servicio para interactuar con la API.
usuario.dart: Modelo de datos Usuario.
UserDetailScreen.dart: Pantalla para ver y editar detalles de un usuario.
UserCreateScreen.dart: Pantalla para crear un nuevo usuario.
*/

/*
Clase UserListScreen:

Extiende StatefulWidget: Indica que este widget mantiene estado mutable.
*/

/*
Estado _UserListScreenState:

Propiedades:

futureUsuarios: Future que contiene la lista de usuarios.
usuarioService: Instancia de UsuarioService para interactuar con la API.
filter: String que indica el filtro actual ('todos', 'activos', 'inactivos').
Método initState:

Inicializa futureUsuarios cargando todos los usuarios por defecto.
Métodos de Filtrado:

_filterUsers(String type): Actualiza el filtro y recarga los usuarios según el tipo seleccionado.
Métodos de Confirmación:

_showDeleteConfirmation(int id): Muestra un diálogo de confirmación para eliminar un usuario.
_showRestoreConfirmation(int id): Muestra un diálogo de confirmación para restaurar un usuario.
*/

/*

Método build:

Estructura del Scaffold:
AppBar: Título 'Usuarios'.
Body: Columna que contiene:
Filtros: Botones para filtrar usuarios (Todos, Activos, Inactivos).
Lista de Usuarios: Usando FutureBuilder para manejar estados de carga, error y datos.
FloatingActionButton: Botón flotante para navegar a la pantalla de creación de usuario.

*/

/*

Detalles de la Lista de Usuarios:

Cada usuario se muestra dentro de un Card que contiene un ListTile.
ListTile:
Título: Nombre completo del usuario en negrita.
Subtítulo: Email del usuario en color gris.
Trailing: IconButton para eliminar o restaurar según el estado del usuario.
onTap: Navega a UserDetailScreen pasando el usuario seleccionado.

*/


/*

Interacción con UsuarioService:

Se utiliza para cargar, eliminar y restaurar usuarios, manejando la lógica de negocios y comunicación con la API.

*/

