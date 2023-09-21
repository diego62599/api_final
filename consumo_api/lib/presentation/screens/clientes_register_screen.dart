import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClienteRegisterScreen extends StatefulWidget {
  const ClienteRegisterScreen({Key? key}) : super(key: key);

  @override
  State<ClienteRegisterScreen> createState() => _ClienteRegisterScreenState();
}

class _ClienteRegisterScreenState extends State<ClienteRegisterScreen> {
  TextEditingController nombreApellidoController = TextEditingController();
  TextEditingController cedulaController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  String? estadoValue; // Variable para almacenar el valor del estado
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String url = 'https://api-clientes-moviles.onrender.com/api/clientes';

  void registrarCliente() async {
    final nombre = nombreApellidoController.text;
    final cedula = cedulaController.text;
    final correo = correoController.text;
    final direccion = direccionController.text;
    final telefono = telefonoController.text;

    final body = jsonEncode({
      'nombreApellido': nombre,
      'cedula': int.tryParse(cedula) ?? 0,
      'correo': correo,
      'direccion': direccion,
      'telefono': telefono,
      'estado': estadoValue, // Usar el valor seleccionado
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de registro')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: nombreApellidoController,
                decoration: const InputDecoration(
                  labelText: 'Nombre y apellido',
                  hintText: 'Ingrese el nombre y apellido',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el nombre y apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: cedulaController,
                decoration: const InputDecoration(
                  labelText: 'Cédula',
                  hintText: 'Ingrese la cédula',
                  prefixIcon: Icon(Icons.credit_card),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la cédula';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: correoController,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  hintText: 'Ingrese el correo',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el correo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: direccionController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  hintText: 'Ingrese la dirección',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la dirección';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  hintText: 'Ingrese el teléfono',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el teléfono';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: estadoValue,
                onChanged: (value) {
                  setState(() {
                    estadoValue = value;
                  });
                },
                items: <String>['Activo', 'Inactivo'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  hintText: 'Seleccione el estado',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, seleccione el estado';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    registrarCliente();
                  }
                },
                child: const Text('Registrar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
