import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hewhew/auth/pages/profile_page.dart';
import 'package:hewhew/components/drawer.dart';
import 'package:hewhew/post/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  final textController = TextEditingController();

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void postPost() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('User Posts').add({
        'UserEmail': user.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
      }
      );
    }

    setState(() {
      textController.clear();
    });
  }

  void goToProfilePage() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar( 
        title: const Center(
          child: Text("หิ้ว หิ้ว",)),
          backgroundColor: Colors.amberAccent,

        ),drawer: MyDrawer(
          onProfileTap: goToProfilePage,
          onSignOut: signOut,
        ),
        body: Center(
          child: Column(
            children: [
              
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('User Posts').orderBy("TimeStamp",descending: false,).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];
                          return Post(
                            message: post['Message'], 
                            user: post['UserEmail'],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              //post
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    //text field
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Write Something',
                        ),
                        controller: textController,
                        obscureText: false,
                      ),
                    ),
                    IconButton(
                      onPressed: postPost,
                      icon: const Icon(Icons.arrow_circle_up_rounded))
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
