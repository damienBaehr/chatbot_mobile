import 'package:chatbot_filrouge/screen.characters_desc.dart';
import 'package:chatbot_filrouge/services/service.characters.dart';
import 'package:chatbot_filrouge/services/service.univers.dart';
import 'package:flutter/material.dart';

class CharactersHomeScreen extends StatelessWidget {
  final Map<String, dynamic> universe;

  const CharactersHomeScreen({required this.universe});

  @override
  Widget build(BuildContext context) {
    final characterService = CharacterService();
    final universeService = UniverseService();

    return Scaffold(
      appBar: AppBar(  
        title: Text('Personnages de l\'univers ${universe['name']}'),
      ),
      body: Center(
        child: FutureBuilder(
          future: characterService.getAllCharactersByUnivers(universe['id']),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final characters = snapshot.data as List<dynamic>;
              return ListView.builder(
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final character = characters[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CharacterDescScreen(
                            character: character,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(80.0),
                            child: Image.network(
                              universeService
                                  .fetchUniverseImg(character['image'])
                                  .toString(),
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 50.0,
                                  height: 50.0,
                                  color: Colors.grey,
                                  child: const Center(
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(character['name']),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Text('Erreur lors de la récupération des personnages');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
