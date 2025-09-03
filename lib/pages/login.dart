import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:profile_manager/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  late final StreamSubscription<AuthState> authSubscription;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authSubscription = supabase.auth.onAuthStateChange.listen((event){
      final session = event.session;
      if(session!=null){
        Navigator.of(context).pushReplacementNamed('/account');
      }
     }
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    authSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(height: 30),
          Text(
            'LOGIN',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.cyan,
              letterSpacing: 2.5,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 70,),
          Padding(
            padding: 
            screenWidth < 600 ?
            EdgeInsets.fromLTRB(10,10,10,10)
            :
            EdgeInsets.fromLTRB(screenWidth * 0.35, 0, screenWidth * 0.35, 0)
            ,
            child: TextFormField(
              style: TextStyle(
                color: Colors.white
              ),
              cursorColor: Colors.cyanAccent,
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(1.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.cyan
                  )
                ),
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Colors.white,
                )
              ),
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: 
            screenWidth < 600 ?
            EdgeInsets.fromLTRB(screenWidth * 0.20, 0, screenWidth * 0.20, 0)
            :
            EdgeInsets.fromLTRB(screenWidth * 0.35, 0, screenWidth * 0.35, 0)
            ,
            child: TextButton(
              onPressed: () async{
                 try {
                  final email = emailController.text.trim();
                  final redirectTo = kIsWeb ? '${Uri.base.origin}/' : 'io.supabase.flutterquickstart://login-callback/';
                  await supabase.auth.signInWithOtp(
                    email: email,
                    emailRedirectTo: redirectTo
                  );
                  if(mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Check your inbox for the verification link'))
                    );
                  }
                } 
                on AuthException catch (error){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error.message),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      )
                    );
                }
                catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Eror Occured. Please retry'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      )
                    );
                }
              },
              child: Text('VERIFY EMAIL', 
              textAlign: TextAlign.center,
                style: TextStyle(color: Colors.cyan, letterSpacing: 1.5),
              ),
            ),
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}