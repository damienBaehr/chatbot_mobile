import 'package:chatbot_filrouge/screen.userUpdate.dart';
import 'package:chatbot_filrouge/services/service.user.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

void _navigateToUpdateScreen(BuildContext context, Map<String, dynamic> user) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UserUpdateScreen(user: user),
    ),
  );
}

class _UserListScreenState extends State<UserListScreen> {
  Future<List<Map<String, dynamic>>>? _usersFuture;
  final userService = UserService();

  @override
  void initState() {
    super.initState();
    _usersFuture = _loadUsers();
  }

  Future<List<Map<String, dynamic>>> _loadUsers() async {
    try {
      final users = await userService.getAllUsers();
      print('Loaded users: $users');
      return users;
    } catch (error, stackTrace) {
      print('Error loading users: $error');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des utilisateurs',
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF9F5540),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Affiche un indicateur de chargement tant que les données sont en cours de chargement
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Affiche un message d'erreur s'il y a une erreur lors du chargement des données
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              // Affiche les données une fois qu'elles sont disponibles
              final users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return InkWell(
                    onTap: () {
                      // Action à réaliser lorsqu'un utilisateur est cliqué
                      print('User clicked: ${user['username']}');
                    },
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user['username']),
                      subtitle: Text(user['email']),
                      trailing: GestureDetector(
                        onTap: () => _navigateToUpdateScreen(context, user),
                        child: const Icon(Icons.arrow_forward_ios),
                      ), // Ajoutez d'autres informations utilisateur au besoin
                    ),
                  );
                },
              );
            } else {
              // Cas par défaut (normalement, cela ne devrait pas se produire)
              return const Center(child: Text('Aucune donnée à afficher'));
            }
          },
        ),
      ),
    );
  }
}
