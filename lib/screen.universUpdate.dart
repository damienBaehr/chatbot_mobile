import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/services/service.univers.dart';

class UniversUpdateScreen extends StatefulWidget {
  final Map<String, dynamic> univers;

  const UniversUpdateScreen({Key? key, required this.univers}) : super(key: key);

  @override
  State<UniversUpdateScreen> createState() => _UniversUpdateScreenState();
}

class _UniversUpdateScreenState extends State<UniversUpdateScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.univers['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier l\'univers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom de l\'univers'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateUnivers();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateUnivers() async {
    final updatedName = _nameController.text.trim();
    // Appeler le service pour mettre à jour l'univers avec le nouveau nom
    try {
      await UniverseService().updateUniverse(widget.univers['id'], updatedName);
      // Afficher un message de succès ou naviguer vers une autre vue
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Univers mis à jour avec succès'),
      ));
    } catch (error) {
      // Gérer les erreurs, par exemple afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la mise à jour de l\'univers: $error'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
