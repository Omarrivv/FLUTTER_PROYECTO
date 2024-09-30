import 'package:flutter/material.dart';
import 'UsuarioService.dart';
import 'usuario.dart';

// ignore: use_key_in_widget_constructors
class UserCreateScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _UserCreateScreenState createState() => _UserCreateScreenState();
}

class _UserCreateScreenState extends State<UserCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  Usuario usuario = Usuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Nombre', (value) => usuario.nombre = value),
              _buildTextField('Apellido', (value) => usuario.apellido = value),
              _buildTextField('Tipo de Documento', (value) => usuario.tipoDeDocumento = value),
              _buildTextField('Número de Documento', (value) => usuario.numeroDeDocumento = value),
              _buildTextField('Celular', (value) => usuario.celular = value),
              _buildTextField('Email', (value) => usuario.email = value, keyboardType: TextInputType.emailAddress),
              _buildTextField('Contraseña', (value) => usuario.password = value, obscureText: true),
              _buildDropdown('Rol', usuario.rol, ['cliente', 'admin', 'barbero'], (value) => usuario.rol = value),
              SwitchListTile(
                title: Text('Activo'),
                value: usuario.activo == 1,
                onChanged: (value) => setState(() => usuario.activo = value ? 1 : 0),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarUsuario,
                child: Text('Crear Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
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

  void _guardarUsuario() async {
    if (_formKey.currentState!.validate()) {
      try {
        await UsuarioService().guardarUsuario(usuario);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario creado con éxito')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear usuario: $e')),
        );
      }
    }
  }
}
