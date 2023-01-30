import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../Utils/utils.dart';
import '../loginscreen.dart';
import 'add_fireStoredata.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({Key? key}) : super(key: key);

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {

  final auth = FirebaseAuth.instance;
  final editController =  TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Fire Store')),
        actions: [
          IconButton(onPressed: (){
            auth.signOut().then((value) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            }).onError((error, stackTrace){
              Utils().toastMessage(error.toString());
            });
          }, icon: Icon(Icons.logout_sharp))
        ],
      ),

      body: Column(
        children: [

          StreamBuilder<QuerySnapshot>(
            stream: fireStore,
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }
              if(snapshot.hasError){
                return Text('some Error');
              }
              return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        return ListTile(
                          onTap: (){
                            ref.doc(snapshot.data!.docs[index]['id'].toString()).update({
                              'title': 'ashutosh'
                            }).then((value){
                              Utils().toastMessage('Updated');

                            }).onError((error, stackTrace) {
                              Utils().toastMessage(error.toString());
                            });
                          },
                          title: Text(snapshot.data!.docs[index]['title'].toString()),
                          subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                        );
                      })
              );

              }
              ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFireStoreData()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showMydialog(String title,String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),

                ),


              ),

            ),
            actions: [
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('Update')),


              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('Cancel')),
            ],
          );
        }
    );
  }
}
