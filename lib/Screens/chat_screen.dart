import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // future builder is imp for intialize app method
    return Scaffold(
        appBar: AppBar(
          title: const Text('UserName'),
          actions: [
            DropdownButton(
                icon: Icon(Icons.more_vert,
                    color: Theme.of(context).primaryIconTheme.color),
                items: [
                  DropdownMenuItem(
                    value: 'logout',
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Log out'),
                          Icon(
                            Icons.exit_to_app,
                            color: Theme.of(context).accentColor,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
                onChanged: (item) {
                  if (item == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                })
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chats/cXZ6uxuBhHmonZRed8j0/messages')
                .snapshots(),
            builder: (context, streamSnapshots) {
              if (streamSnapshots.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final documents = streamSnapshots.data?.docs;
              return ListView.builder(
                itemBuilder: (ctx, index) => Container(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(documents![index]['text']),
                  ),
                ),
                itemCount: documents?.length,
              );
            }),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('chats/cXZ6uxuBhHmonZRed8j0/messages')
                  .add({
                'text': 'This is new msg from click',
              });
            }));
  }
}
