import 'package:flutter/material.dart';
import 'package:todo/ui/screens/home_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  rout() async {
    await Future.delayed(const Duration(seconds: 3));
    if (context.mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeLayout()));
    }
  }

  @override
  void initState() {
    super.initState();
    rout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo_light.png', width: 200),
      ),
    );
  }
}
