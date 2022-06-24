import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'model/usermodels.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({Key? key}) : super(key: key);

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {

  final _formKey = GlobalKey<FormState>();

  final firstnameEditingController  = TextEditingController();
  final lastnameEditingController  = TextEditingController();
  final emailEditingController  =  TextEditingController();
  final passwordEditingController = TextEditingController();
  final confrimpasswordEditingController  = TextEditingController();

  final _auth= FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {

    //First name
    final firstnameField= TextFormField(
      autofocus: false,
      controller: firstnameEditingController ,
      keyboardType: TextInputType.name,
      validator: (value)
      {
        if(value!.isEmpty)
        {
        return("First name can't be empty.");
        }     
        return null;
      },
      onSaved: (value) {
        firstnameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        hintText: "First name",
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );  

    //Last NAME
    final lastnameField= TextFormField(
      autofocus: false,
      controller: lastnameEditingController,
      validator: (value)  {
        if(value!.isEmpty)
        {
          return("Last name can't be empty.");
        } 
        return null;
      },
      keyboardType: TextInputType.name,
      onSaved: (value){
        lastnameEditingController.text=value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        hintText: "Last name",
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      );


      //Email
      final emailField= TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
       validator: (value)
      {
        if(value!.isEmpty)
        {
           return("Email cannot be empty.");
        }
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
      },
      onSaved: (value){
        emailEditingController.text=value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        hintText: "Email",
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      );


      //Password
      final passwordField= TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordEditingController,
       validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if(value!.isEmpty) {
            return("Password cannot be empty.");
          }
          if(!regex.hasMatch(value)) {
            return("Enter Valid Password.");
          }
          return null;
        },
      onSaved: (value){
        passwordEditingController.text=value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key),
        hintText: "Password",
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      );


      //Confrim password
      final confrimpasswordField= TextFormField(
      autofocus: false,
      obscureText: true,
      controller: confrimpasswordEditingController,
      validator: (value){
        if(passwordEditingController.text!=value)
        {
          return("Password doesn;'t matched.");
        }
        return null;
      },
      onSaved: (value){
        confrimpasswordEditingController.text=value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key),
        hintText: "Confrim password",
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      );

    final buttonField = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(25),
      color: Colors.blue,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
        Signup(emailEditingController.text,passwordEditingController.text);
        },
        child: Text("Signup", style: TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold),),
        ),
    );

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(onPressed:(){
            Navigator.of(context).pop();
          },
           icon: Icon(Icons.arrow_back,color: Colors.blue,),),
           ),
      body: (
        SingleChildScrollView(child: 
        Form(
          key:_formKey,
          child: 
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image.asset("assets/logo.png",height: 200,width: 200,),
                firstnameField,
                SizedBox(height: 20,),
                lastnameField,
                SizedBox(height: 20,),
                emailField,
                SizedBox(height: 20,),
                passwordField,
                SizedBox(height: 20,),
                confrimpasswordField,
                SizedBox(height: 20,),
                buttonField,
            ],
          ),
        ),
        ),
      )
      ),
      );
  }

  void Signup(String email, String password) async
  {
    if(_formKey.currentState!.validate())
    {
      await _auth.createUserWithEmailAndPassword(email: email, password: password) 
      .then((value) => {
        postDetailsToFirestore()
      }).catchError((e)
      {
        Fluttertoast.showToast(msg: e!.message);
      }
      );
    }

  }
   postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore= FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
    userModel.email=user!.email;
    userModel.uid=user.uid;
    userModel.firstname=firstnameEditingController.text;
    userModel.lastname=lastnameEditingController.text;
      await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => Loginpage()),
        (route) => false);
  }
}