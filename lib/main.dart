import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('testBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<String>('testBox');

    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Example'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Enter Name'),
          ),

          // Criar um novo Registro no Hive
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                box.add(_controller.text);
                setState(() {}); // Atualiza a UI
                _controller.clear();
              }
            },
            child: Text('Add Name'),
          ),

          // Listar Informações do HIVE
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<String> box, _) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final name = box.getAt(index) ?? '';
                    return ListTile(
                      title: Text(name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //Botão para atualizar o nome
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _updateName(index),
                          ),

                          // Botão para remover o nome
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteName(index),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Função para Deletar
  void _deleteName(int index) {
    var box = Hive.box<String>('testBox');
    box.deleteAt(index);
    setState(() {}); // Atualiza a UI
  }

  // Função para Atualizar
  void _updateName(int index) {
    var box = Hive.box<String>('testBox');
    _controller.text =
        box.getAt(index) ?? ''; // Define o nome atual no campo de texto

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Name"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Update"),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  box.putAt(index, _controller.text);
                }
                Navigator.of(context).pop();
                setState(() {}); // Atualiza a UI
              },
            )
          ],
        );
      },
    );
  }
}
