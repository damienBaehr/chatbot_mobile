import 'package:chatbot_filrouge/screen.message.dart';
import 'package:chatbot_filrouge/services/service.characters.dart';
import 'package:chatbot_filrouge/services/service.conversations.dart';
import 'package:chatbot_filrouge/services/service.univers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterDescScreen extends StatefulWidget {
  final Map<String, dynamic> character;

  const CharacterDescScreen({Key? key, required this.character})
      : super(key: key);

  @override
  _CharacterDescScreenState createState() => _CharacterDescScreenState();
}

class _CharacterDescScreenState extends State<CharacterDescScreen> {
  final CharacterService characterService = CharacterService();
  final ConversationService conversationService = ConversationService();

  Future<void> _startConversation() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('userId');
      print('Retrieved userId: $userId');
      if (userId != null) {
        final conversation = await conversationService.startConversation(
            widget.character['id'], userId);
        // Si la conversation est créée avec succès, redirigez vers l'écran des messages en passant l'objet de la conversation
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageScreen(
              character: widget.character,
              conversation: conversation,
            ),
          ),
        );
        print('Conversation started: $conversation');
      } else {
        throw Exception('User ID not found');
      }
    } catch (e) {
      print('Failed to start conversation: $e');
    }
  }

  Future<void> _updateCharacter() async {
    try {
      await characterService.updateCharacterById(
        widget.character['universe_id'],
        widget.character['id'],
      );
    } catch (e) {
      print('Failed to update character: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final universeService = UniverseService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Personnage ${widget.character['name']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: _startConversation,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _updateCharacter,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.network(
                universeService
                    .fetchUniverseImg(widget.character['image'])
                    .toString(),
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200.0,
                    height: 200.0,
                    color: Colors
                        .grey, // Couleur de secours en cas d'erreur de chargement
                    child: const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 48.0,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text('Nom : ${widget.character['name']}'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Description: ${widget.character['description']}'),
            ),
          ],
        ),
      ),
    );
  }
}
