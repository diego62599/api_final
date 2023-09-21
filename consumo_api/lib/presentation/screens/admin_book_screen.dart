import 'dart:convert';

import 'package:consumo_api/presentation/screens/book_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AdminBookScreen extends StatefulWidget {
  const AdminBookScreen({super.key});

  @override
  State<AdminBookScreen> createState() => _AdminBookScreenState();
}

class _AdminBookScreenState extends State<AdminBookScreen> {
  List<dynamic> books = [];
  String editedEstado = '';

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> editBook(Map<String, dynamic> bookData) async {
    Map<String, dynamic> editedData = {...bookData};
    editedEstado = bookData['estado'];

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Libro'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  onChanged: (value) {
                    editedData['nombre'] = value;
                  },
                  controller: TextEditingController(text: bookData['nombre']),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Autor'),
                  onChanged: (value) {
                    editedData['autor'] = value;
                  },
                  controller: TextEditingController(text: bookData['autor']),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Año'),
                  onChanged: (value) {
                    editedData['año'] = int.parse(value);
                  },
                  controller:
                      TextEditingController(text: bookData['año'].toString()),
                ),
                DropdownButton<String>(
                  value: editedEstado.isNotEmpty
                      ? editedEstado
                      : bookData['estado'],
                  items: <String>['Activo', 'Inactivo']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      editedEstado = newValue!;
                    });
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final response = await http.put(
                  //put porque es para editar
                  Uri.parse(
                      'https://api-flutter.onrender.com/api/books/${bookData['_id']}'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'nombre': editedData['nombre'],
                    'autor': editedData['autor'],
                    'año': editedData['año'],
                    'estado': editedEstado,
                  }),
                );

                if (response.statusCode == 200) {
                  fetchBooks();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  // Manejar errores de actualización
                  throw Exception('Error al actualizar el libro');
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchBooks() async {
    final response =
        await http.get(Uri.parse('https://api-flutter.onrender.com/api/books'));
    if (response.statusCode == 200) {
      setState(() {
        books = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar la lista de libros');
    }
  }

  Future<void> deleteBooks(String bookId) async {
    final response = await http.delete(
      Uri.parse('https://api-flutter.onrender.com/api/books/$bookId'),
    );
    if (response.statusCode == 204) {
      fetchBooks();
    } else {
      throw Exception('Error al eliminar el libro');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                title: Text(book['nombre']),
                subtitle: Text(book['autor']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        editBook(book);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Eliminar Libro'),
                              content: const Text(
                                  '¿Seguro que deseas eliminar este libro?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteBooks(book['_id']);
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookRegisterScreen()));
              },
              shape: const CircleBorder(),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.add_circle_outline)],
              ),
            ),
            const SizedBox(
              width: 30,
            )
          ],
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
