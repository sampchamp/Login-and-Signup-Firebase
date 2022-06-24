import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'registerpage.dart';
import 'homepage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {

  bool hiddenpassword=true;
  //formkey
  final _formKey = GlobalKey<FormState>();

  //EditingController
  final emailEditingController = TextEditingController();
  final passwordEditingController  =  TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
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
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
   

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      obscureText: hiddenpassword,
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
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
  
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText:"Password" ,
        suffixIcon:InkWell(
          onTap: _togglePasswordView,
        child: Icon(Icons.visibility),
         ),
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
        onPressed: (){ signIn(emailEditingController.text, passwordEditingController.text);
        },
        child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold),),
        ),
        
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Image.asset("assets/logo.png",height: 200,width: 200,),
                    emailField,
                    SizedBox(height: 20,),
                    passwordField,
                    SizedBox(height: 20,),
                    buttonField,
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?",style:TextStyle(fontSize: 15,fontWeight: FontWeight.w400)),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Registerpage()));
                          },
                          child: Text(" Signup",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 15,color: Colors.blue)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  void signIn(String email, String password) async {
    if(_formKey.currentState!.validate())
    {
       await _auth
      .signInWithEmailAndPassword(email: email, password: password)
      .then((uid) => {
       Fluttertoast.showToast(msg: "Login Sucessfully!"),
       Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => Homepage()),),),
      }).catchError((e)
      {
         Fluttertoast.showToast(msg: e!.message);
      });
      
    }
  }

  void _togglePasswordView()
  {
   if(hiddenpassword== true)
   {
    hiddenpassword=false;
   }
   else
   {
    hiddenpassword=true;
   }
  setState((){});
}
}