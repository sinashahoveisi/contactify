import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Group>? _groups;
  var uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    getContact();
  }

  Future<bool> getPermission() async {
    return await FlutterContacts.requestPermission();
  }

  void getContact() async {
    if (await getPermission()) {
      List<Group> allGroups = await FlutterContacts.getGroups();
      print(allGroups);
      setState(() {
        _groups = allGroups;
      });
    }
  }

  void addGroup(String name) async {
    Group newGroup = Group(uuid.v1(), name);
    await FlutterContacts.insertGroup(newGroup);
    getContact();
  }

  void _showAddContactDialog() {
    TextEditingController controllerName = TextEditingController();
    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: controllerName, decoration: const InputDecoration(hintText: "Name")),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () {
            addGroup(controllerName.text);
            Navigator.pop(context);
          }, child: const Text("Add"))
        ],
      ),
    ));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _groups == null ? const Center(child: CircularProgressIndicator()) :
      ListView.builder(
          itemCount: _groups!.length,
          itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
              _groups![index].name),
          onTap: () {
            print(num);
            // if (contacts![index].phones.isNotEmpty) {
            //   launch('tel: ${num}');
            // }
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
