import 'package:contactify/constants/contact.dart';
import 'package:contactify/contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_contacts/flutter_contacts.dart';


class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<Group>? _groups;
  var uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    getContact();
  }

  Future<bool> getPermission() async {
    return await FlutterContacts.requestPermission(readonly: false);
  }

  void getContact() async {
    if (await getPermission()) {
      List<Group> allGroups = await FlutterContacts.getGroups();
      allGroups.insert(0, allContactGroup);
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

  void removeGroup(Group group) async {
    await FlutterContacts.deleteGroup(group);
    getContact();
  }

  void _showAddGroupDialog() {
    TextEditingController controllerName = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Add Group"),
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
        title: const Text("all Groups"),
        centerTitle: true,
      ),
      body: _groups == null ? const Center(child: CircularProgressIndicator()) :
      ListView.builder(
          itemCount: _groups!.length,
          itemBuilder: (BuildContext context, int index) {
          Group group = _groups![index];
        return Slidable(
            enabled: group.id != allContactGroup.id,
            endActionPane: ActionPane(
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: 'Delete',
                  onPressed: (BuildContext context) {
                    removeGroup(group);
                  }
              )
            ],
          ),
            child: ListTile(
              title: Text(group.name),
              trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 20,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactsPage(group: group)),
                );
              },
            ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGroupDialog,
        tooltip: 'add group',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
