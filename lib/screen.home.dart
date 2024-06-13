import 'package:chatbot_filrouge/screen.characters.dart';
import 'package:chatbot_filrouge/screen.message.dart';
import 'package:chatbot_filrouge/screen.universList.dart';
import 'package:chatbot_filrouge/screen.userList.dart';
import 'package:chatbot_filrouge/services/service.characters.dart';
import 'package:chatbot_filrouge/services/service.conversations.dart';
import 'package:chatbot_filrouge/services/service.univers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  List<Widget> characterWidgetsList = [];
  List<dynamic> universes = [];

  String? userName;

  @override
  void initState() {
    super.initState();
    _fetchUniverses();
    _fetchUserName();
    _fetchConversations();
  }

  Future<void> _fetchConversations() async {
    try {
      final conversationsData =
          await ConversationService().getAllConversations();
      final characterService = CharacterService();
      final universeService = UniverseService();
      List<Widget> characterWidgets = [];
      for (var conversation in conversationsData) {
        final characterData =
            await characterService.getCharacter(conversation['character_id']);
        characterWidgets.add(
          _buildCharacterSquare(
            characterName: characterData['name'],
            imgCharacter: universeService
                .fetchUniverseImg(characterData['image'])
                .toString(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageScreen(
                    character: characterData,
                    conversation: conversationsData.isNotEmpty
                        ? conversationsData[0]
                        : {},
                  ),
                ),
              );
            },
          ),
        );
      }
      setState(() {
        characterWidgetsList = characterWidgets;
      });
    } on Exception catch (error) {
      print('Error fetching conversations: $error');
    }
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

  Future<void> _fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    print('test username $username');
    setState(() {
      userName = username;
    });
  }

  Widget _buildCharacterSquare({
    required String characterName,
    required String imgCharacter,
    String? universeName,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 130,
              height: 130,
              color: Colors.grey,
              child: Image.network(
                imgCharacter,
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.black,
                      size: 48.0,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              characterName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2.0),
            if (universeName != null)
              Text(universeName, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSquare({
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              color: Colors.grey,
              child: const Center(
                child: Text(
                  'User',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4.0),
          ],
        ),
      ),
    );
  }

  Widget _buildUniversSquare({
    required String universName,
    required String imgUniverse,
    required void Function(String) onPressed,
  }) {
    return InkWell(
      onTap: () => onPressed(universName),
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              color: Colors.grey,
              child: Image.network(
                imgUniverse,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.black,
                      size: 48.0,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              universName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Accueil',
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF9F5540),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://picsum.photos/150'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bonjour, $userName'),
              const SizedBox(height: 30),
              const Text(
                'Dernières conversations',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: characterWidgetsList,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text(
                    'Univers', // Titre
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UniversListScreen(),
                        ),
                      );
                    },
                    child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: universes
                      .map(
                        (universe) => _buildUniversSquare(
                          universName: universe['name'],
                          imgUniverse: UniverseService()
                              .fetchUniverseImg(universe['image'])
                              .toString(),
                          onPressed: (String universeName) {
                            final universeId = universe['id'];
                            if (universeId != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CharactersHomeScreen(
                                    universe: universe,
                                  ),
                                ),
                              );
                            } else {
                              print('Error: Universe ID not found');
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Liste utilisateurs',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                          height: 10), // Espacement entre le texte et le carré
                      _buildUserSquare(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserListScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
