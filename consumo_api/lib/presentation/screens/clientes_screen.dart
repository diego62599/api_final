import 'dart:convert';
import 'package:consumo_api/presentation/screens/clientes_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({Key? key}) : super(key: key);

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  List<dynamic> clientes = [];
  String editedEstado = '';

  @override
  void initState() {
    super.initState();
    fetchClientes();
  }

  Future<void> editCliente(Map<String, dynamic> clienteData) async {
    Map<String, dynamic> editedData = {...clienteData};
    editedEstado = clienteData['estado'];

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Editar Cliente'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Nombre y apellido'),
                  onChanged: (value) {
                    editedData['nombreApellido'] = value;
                  },
                  controller: TextEditingController(text: clienteData['nombreApellido']),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Correo'),
                  onChanged: (value) {
                    editedData['correo'] = value;
                  },
                  controller: TextEditingController(text: clienteData['correo']),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Dirección'),
                  onChanged: (value) {
                    editedData['direccion'] = value;
                  },
                  controller: TextEditingController(text: clienteData['direccion']),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  onChanged: (value) {
                    editedData['telefono'] = value;
                  },
                  controller: TextEditingController(text: clienteData['telefono']),
                ),
              ],
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () async {
                  final response = await http.put(
                    Uri.parse('https://api-clientes-moviles.onrender.com/api/clientes/${clienteData['_id']}'), 
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, dynamic>{
                      'nombreApellido': editedData['nombreApellido'],
                      'correo': editedData['correo'],
                      'direccion': editedData['direccion'],
                      'telefono': editedData['telefono'],
                      'estado': editedEstado,
                    }),
                  );

                  if (response.statusCode == 200) {
                    fetchClientes();
                    Navigator.of(context).pop();
                  } else {
                    throw Exception('Error al actualizar el cliente');
                  }
                },
                child: const Icon(Icons.save),
              ),
              const SizedBox(width: 16.0),
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> fetchClientes() async {
    final response = await http.get(
      Uri.parse('https://api-clientes-moviles.onrender.com/api/clientes'),
    );
    if (response.statusCode == 200) {
      setState(() {
        clientes = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar la lista de clientes');
    }
  }

  Future<void> deleteCliente(String clienteId) async {
    final response = await http.delete(
      Uri.parse('https://api-clientes-moviles.onrender.com/api/clientes/$clienteId'),
    );
    if (response.statusCode == 204) {
      fetchClientes();
    } else {
      throw Exception('Error al eliminar el cliente');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClienteRegisterScreen(),
                ),
              );
            },
            child: const Text('Registrar Cliente'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];
                return ListTile(
                  title: Text(cliente['nombreApellido']),
                  subtitle: Text(cliente['correo']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          editCliente(cliente);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Eliminar Cliente'),
                                content: const Text('¿Seguro que deseas eliminar este cliente?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteCliente(cliente['_id']);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
