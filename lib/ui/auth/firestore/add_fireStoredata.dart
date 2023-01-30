

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:postitapp/Utils/utils.dart';
import 'package:postitapp/Widgets/round_button.dart';
import 'package:postitapp/ui/auth/firestore/firestore_list_screen.dart';

class AddFireStoreData extends StatefulWidget {
  const AddFireStoreData({Key? key}) : super(key: key);

  @override
  State<AddFireStoreData> createState() => _AddFireStoreDataState();
}

class _AddFireStoreDataState extends State<AddFireStoreData> {
  final postController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Add Fire store Data')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: [
                SizedBox(height: 20,),
                TextFormField(
                  controller: postController,
                  maxLines: 4,
                  decoration: InputDecoration(hintText: 'what is in  your mind',
                       border: OutlineInputBorder()),
                ),
                SizedBox(height: 30,),
                RoundButton(title: 'Add',loading: loading ,  onTap: (){
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                    'title': postController.text.toString(),
                    'id' : id,
                  }).then((value) {
                    Utils().toastMessage('Post Added');

                    setState(() {
                      loading = false;
                    });

                  }).onError((error, stackTrace) {

                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FireStoreScreen()));
                }),

              ]
          ),
        ));
  }

}
