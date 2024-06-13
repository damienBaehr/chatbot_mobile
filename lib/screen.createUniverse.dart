import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/services/service.univers.dart';

class CreateUniverseScreen extends StatefulWidget {
  @override
  _CreateUniverseScreenState createState() => _CreateUniverseScreenState();
}

class _CreateUniverseScreenState extends State<CreateUniverseScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _createUniverse() async {
    final String name = _nameController.text.trim();
    if (name.isNotEmpty) {
      try {
        await UniverseService().createUniverse(name);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Univers créé avec succès'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (error) {
        print('Error creating universe: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la création de l\'univers'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Afficher un message à l'utilisateur si le champ de saisie est vide
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un nom pour l\'univers'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Créer un univers',
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF9F5540),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom de l\'univers',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createUniverse,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
