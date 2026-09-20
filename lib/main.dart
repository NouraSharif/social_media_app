import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media_app/core/routes/app_router.dart';
import 'package:social_media_app/core/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/injection_container.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   setupDependencies();
  await Supabase.initialize(
    url: 'https://lprernyrsvifiohgaenb.supabase.co',
    publishableKey: 'sb_publishable_-9Nm3TUzEZp96f2r0PIyJA_Rp3tXjyc',
    accessToken: () async {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken(false);
      return token;
    },
  );
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
    );
  }
}
