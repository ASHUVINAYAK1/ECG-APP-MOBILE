import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a chat message. Each chat could be stored in a "chats" collection.
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String message,
  }) async {
    await _firestore.collection('chats').doc(chatId).collection('messages').add(
      {'senderId': senderId, 'message': message, 'timestamp': DateTime.now()},
    );
  }

  // Stream chat messages for a given chat.
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
