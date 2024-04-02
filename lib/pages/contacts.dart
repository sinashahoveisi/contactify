import 'dart:typed_data';
import 'package:contactify/constants/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key, required this.group});

  final Group group;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact>? _allContacts = [];
  List<Contact>? _contacts = [];
  bool _isAllContactGroup = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContact();
  }

  void getContact() async {
    _allContacts = await FlutterContacts.getContacts(withProperties: true, withAccounts: true, withPhoto: true, withGroups: true);
    setState(() {
      _isAllContactGroup = widget.group.id == allContactGroup.id;
      if(_isAllContactGroup) {
        _contacts = _allContacts;
      } else {
        _contacts = _allContacts?.where((contact) => contact.groups.any((group) => group.id == widget.group.id)).toList();
      }
    });
  }

  void _showAddContactDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("add Contact to group"),
          content: Container(
            width: double.maxFinite,
            child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) =>
                ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  children: _allContacts
                  !.map(
                        (Contact contact) => CheckboxListTile(
                      title: Text("${contact.name.first} ${contact.name.last}"),
                      value: _contacts?.any((c) => c.id == contact.id),
                      onChanged: (bool? value) {
                        bool isChecked = value ?? false;
                        if(isChecked) {
                          _contacts?.add(contact);
                          contact.groups.add(widget.group);
                        }
                        else {
                          _contacts?.remove(contact);
                          contact.groups.remove(widget.group);
                        }
                        FlutterContacts.updateContact(contact, withGroups: true);
                        setState(() {});
                        this.setState(() {});
                      },
                    ),
                  ).toList(),
                ))
          ),
          actions: [
            TextButton(
              child: const Text('ok', style: TextStyle(fontSize: 15),),
              onPressed: () {
                Navigator.pop(context);
              }
            ),
          ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAllContactGroup ? "All Contacts" : "${widget.group.name} group"),
      ),
      body: _contacts!.isEmpty ? const Center(child: Text("Group is empty")) :
      ListView.separated(
          itemCount: _contacts!.length,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (BuildContext context, int index) {
            Contact? contact = _contacts![index];
            Uint8List? image = contact.photo;
            String num = (contact.phones.isNotEmpty) ? (contact.phones.first.number) : "-";
            return ListTile(
              leading: (contact.photo == null)
                  ? const CircleAvatar(child: Icon(Icons.person), backgroundColor: Colors.grey,)
                  : CircleAvatar(backgroundImage: MemoryImage(image!)),
              title: Text("${contact.name.first} ${contact.name.last}"),
              subtitle: Text(num),
              onTap: () {
                FlutterContacts.openExternalView(contact.id);
              },
            );
      }),
      floatingActionButton: _isAllContactGroup ? null : FloatingActionButton(
        onPressed: _showAddContactDialog,
        tooltip: 'add contact',
        child: const Icon(Icons.add),
      ),
    );
  }
}
