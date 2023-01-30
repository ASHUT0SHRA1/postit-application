
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:postitapp/Utils/utils.dart';
import 'package:postitapp/Widgets/round_button.dart';
import 'package:postitapp/ui/auth/loginscreen.dart';
import 'package:postitapp/ui/post/chatscreen.dart';
// import 'package:postitapp/ui/post/add_post.dart';
import 'package:postitapp/ui/post/drawing_tab.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('post');
  final searchFilter = TextEditingController();
  final editController =  TextEditingController();
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('post');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Post')),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Row(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        width: 300,
                        child: TextFormField(

                          controller: postController,
                          decoration: InputDecoration(hintText: 'what is in  your mind',border: OutlineInputBorder()),
                          maxLines: 4,
                        ),
                      ),
                      SizedBox(height: 10,
                      width: 5,),
                      Container(
                        width: 70,
                        height: 100,
                        child: RoundButton(title: 'Add',

                            loading: loading ,  onTap: (){
                          setState(() {
                            loading = true;
                          });
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
                        }),
                      )

                    ]
                )),
          )
          // Expanded(child: StreamBuilder(
        //
        //     builder: (context, AsyncSnapshot<DatabaseEvent> snapshot ){
        //       if(!snapshot.hasData){
        //         return CircularProgressIndicator();
        //       }
        //       else{
        //         Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
        //         List<dynamic> list = [];
        //         list.clear();
        //         list = map.values.toList();
        //
        //         return ListView.builder(
        //             itemCount: snapshot.data!.snapshot.children.length,
        //             itemBuilder: (context,index){
        //               return ListTile(
        //                 title: Text(list[index]['title'].toString()),
        //                 subtitle: Text(list[index]['id'].toString()),
        //               );
        //             });
        //       }
        //
        //     },
        //   )),
          ,
          Expanded(
            child: FirebaseAnimatedList(query: ref,
                defaultChild: Text('Loading'),
                itemBuilder: (context ,snapshot,animation,index){
              final title =  snapshot.child('title').value.toString();
              if(searchFilter.text.isEmpty){
                return ListTile(
                  title: Text(snapshot.child('title').value.toString()),
                  subtitle: Text(snapshot.child('id').value.toString()),
                  trailing: PopupMenuButton(
                    icon: Icon(Icons.more_vert), itemBuilder: (context) => [
                      PopupMenuItem(
                          value : 1,
                          child: ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              showMydialog(title, snapshot.child('id').value.toString());
                            },
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                      )),
                    PopupMenuItem(
                        value: 2,
                        child: ListTile(
                          onTap: (){
                            Navigator.pop(context);
                            ref.child(snapshot
                              .child('id')
                              .value
                              .toString()).remove();
                          },
                      leading: Icon(Icons.delete),
                      title: Text('Delete'),
                    ))
                    ],
                  ),
                );
              }
              else if(title.toLowerCase().contains(searchFilter.text.toLowerCase().toLowerCase())){
                return ListTile(
                  title: Text(snapshot.child('title').value.toString()),
                  subtitle: Text(snapshot.child('id').value.toString()),
                );
              }
              else{
                return Container();
              }

            }),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 1,bottom: 15,right: 20),
                child: RoundButton(title: 'Drawing Tab', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>drawingTab()));
                }),
              ),


            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 1,bottom: 15,right: 20),
                child: RoundButton(title: 'Ask Question', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen()));
                }),
              ),

            ],
          ),

        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPostScreen()));
      //   },
      //   child: Icon(Icons.add),
      // ),
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
                ref.child(id).update({
                  'title' : editController.text.toLowerCase()
                }).then((value) {
                  Utils().toastMessage('Post Updated');
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
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
