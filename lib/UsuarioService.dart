import 'dart:convert';
import 'package:http/http.dart' as http;
import 'usuario.dart';
/*
Este archivo contiene la clase UsuarioService que maneja todas 
las interacciones con la API REST para realizar operaciones CRUD sobre los usuarios.
*/
class UsuarioService {
  /*
  Clase UsuarioService:
  Propiedad baseUrl:
  URL base de la API para las operaciones de usuario.
  */
  final String baseUrl = 'http://localhost:8080/usuarios';

  // Obtener lista de todos los usuarios
  Future<List<Usuario>> listarUsuarios() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => Usuario.fromJson(user)).toList();
    } else {
      throw Exception('Error al cargar los usuarios');
    }
  }

  // Obtener lista de usuarios activos
  Future<List<Usuario>> listarUsuariosActivos() async {
    final response = await http.get(Uri.parse('$baseUrl/activos'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => Usuario.fromJson(user)).toList();
    } else {
      throw Exception('Error al cargar los usuarios activos');
    }
  }

  // Obtener lista de usuarios inactivos
  Future<List<Usuario>> listarUsuariosInactivos() async {
    final response = await http.get(Uri.parse('$baseUrl/inactivos'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => Usuario.fromJson(user)).toList();
    } else {
      throw Exception('Error al cargar los usuarios inactivos');
    }
  }

  // Obtener un usuario por ID
  Future<Usuario> obtenerUsuario(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Usuario no encontrado');
    }
  }

  // Crear un nuevo usuario
  Future<Usuario> guardarUsuario(Usuario usuario) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(usuario.toJson()),
    );
    if (response.statusCode == 201) {
      return Usuario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear usuario');
    }
  }

  // Actualizar un usuario
  Future<Usuario> actualizarUsuario(int id, Usuario usuario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(usuario.toJson()),
    );
    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar usuario');
    }
  }

  // Eliminar un usuario
  Future<void> eliminarUsuario(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar usuario');
    }
  }

  // Restaurar un usuario
  Future<Usuario> recuperarCuenta(int id) async {
    final response = await http.put(Uri.parse('$baseUrl/recuperar/$id'));
    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al restaurar usuario');
    }
  }
}
/*
Importaciones:

dart:convert: Para codificar y decodificar JSON.
http: Paquete para realizar solicitudes HTTP.
usuario.dart: Modelo de datos Usuario.
*/

/*
Métodos CRUD:

listarUsuarios: Obtiene todos los usuarios.
listarUsuariosActivos: Obtiene solo los usuarios activos.
listarUsuariosInactivos: Obtiene solo los usuarios inactivos.
obtenerUsuario: Obtiene un usuario específico por su ID.
guardarUsuario: Crea un nuevo usuario enviando datos en formato JSON.
actualizarUsuario: Actualiza los datos de un usuario existente.
eliminarUsuario: Elimina un usuario por su ID.
recuperarCuenta: Restaura un usuario previamente eliminado o inactivo.

*/

/*
Manejo de Respuestas:

Se verifica el statusCode de cada respuesta HTTP para determinar si la operación fue exitosa.
Se lanzan excepciones con mensajes descriptivos en caso de errores.
*/
