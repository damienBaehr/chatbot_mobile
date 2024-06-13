import 'package:chatbot_filrouge/screen.characters.dart';
import 'package:chatbot_filrouge/screen.createUniverse.dart';
import 'package:chatbot_filrouge/screen.universUpdate.dart';
import 'package:chatbot_filrouge/services/service.univers.dart';
import 'package:flutter/material.dart';

class UniversListScreen extends StatefulWidget {
  @override
  _UniversListScreenState createState() => _UniversListScreenState();
}

class _UniversListScreenState extends State<UniversListScreen> {
  List<dynamic> universes = [];

  @override
  void initState() {
    super.initState();
    _fetchUniverses();
  }

  Future<void> _fetchUniverses() async {
    try {
      final universesData = await UniverseService().getUniverses();
      print('Universes: $universesData');
      setState(() {
        universes = universesData;
      });
    } on Exception catch (error) {
      print('Error fetching universes: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des univers',
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF9F5540),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: universes.length,
        itemBuilder: (context, index) {
          final universe = universes[index];
          return ListTile(
            leading: Image.network(
              UniverseService().fetchUniverseImg(universe['image']).toString(),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const Icon(Icons.error);
              },
            ),
            title: Text(universe['name']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    // Action à réaliser lorsqu'un univers est cliqué
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UniversUpdateScreen(
                          univers: universe,
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.edit),
                ),
                const SizedBox(width: 15), 
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CharactersHomeScreen(
                          universe: universe,
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.arrow_forward),
                ),
                const SizedBox(width: 8), // Espace entre les icônes
                
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateUniverseScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
