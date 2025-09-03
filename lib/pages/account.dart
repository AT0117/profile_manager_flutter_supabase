import 'package:flutter/material.dart';
import 'package:profile_manager/main.dart';
import 'package:profile_manager/widgets/avatar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  final usernameController = TextEditingController();
  final websiteController = TextEditingController();
  String? _imageUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async{
    final userId = supabase.auth.currentUser!.id;
    final data = await supabase.from('profiles').select().eq('id', userId).single();
    setState(() {
      usernameController.text = data['username'] ?? '';
      websiteController.text = data['website'] ?? '';
      _imageUrl = data['avatar_url'];
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    websiteController.dispose();
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
            'ACCOUNT',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.cyan,
              letterSpacing: 2.5,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 70,),
          Avatar(imageUrl: _imageUrl, onUpload: (imageUrl) async {
            setState(() {
              _imageUrl = imageUrl;
            });
            final userId = supabase.auth.currentUser!.id;
            await supabase.from('profiles').update({'avatar_url': imageUrl}).eq('id', userId);
          }),
          SizedBox(height: 30,),
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
              controller: usernameController,
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
                labelText: 'Username',
                hintText: 'Enter a username',
                labelStyle: TextStyle(
                  color: Colors.white,
                )
              ),
            ),
          ),
          SizedBox(height: 1,),
          Padding(
            padding: 
            screenWidth < 600 ?
            EdgeInsets.fromLTRB(10,10,10,10)
            :
            EdgeInsets.fromLTRB(screenWidth * 0.35, 10, screenWidth * 0.35, 10)
            ,
            child: TextFormField(
              style: TextStyle(
                color: Colors.white
              ),
              cursorColor: Colors.cyanAccent,
              controller: websiteController,
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
                labelText: 'Website',
                hintText: 'Enter your website',
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
            EdgeInsets.fromLTRB(screenWidth * 0.35, 0, screenWidth * 0.35, 0),
            child: TextButton(
              onPressed: () async{
                final username = usernameController.text.trim();
                final website = websiteController.text.trim();
                final userId = supabase.auth.currentUser!.id;
                await supabase.from('profiles').update(
                  {
                    'username': username,
                    'website': website
                  }
                ).eq('id', userId);
                if(mounted){
                   ScaffoldMessenger(child: SnackBar(
                    content: Text('Profile updated successfully'),
                  ),);
                }
              },
              child: Text(
                'SAVE', 
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.cyan, letterSpacing: 1.5,),
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: 
            screenWidth < 600 ?
            EdgeInsets.fromLTRB(screenWidth * 0.20, 0, screenWidth * 0.20, 0)
            :
            EdgeInsets.fromLTRB(screenWidth * 0.35, 0, screenWidth * 0.35, 0),
            child: TextButton(
              onPressed: () async {
                await supabase.auth.signOut();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Signed out')),
                  );
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              child: Text(
                'LOGOUT',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, letterSpacing: 1.5),
              ),
            ),
          )
        ],
      ),
    );
  }
}