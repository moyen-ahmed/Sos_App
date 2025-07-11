import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sos_app/child/bottom_screens/contacts_page.dart';
import 'package:sos_app/components/PrimaryButton.dart';
import 'package:sos_app/db/db_services.dart';
import 'package:sos_app/model/contactsm.dart';
import 'package:sqflite/sqflite.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({super.key});

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  DatabaseHelper databasehelper=DatabaseHelper();
  List<TContact>? contactList=[];
  int count=0;

  void showList() {
    Future<Database> dbFuture = databasehelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TContact>> contactListFuture =
      databasehelper.getContactList();
      contactListFuture.then((value) {
        setState(() {
          this.contactList = value;
          this.count = value.length;
        });
      });
    });
  }
  void deleteContact(TContact contact) async {
    int result = await databasehelper.deleteContact(contact.id);
    if (result != 0) {
      Fluttertoast.showToast(msg: "contact removed succesfully");
      showList();
    }
  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showList();
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            PrimaryButton(title: "Add trusted Contact", onPressed: () async {
              bool result=await Navigator.push(

                  context, MaterialPageRoute(builder: (context)=>ContactsPage(), ));
              if (result==true){
                showList();
              }
            }),
Expanded(
  child: ListView.builder(
    //shrinkWrap: true,
      itemCount: count,
      itemBuilder: (BuildContext context,int index){
     return Card(
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: ListTile(
           title: Text(contactList![index].name),
           trailing: Container(
             width: 100,
             child: Row(
               children: [
                 IconButton(
                   onPressed: () async {
                     // Check and request call permission
                     if (await Permission.phone.request().isGranted) {
                       try {
                         await FlutterPhoneDirectCaller.callNumber(contactList![index].number);
                       } catch (e) {
                         Fluttertoast.showToast(msg: "Error making call: $e");
                       }
                     } else {
                       Fluttertoast.showToast(msg: "Phone permission denied");
                     }
                   },
                   icon: Icon(Icons.call, color: Colors.blue),
                 ),
                 IconButton(onPressed: () async{
                   deleteContact(contactList![index]);
                 },
                     icon: Icon(
                       Icons.delete,
                 color: Colors.blue,)),
               ],
             ),
           ),

         ),
       ),
     );
      },
  ),
),
          ],
        ),
      ),
    );
  }
}
