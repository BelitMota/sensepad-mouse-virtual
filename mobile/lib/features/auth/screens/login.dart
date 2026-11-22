import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              // meus elementos
              children: [
                // logo e titulo
                Image.asset(
                  'assets/images/logo_component.png',
                  width: 80,
                  height: 80,
                ),

                // container de cadastro principal
                Column(
                  children: [
                  // titulo
                  Text(
                    'Cadastrar-se'
                  ),
                  ],
                ),

                // container de labels e inputs
                Column(
                  children: [
                  TextField(
                    
                  ),                    
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
