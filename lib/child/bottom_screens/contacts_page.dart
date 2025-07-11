// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../db/db_services.dart';
import '../../model/contactsm.dart';
import '../../utils/color_const.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    askPermissions();
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermissions();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
    } else {
      handInvaliedPermissions(permissionStatus);
    }
  }

  handInvaliedPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      dialogueBox(context, "Access to the contacts denied by the user");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      dialogueBox(context, "May contact does exist in this device");
    }
  }

  Future<PermissionStatus> getContactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  getAllContacts() async {
    print("Getting contacts...");
    List<Contact> _contacts = await FlutterContacts.getContacts(
      withPhoto: true,
      withProperties: true,
    );

    setState(() {
      contacts = _contacts;
      contactsFiltered = _contacts;
    });
  }

  void filterContacts(String query) {
    List<Contact> _contacts = [];
    if (query.isNotEmpty) {
      _contacts = contacts.where((contact) {
        String contactName = contact.displayName.toLowerCase();
        return contactName.contains(query.toLowerCase());
      }).toList();
    } else {
      _contacts = contacts;
    }

    setState(() {
      contactsFiltered = _contacts;
    });
  }

  String getInitials(Contact contact) {
    if (contact.displayName.isNotEmpty) {
      final nameParts = contact.displayName.split(' ');
      if (nameParts.length > 1) {
        return '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase();
      }
      return nameParts.first[0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search contacts...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.redAccent),
          autofocus: true,
          onChanged: filterContacts,
        )
            : Text("Contacts"),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  isSearching = false;
                  searchController.clear();
                  contactsFiltered = contacts;
                } else {
                  isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: contactsFiltered.length,
        itemBuilder: (BuildContext context, int index) {
          Contact contact = contactsFiltered[index];
          return ListTile(
            title: Text(contact.displayName),
            leading: contact.photo != null && contact.photo!.isNotEmpty
                ? CircleAvatar(
              backgroundColor: kColorRed,
              backgroundImage: MemoryImage(contact.photo!),
            )
                : CircleAvatar(
              backgroundColor: kColorRed,
              child: Text(getInitials(contact)),
            ),
            onTap: () {
              if (contact.phones!.length > 0) {

                final String phoneNum = contact.phones.first.number;
                final String name = contact.displayName!;
                _addContact(TContact(phoneNum, name));
              } else {
                Fluttertoast.showToast(
                    msg:
                    "Oops! phone number of this contact does exist");
              }
            },
          );
        },
      ),
    );
  }
  void _addContact(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);
    if (result != 0) {
      Fluttertoast.showToast(msg: "contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contacts");
    }
    Navigator.of(context).pop(true);
  }
}