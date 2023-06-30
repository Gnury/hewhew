import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key,required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  //final _birthController = DatePickerDialog;
  final _ageController = TextEditingController();
  /*final _genderController = */

   @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future signUp() async{
    if (passwordConfirmed()){
      //create user
      UserCredential userCredenTial = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim(),
      );

      //Add user detail
      addUserDeatails(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(), 
        int.parse(_ageController.text.trim())
      );

      FirebaseFirestore.instance.collection("Users").doc(userCredenTial.user!.email).set({
        'username': _firstNameController.text + _lastNameController.text,
        'bio': 'Empty bio..'
      });

    } else if(_passwordController.text != _confirmpasswordController.text) {
        Navigator.pop(context);
        return AlertDialog(
          content: Text("Password don't match!"),
        );
    }
  }

  Future addUserDeatails(String firstName, String lastName, String email, int age) async{
    await FirebaseFirestore.instance.collection('users').add(
      {
        'first name' : firstName,
        'last name' : lastName,
        'age' : age,
        'email' : email,
      }
    );
  }

  bool passwordConfirmed() {
    if (_confirmpasswordController.text.trim() == 
        _passwordController.text.trim()){
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                //Hello!
                Text(
                  'You\'re New!',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 52,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Register Below',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: 50),
          
                //Fname textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurpleAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'First Name',
                      fillColor: const Color.fromARGB(255, 220, 218, 218),
                      filled: true,
                    ),
                  ),
                ),

                SizedBox(height: 10),

                //Lname textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurpleAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Last Name',
                      fillColor: const Color.fromARGB(255, 220, 218, 218),
                      filled: true,
                    ),
                  ),
                ),

                SizedBox(height: 10),

                //Age textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurpleAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Age',
                      fillColor: const Color.fromARGB(255, 220, 218, 218),
                      filled: true,
                    ),
                  ),
                ),

                SizedBox(height: 10),

                //BD textfield
                /*Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _birthController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurpleAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Date of Birth',
                      fillColor: const Color.fromARGB(255, 220, 218, 218),
                      filled: true,
                    ),
                  ),
                ),

                SizedBox(height: 10),*/

                //email textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurpleAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Email',
                      fillColor: const Color.fromARGB(255, 220, 218, 218),
                      filled: true,
                    ),
                  ),
                ),

                SizedBox(height: 10),
          
                //password textfield
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurpleAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Password',
                      fillColor: const Color.fromARGB(255, 220, 218, 218),
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                //confirm password textfield
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    obscureText: true,
                    controller: _confirmpasswordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurpleAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Confirm Password',
                      fillColor: const Color.fromARGB(255, 220, 218, 218),
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 10),
          
                //sign in button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 25),
          
                //register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'I am a member!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
                   ]),
          ),
       ),
     )
    );
  }
}