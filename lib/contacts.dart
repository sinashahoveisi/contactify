import 'package:flutter/material.dart';
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
  List<Contact>? _contacts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContact();
  }

  Future<bool> getPermission() async {
    return await FlutterContacts.requestPermission();
  }

  void getContact() async {
    if (await getPermission()) {
      List<Group> allGroups = await FlutterContacts.getGroups();
      List<Contact> allContacts = await FlutterContacts.getContacts(
          withProperties: true, withGroups: true);
      print(allGroups);
      setState(() {
        _contacts = allContacts;
      });
    }
  }

  void _incrementCounter() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _contacts == null ? const Center(child: CircularProgressIndicator()) :
      ListView.builder(
          itemCount: _contacts!.length,
          itemBuilder: (BuildContext context, int index) {
        String num = (_contacts![index].phones.isNotEmpty) ? (_contacts![index].phones.first.number) : "--";
        return ListTile(
          title: Text(
              "${_contacts![index].name.first} ${_contacts![index].name.last}"),
          subtitle: Text(num),
          onTap: () {
            print(num);
            // if (contacts![index].phones.isNotEmpty) {
            //   launch('tel: ${num}');
            // }
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
