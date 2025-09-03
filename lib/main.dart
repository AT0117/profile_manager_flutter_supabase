import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:profile_manager/pages/account.dart';
import 'package:profile_manager/pages/login.dart';
import 'package:profile_manager/pages/splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: '*****',
    anonKey: '*****',
  );
  runApp(ProfileManagerApp());
}

final supabase = Supabase.instance.client;

class ProfileManagerApp extends StatefulWidget {
  const ProfileManagerApp({super.key});

  @override
  State<ProfileManagerApp> createState() => _ProfileManagerAppState();
}

class _ProfileManagerAppState extends State<ProfileManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Manager - Flutter',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/account': (context) => AccountPage(),
        '/login': (context) => LoginPage(),   
      },
    );
  }
}
