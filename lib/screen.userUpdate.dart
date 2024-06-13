import 'package:chatbot_filrouge/services/service.user.dart';
import 'package:flutter/material.dart';

class UserUpdateScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserUpdateScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserUpdateScreenState createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  final userService = UserService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _lastnameController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user['username']);
    _emailController = TextEditingController(text: widget.user['email']);
    _lastnameController = TextEditingController(text: widget.user['lastname']);
    _nameController = TextEditingController(text: widget.user['firstname']);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _lastnameController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _updateUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await userService.updateUser(
          widget.user['id'].toString(),
          _usernameController.text,
          _emailController.text,
          _nameController.text,
          _lastnameController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated successfully')),
        );
        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modification de l\'utilisateur',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF9F5540),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lastnameController,
                decoration: const InputDecoration(labelText: 'Lastname'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a lastname';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _updateUser,
                  child: const Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
