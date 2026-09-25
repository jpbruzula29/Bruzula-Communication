import 'package:flutter/material.dart';

void main() {
  runApp(const BruzulaApp());
}

class BruzulaApp extends StatelessWidget {
  const BruzulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bruzula Communication',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B7065)),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}

// ---------------- AUTHENTICATION SCREEN ----------------
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signIn() {
    if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainChatScreen(memberName: _nameController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name and email address')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, size: 64, color: Color(0xFF5B7065)),
              const SizedBox(height: 12),
              const Text(
                'Bruzula Communication',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C3E35)),
              ),
              const Text('Family Safety & Connection', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Family Member Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Create Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B7065),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _signIn,
                  child: const Text('Enter Family Circle', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- MAIN CHAT & FLOATING CHAT HEAD SCREEN ----------------
class MainChatScreen extends StatefulWidget {
  final String memberName;
  const MainChatScreen({super.key, required this.memberName});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  bool _isChatHeadOpen = false;
  Offset _chatHeadPosition = const Offset(20, 150);
  final List<Map<String, String>> _messages = [
    {'sender': 'Family Bot', 'text': 'Welcome to Bruzula Communication!'},
  ];
  final _msgController = TextEditingController();

  void _sendMessage() {
    if (_msgController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({'sender': widget.memberName, 'text': _msgController.text.trim()});
        _msgController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bruzula Family (${widget.memberName})'),
        backgroundColor: const Color(0xFF5B7065),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Background Content
          ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              Card(
                child: ListTile(
                  leading: Icon(Icons.location_on, color: Colors.green),
                  title: Text('Live GPS Status'),
                  subtitle: Text('Location sharing active.'),
                ),
              ),
            ],
          ),

          // Floating Chat Head (Bubble)
          Positioned(
            left: _chatHeadPosition.dx,
            top: _chatHeadPosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _chatHeadPosition += details.delta;
                });
              },
              onTap: () {
                setState(() {
                  _isChatHeadOpen = !_isChatHeadOpen;
                });
              },
              child: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF5B7065),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.chat_bubble, color: Colors.white, size: 28),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text('${_messages.length}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expanded Chat Window
          if (_isChatHeadOpen)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              height: 400,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF5B7065),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Bruzula Family Chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => setState(() => _isChatHeadOpen = false),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          final isMe = msg['sender'] == widget.memberName;
                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isMe ? const Color(0xFF5B7065) : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${msg['sender']}: ${msg['text']}',
                                style: TextStyle(color: isMe ? Colors.white : Colors.black),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _msgController,
                              decoration: const InputDecoration(
                                hintText: 'Type a message...',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send, color: Color(0xFF5B7065)),
                            onPressed: _sendMessage,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
