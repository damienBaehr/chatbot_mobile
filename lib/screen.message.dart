import 'package:chatbot_filrouge/services/service.messages.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final Map<String, dynamic> character;
  final Map<String, dynamic> conversation;

  const MessageScreen({
    Key? key,
    required this.character,
    required this.conversation,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  late Future<List<Map<String, dynamic>>> _messagesFuture;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messagesFuture = _loadMessages();
  }

  Future<List<Map<String, dynamic>>> _loadMessages() async {
    try {
      final messages =
          await _messageService.getAllMessages(widget.conversation['id']);
      return messages.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error loading messages: $e');
      return [];
    }
  }

  void _sendMessage(String message) async {
    try {
      await _messageService.postMessage(widget.conversation['id'], message);
      _messagesFuture = _loadMessages();
      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Message avec ${widget.character['name']}',
          style: const TextStyle(
            fontSize: 30,
            color: Color(0xFF9F5540),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _messagesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final messages = snapshot.data ?? [];
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent);
                          });
                          return Column(
                            children: messages
                                .asMap()
                                .entries
                                .map((entry) =>
                                    _buildMessageBubble(entry.value, entry.key))
                                .toList(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  // Widget pour construire la bulle de message
  Widget _buildMessageBubble(Map<String, dynamic> message, int index) {
    final bool isSentByHuman = message['is_sent_by_human'] ?? false;
    final Color bubbleColor = isSentByHuman ? Colors.blue : Colors.green;
    final AlignmentGeometry alignment =
        isSentByHuman ? Alignment.centerLeft : Alignment.centerRight;

    final double borderRadiusTopLeft = isSentByHuman ? 12.0 : 0.0;
    final double borderRadiusTopRight = isSentByHuman ? 0.0 : 12.0;

    final bool isLastSentMessage =
        isSentByHuman && index == _messages.length - 1;

    return Column(
      children: [
        Align(
          alignment: alignment,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bubbleColor.withOpacity(0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadiusTopLeft),
                topRight: Radius.circular(borderRadiusTopRight),
                bottomLeft: const Radius.circular(12),
                bottomRight: const Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSentByHuman) const Icon(Icons.person),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message['content'] ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (!isSentByHuman) const Icon(Icons.person),
              ],
            ),
          ),
        ),
        if (isLastSentMessage)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadMessages();
            },
          ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Tapez votre message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final message = _messageController.text.trim();
              if (message.isNotEmpty) {
                _sendMessage(message);
              }
            },
          ),
        ],
      ),
    );
  }
}
