import 'package:flutter/material.dart';
import 'UsuarioService.dart';
import 'usuario.dart';

class UserDetailScreen extends StatefulWidget {
  final Usuario usuario;

  UserDetailScreen({required this.usuario});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late Usuario usuario;

  @override
  void initState() {
    super.initState();
    usuario = Usuario.fromJson(widget.usuario.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Nombre', usuario.nombre, (value) => usuario.nombre = value),
              _buildTextField('Apellido', usuario.apellido, (value) => usuario.apellido = value),
              _buildTextField('Tipo de Documento', usuario.tipoDeDocumento, (value) => usuario.tipoDeDocumento = value),
              _buildTextField('Número de Documento', usuario.numeroDeDocumento, (value) => usuario.numeroDeDocumento = value),
              _buildTextField('Celular', usuario.celular, (value) => usuario.celular = value),
              _buildTextField('Email', usuario.email, (value) => usuario.email = value, keyboardType: TextInputType.emailAddress),
              _buildTextField('Contraseña', usuario.password, (value) => usuario.password = value, obscureText: true),
              _buildDropdown('Rol', usuario.rol, ['cliente', 'admin', 'barbero'], (value) => usuario.rol = value),
              SwitchListTile(
                title: Text('Activo'),
                value: usuario.activo == 1,
                onChanged: (value) => setState(() => usuario.activo = value ? 1 : 0),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarCambios,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String? initialValue, Function(String) onChanged, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown(String label, String? currentValue, List<String> options, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: currentValue,
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      try {
        await UsuarioService().actualizarUsuario(usuario.idUsuario!, usuario);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario actualizado')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar usuario: $e')),
        );
      }
    }
  }
}
