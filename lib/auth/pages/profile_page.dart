import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hewhew/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection("Users");

  Future<void> editField(String field) async{
    String newValue = "";
    await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
          ),
        content: TextField(
          autocorrect: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },

        ),
        actions: [
          //cancle button
          TextButton(
            child: Text('Cancle',
            style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),

          //save button
          TextButton(
            child: Text('Save',
            style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );
    if (newValue.trim().length > 0) {
      await userCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Center(
          child: Text('Profile')),
        backgroundColor: Colors.amberAccent,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>; 

            return ListView(
              children: [
                const SizedBox(height: 50),
                //porfile pic
                const Icon(
                  Icons.person,
                  size: 72,
                ),

                const SizedBox(height: 10,),

                //user email
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height: 50),

                //user detail
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                //username
                MyTextBox(
                  text: userData['username'], 
                  sectionName: 'username',
                  onPressed: () => editField('username'),
                ),

                //bio
                MyTextBox(
                  text: userData['bio'], 
                  sectionName: 'bio',
                  onPressed: () => editField('bio'),
                ),
                const SizedBox(height: 50,),

                //user posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Post',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            );
          }else if (snapshot.hasError){
            return Center(child: Text('Error${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }  
      ), 
    );
  }
}