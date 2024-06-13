import 'package:chatbot_filrouge/screen.home.dart';
import 'package:chatbot_filrouge/services/service.user.dart';
import 'package:flutter/material.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});
  

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class PasswordTextField extends StatefulWidget {
  final String title;
  final TextEditingController controller;

  const PasswordTextField({Key? key, required this.title,required this.controller}) : super(key: key);
  

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscured,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.title,
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off_outlined,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
      ),
    );
  }
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController pseudoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmationPasswordController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "S'enregistrer",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              width: 60,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: mailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mail',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: nomController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: pseudoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Pseudo',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              PasswordTextField(title: "Mot de passe", controller: passwordController,), 
              const SizedBox(
                height: 20,
              ),
              PasswordTextField(title: "Confirmation mot de passe", controller: confirmationPasswordController,), 
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  final userService = UserService();
                  try{
                    userService.createUser(pseudoController.text, mailController.text, passwordController.text, nomController.text, nomController.text);
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
                child: const Text('S\'enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
