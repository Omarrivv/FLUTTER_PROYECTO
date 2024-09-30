//Define el modelo de datos para un usuario (Usuario). 
//Este modelo se utiliza para representar y manipular 
//la información de los usuarios en la aplicación.
class Usuario {
  int? idUsuario;
  String? tipoDeDocumento;
  String? numeroDeDocumento;
  String? nombre;
  String? apellido;
  String? celular;
  String? email;
  String? password;
  String? rol;
  int? activo;

  Usuario({
    this.idUsuario,
    this.tipoDeDocumento,
    this.numeroDeDocumento,
    this.nombre,
    this.apellido,
    this.celular,
    this.email,
    this.password,
    this.rol,
    this.activo = 1,
  });

  /*
  Permite crear instancias de Usuario con valores opcionales.
  Por defecto, activo se establece en 1 (activo).
  */

  /*
  Factory constructor que crea una instancia de Usuario a partir de un mapa JSON.
Facilita la conversión de datos recibidos desde la API a objetos de Dart.
  */
  // Convertir un JSON en un objeto Usuario
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['idUsuario'],
      tipoDeDocumento: json['tipoDeDocumento'],
      numeroDeDocumento: json['numeroDeDocumento'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      celular: json['celular'],
      email: json['email'],
      password: json['password'],
      rol: json['rol'],
      activo: json['activo'],
    );
  }

  /*
  Convierte una instancia de Usuario a un mapa JSON.
  Utilizado para enviar datos a la API en formato JSON.
  */
  // Convertir un objeto Usuario a JSON
  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'tipoDeDocumento': tipoDeDocumento,
      'numeroDeDocumento': numeroDeDocumento,
      'nombre': nombre,
      'apellido': apellido,
      'celular': celular,
      'email': email,
      'password': password,
      'rol': rol,
      'activo': activo,
    };
  }
}
/*
DETALLES CLAVES:
Propiedades del Modelo:

idUsuario: Identificador único del usuario.
tipoDeDocumento: Tipo de documento (DNI, CNE).
numeroDeDocumento: Número del documento.
nombre, apellido: Nombre y apellido del usuario.
celular: Número de celular.
email: Correo electrónico.
password: Contraseña.
rol: Rol del usuario (cliente, admin, barbero).
activo: Estado activo (1) o inactivo (0).
 */