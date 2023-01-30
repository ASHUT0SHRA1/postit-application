
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:postitapp/Utils/utils.dart';
import 'package:postitapp/Widgets/round_button.dart';
import 'package:postitapp/ui/post/postScreen.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add Post')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 20,),
              TextFormField(

                controller: postController,
                decoration: InputDecoration(hintText: 'what is in  your mind',border: OutlineInputBorder()),
                maxLines: 4,
              ),
              SizedBox(height: 30,),
              RoundButton(title: 'Add',loading: loading ,  onTap: (){
                setState(() {
                  loading = true;
                });
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                databaseRef.child(id).set({
                  "title" : postController.text.toString(),
                  'id' : id

                }).then((value){
                  Utils().toastMessage('Post Added');
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {

                  Utils().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              })

          ]
    )),
      ));
  }

}
