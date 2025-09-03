import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile_manager/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.imageUrl, required this.onUpload});

  final String? imageUrl;
  final Function(String imageUrl) onUpload;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 150, height: 150,
          child: Container(
            child: 
            imageUrl != null ?
            CircleAvatar(backgroundImage: NetworkImage(imageUrl!,), backgroundColor: Colors.transparent,)
            :
            CircleAvatar(backgroundColor: Colors.cyan,child: Icon(Icons.person, size: 30, color: Colors.black87,),),
          ),
        ),
        SizedBox(height: 10,),
        TextButton(
          onPressed: () async{
            final ImagePicker picker = new ImagePicker();
            XFile? image = await picker.pickImage(source: ImageSource.gallery);
            if(image == null) return;
            final imageExtension = image.name.split('.').last.toLowerCase();
            final imageBytes = await image.readAsBytes();
            final userId = supabase.auth.currentUser!.id;
            final imagePath = '/$userId/profile';
            await supabase.storage.from('profiles').uploadBinary(
              imagePath, imageBytes, 
              fileOptions: FileOptions(upsert: true, contentType: 'image/$imageExtension')
            );
            String imageUrl = supabase.storage.from('profiles').getPublicUrl(imagePath);
            imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
              't': DateTime.now().millisecondsSinceEpoch.toString()
            }).toString();
            onUpload(imageUrl);
        },
          child: Text('UPLOAD', style: TextStyle(letterSpacing: 1.5, color: Colors.cyan),),
        )
      ],
    );
  }
}