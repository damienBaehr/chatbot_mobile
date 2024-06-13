import 'package:chatbot_filrouge/screen.home.dart';
import 'package:chatbot_filrouge/screen.register.dart';
import 'package:chatbot_filrouge/screen.userList.dart';
import 'package:chatbot_filrouge/services/service.user.dart';
import 'package:flutter/material.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final TextEditingController pseudoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.all(10),
          child: const Text(
            'Connexion',
            style: TextStyle(
              fontSize: 30,
              color: Color(0xFF9F5540),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 60,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: pseudoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom d\'utilisateur',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mot de passe',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  // Rediriger vers la page d'enregistrement
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScreenRegister()),
                  );
                },
                child: const Text(
                  'S\'enregistrer',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                 final userService = UserService();
                  try{
                    userService.loginUser(pseudoController.text, passwordController.text);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScreenHome(),
                    ),
                  );
                  }catch(e){
                    print('Erreur lors de la création de l\'utilisateur');
                  }
                },
                child: const Text('Connexion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
