import 'dart:convert';
import 'package:eda_pharma/data/infection_data.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:eda_pharma/model/infection.dart';
import 'package:firebase_core/firebase_core.dart';

class BetaChatScreen extends StatefulWidget {
  final String sessionId;

  const BetaChatScreen({Key? key, required this.sessionId}) : super(key: key);

  @override
  _BetaChatScreenState createState() => _BetaChatScreenState();
}

class _BetaChatScreenState extends State<BetaChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
  app: Firebase.app(),
  databaseId: 'default', // هنا نجبر التطبيق على البحث عن الاسم بدون أقواس
);
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false; // لإظهار مؤشر التحميل أثناء انتظار الـ API

  // رابط Vercel الخاص بك
  final String _apiUrl = 'https://medical-diagnostic-agent-two.vercel.app/chat';

  // دالة إرسال الرسالة إلى Firestore ثم إلى الـ API
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    setState(() {
      _isTyping = true;
    });

    try {
      // 1. حفظ رسالة المستخدم في Firestore
      await _firestore
          .collection('chat_sessions')
          .doc(widget.sessionId)
          .collection('messages')
          .add({
        'text': text,
        'sender': 'user',
        'timestamp': FieldValue.serverTimestamp(),
      });

      _scrollToBottom();

      // 2. إرسال الطلب إلى Vercel API
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_message': text,
          'session_id': widget.sessionId,
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        
        // 3. حفظ رد الـ Agent في Firestore
        await _firestore
            .collection('chat_sessions')
            .doc(widget.sessionId)
            .collection('messages')
            .add({
          'text': decodedResponse['agent_reply'] ?? '',
          'sender': 'agent',
          'action': decodedResponse['action'],
          'disease_id': decodedResponse['disease_id'],
          'timestamp': FieldValue.serverTimestamp(),
        });
        
        _scrollToBottom();
      } else {
        _showError('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Connection Exception: $e');
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  // دالة لبناء بطاقة المرض
  Widget _buildDiagnosisCard(String? diseaseId) {
    if (diseaseId == null) return const SizedBox.shrink();

    // البحث عن المرض في قائمة infections_data
    final infection = infections_data.firstWhere(
      (inf) => inf.id == diseaseId,
      orElse: () => infections_data[0], 
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medical_services, color: Colors.blue, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    infection.name, // سيطبع اسم المرض مثل Dental caries[cite: 2]
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
            const Divider(),
            Text("Causing Agent: ${infection.causingAgent}", style: const TextStyle(fontWeight: FontWeight.w600)), // طباعة المسبب[cite: 2]
            const SizedBox(height: 8),
            Text("Symptoms: ${infection.symptoms.join(', ')}", style: const TextStyle(color: Colors.black87)), // طباعة الأعراض[cite: 2]
            const SizedBox(height: 8),
            const Text("Treatment:", style: TextStyle(fontWeight: FontWeight.w600)),
            Text(infection.treatment, style: const TextStyle(color: Colors.black87)), // طباعة العلاج[cite: 2]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beta Chat - Medical Agent'),
        backgroundColor: Colors.teal,
        actions: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(child: Text('BETA', style: TextStyle(fontWeight: FontWeight.bold))),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chat_sessions')
                  .doc(widget.sessionId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Start describing your symptoms...', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  );
                }

                var messages = snapshot.data!.docs;
                
                // تمرير الشاشة للأسفل عند وصول بيانات جديدة
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var msg = messages[index].data() as Map<String, dynamic>;
                    bool isUser = msg['sender'] == 'user';
                    String text = msg['text'] ?? '';
                    String? action = msg['action'];
                    String? diseaseId = msg['disease_id'];

                    return Column(
                      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.teal.shade100 : Colors.grey.shade200,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isUser ? 16 : 0),
                              bottomRight: Radius.circular(isUser ? 0 : 16),
                            ),
                          ),
                          child: Text(text, style: const TextStyle(fontSize: 16)),
                        ),
                        
                        // عرض بطاقة التشخيص إذا كان القرار نهائياً
                        if (!isUser && action == 'diagnose') _buildDiagnosisCard(diseaseId),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          
          // عرض مؤشر التحميل أثناء انتظار رد الخادم
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  SizedBox(width: 16),
                  SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 8),
                  Text("Agent is typing...", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            
          // حقل إدخال النص
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, blurRadius: 4, offset: const Offset(0, -2))
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Type your symptoms here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: _isTyping ? Colors.grey : Colors.teal,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _isTyping ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}