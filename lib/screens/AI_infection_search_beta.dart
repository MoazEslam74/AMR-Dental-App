import 'dart:convert';
import 'package:eda_pharma/data/infection_data.dart';
import 'package:eda_pharma/screens/webView_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:eda_pharma/model/infection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';

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
    databaseId: 'default',
  );
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final String _apiUrl = 'https://medical-diagnostic-agent-two.vercel.app/chat';
  
  List<String> _accumulatedSymptoms = [];
  String? _lastAskedSymptom;
  
  final Color bgColor = const Color(0xFFF4F7FC);
  final Color primaryBlue = const Color(0xFF1976D2);
  final Color darkText = const Color(0xFF102A43);

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    setState(() {
      _isTyping = true;
    });

    try {
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

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_message': text,
          'session_id': widget.sessionId,
          'accumulated_symptoms': _accumulatedSymptoms,
          'last_asked_symptom': _lastAskedSymptom,
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        
        setState(() {
          _accumulatedSymptoms = List<String>.from(decodedResponse['accumulated_symptoms'] ?? []);
          _lastAskedSymptom = decodedResponse['last_asked_symptom'];
        });
        
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

  // --- الدالة الجديدة: مسح المحادثة بالكامل وبدء واحدة جديدة ---
  Future<void> _startNewChat() async {
    setState(() {
      _isTyping = true;
    });
    
    try {
      // 1. تصفير الذاكرة المحلية (المتغيرات)
      _accumulatedSymptoms.clear();
      _lastAskedSymptom = null;

      // 2. مسح جميع الرسائل من قاعدة البيانات Firestore
      final messagesRef = _firestore
          .collection('chat_sessions')
          .doc(widget.sessionId)
          .collection('messages');
          
      final snapshots = await messagesRef.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      _showError('Failed to clear chat: $e');
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }
  // -------------------------------------------------------------

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent),
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

  Widget _buildDiagnosisCard(String? diseaseId) {
    if (diseaseId == null) return const SizedBox.shrink();

    final infection = infections_data.firstWhere(
      (inf) => inf.id == diseaseId,
      orElse: () => infections_data[0], 
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.medical_information_rounded, color: primaryBlue, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    infection.name, 
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkText),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () async {
                    final query = Uri.encodeComponent(infection.name);
                    final url = 'https://www.google.com/search?tbm=isch&q=$query';
                    if (Theme.of(context).platform == TargetPlatform.android) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(url: url),
                        ),
                      );
                    } else {
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      }
                    }
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.image_search, color: primaryBlue, size: 24),
                  ),
                  tooltip: 'View Images',
                ),                
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(color: Color(0xFFE0E5EC), thickness: 1.5),
            ),
            _buildDiagnosisRow("Causing Agent", infection.causingAgent),
            const SizedBox(height: 12),
            _buildDiagnosisRow("Symptoms", infection.symptoms.join(', ')),
            const SizedBox(height: 12),
            _buildDiagnosisRow("Treatment", infection.treatment),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisRow(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, 
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryBlue, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          content, 
          style: const TextStyle(color: Colors.black87, fontSize: 15, height: 1.4),
        ),
      ],
    );
  }

  // --- زر New Chat بالتصميم العصري ---
  Widget _buildNewChatButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: _startNewChat,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
            shadowColor: primaryBlue.withOpacity(0.4),
          ),
          icon: const Icon(Icons.refresh_rounded, size: 22),
          label: const Text(
            'Start New Diagnosis',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0, 
        iconTheme: IconThemeData(color: darkText),
        title: Text(
          'AI Medical Assistant',
          style: TextStyle(color: darkText, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'BETA', 
                style: TextStyle(fontWeight: FontWeight.bold, color: primaryBlue, fontSize: 12),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
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
                    return Center(child: CircularProgressIndicator(color: primaryBlue));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, size: 60, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text('Start describing your symptoms...', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                        ],
                      ),
                    );
                  }

                  var messages = snapshot.data!.docs;
                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var msg = messages[index].data() as Map<String, dynamic>;
                      bool isUser = msg['sender'] == 'user';
                      String text = msg['text'] ?? '';
                      String? action = msg['action'];
                      String? diseaseId = msg['disease_id'];
                      
                      // متغير للتحقق مما إذا كانت هذه هي الرسالة الأخيرة في القائمة
                      bool isLastMessage = index == messages.length - 1;

                      return Column(
                        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            decoration: BoxDecoration(
                              color: isUser ? primaryBlue : Colors.white,
                              boxShadow: isUser ? [] : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomLeft: Radius.circular(isUser ? 20 : 4),
                                bottomRight: Radius.circular(isUser ? 4 : 20),
                              ),
                            ),
                            child: Text(
                              text, 
                              style: TextStyle(
                                fontSize: 16, 
                                height: 1.4,
                                color: isUser ? Colors.white : darkText,
                              ),
                            ),
                          ),
                          
                          // عرض بطاقة التشخيص
                          if (!isUser && action == 'diagnose') _buildDiagnosisCard(diseaseId),
                          
                          // إظهار زر "بدء تشخيص جديد" فقط بعد بطاقة التشخيص الأخيرة
                          if (isLastMessage && !isUser && action == 'diagnose') 
                            _buildNewChatButton(),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: Row(
                  children: [
                    SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: primaryBlue)),
                    const SizedBox(width: 12),
                    Text("AI is analyzing...", style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03), 
                    blurRadius: 15, 
                    offset: const Offset(0, -5),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      style: TextStyle(color: darkText),
                      decoration: InputDecoration(
                        hintText: 'Type your symptoms...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: bgColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _isTyping ? null : _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _isTyping ? Colors.grey.shade300 : primaryBlue,
                        shape: BoxShape.circle,
                        boxShadow: _isTyping ? [] : [
                          BoxShadow(color: primaryBlue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                        ]
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}