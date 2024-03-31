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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContact();
  }

  void getContact() async {
    _allContacts = await FlutterContacts.getContacts(withProperties: true, withAccounts: true, withPhoto: true, withGroups: true);
    setState(() {
      if(widget.group.id == allContactGroup.id) {
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
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatefulBuilder(builder: (BuildContext context, StateSetter setState) =>
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
              ],
            ),
          ),
    ));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("contacts of ${widget.group.name} group"),
      ),
      body: _contacts!.isEmpty ? const Center(child: Text("Group is empty")) :
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
        onPressed: _showAddContactDialog,
        tooltip: 'add contact',
        child: const Icon(Icons.add),
      ),
    );
  }
}
