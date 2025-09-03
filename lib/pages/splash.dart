import 'package:flutter/material.dart';
import 'package:profile_manager/main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redirect();
  }

  Future<void> redirect() async{
    await Future.delayed(Duration.zero);
    final session = supabase.auth.currentSession;

    if(!mounted) return;

    if(session != null){
      Navigator.of(context).pushReplacementNamed('/account');
    }
    else{
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}