import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:kechi/shared/theme/theme.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;

  // Enhanced color scheme
  final Color _primaryColor = AppTheme.primaryColor;
  final Color _secondaryColor = AppTheme.secondaryColor;
  final Color _backgroundColor = AppTheme.backgroundColor;
  final Color _cardColor = Colors.white;
  final Color _accentColor = const Color(0xFF6C5CE7);

  // Sample data for chat profiles
  final List<ChatProfile> _chatProfiles = [
    ChatProfile(
      id: "user1",
      name: "Sophia Chen",
      lastMessage: "Hey! How's the project coming along?",
      time: "10:45 AM",
      imageUrl: "https://randomuser.me/api/portraits/women/12.jpg",
      unreadCount: 2,
      isOnline: true,
      messages: [], // Empty list - will be populated with user messages only
    ),
    ChatProfile(
      id: "user2",
      name: "Marcus Johnson",
      lastMessage: "I've sent you the project files",
      time: "9:30 AM",
      imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
      unreadCount: 0,
      isOnline: true,
      messages: [],
    ),
    ChatProfile(
      id: "user3",
      name: "Leila Patel",
      lastMessage: "Thanks for your help yesterday!",
      time: "Yesterday",
      imageUrl: "https://randomuser.me/api/portraits/women/45.jpg",
      unreadCount: 0,
      isOnline: false,
      messages: [],
    ),
    ChatProfile(
      id: "user4",
      name: "Daniel Kim",
      lastMessage: "Let me know when you're free to chat",
      time: "Yesterday",
      imageUrl: "https://randomuser.me/api/portraits/men/67.jpg",
      unreadCount: 3,
      isOnline: false,
      messages: [],
    ),
    ChatProfile(
      id: "user5",
      name: "Olivia Smith",
      lastMessage: "Check out this new design I made",
      time: "Tuesday",
      imageUrl: "https://randomuser.me/api/portraits/women/22.jpg",
      unreadCount: 0,
      isOnline: true,
      messages: [],
    ),
    ChatProfile(
      id: "user6",
      name: "James Wilson",
      lastMessage: "Do you have time for a quick call?",
      time: "Monday",
      imageUrl: "https://randomuser.me/api/portraits/men/55.jpg",
      unreadCount: 0,
      isOnline: false,
      messages: [],
    ),
  ];

  bool _isInActiveChat = false;
  ChatProfile? _activeProfile;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _openChat(ChatProfile profile) {
    setState(() {
      _isInActiveChat = true;
      _activeProfile = profile;
      // Reset unread count when opening the chat
      profile.unreadCount = 0;
    });

    _animationController.forward(from: 0.0);

    // Scroll to bottom of chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty && _activeProfile != null) {
      // Create timestamp for the message
      final now = DateTime.now();
      final formattedTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      final newMessage = ChatMessage(
        text: _messageController.text.trim(),
        timestamp: formattedTime,
        senderId:
            "current_user", // This will be replaced with actual user ID from auth
        recipientId: _activeProfile!.id,
      );

      setState(() {
        // Add message to the active profile's message list
        _activeProfile!.messages.add(newMessage);

        // Update the last message preview in the chat list
        // In real app, this would be the last message from either user or recipient
        _activeProfile!.lastMessage = "You: ${_messageController.text.trim()}";
        _activeProfile!.time = "Just now";

        _messageController.clear();
      });

      // Scroll to bottom after sending a message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.light,
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.light(
          primary: _primaryColor,
          secondary: _accentColor,
        ),
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          backgroundColor: _cardColor,
          elevation: 0,
          centerTitle: false,
          title: _isInActiveChat
              ? _chatAppBar()
              : const Text(
                  "Messages",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: -0.5,
                  ),
                ),
          titleTextStyle: TextStyle(
            color: _secondaryColor,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: _secondaryColor),
              onPressed: () {},
            ),
            if (_isInActiveChat)
              IconButton(
                icon: Icon(Icons.more_vert, color: _secondaryColor),
                onPressed: () {},
              ),
          ],
          leading: _isInActiveChat
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: _secondaryColor),
                  onPressed: () {
                    _animationController.reverse().then((_) {
                      setState(() {
                        _isInActiveChat = false;
                        _activeProfile = null;
                      });
                    });
                  },
                )
              : null,
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _isInActiveChat ? _buildChatScreen() : _buildChatListScreen(),
        ),
      ),
    );
  }

  Widget _chatAppBar() {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(_activeProfile!.imageUrl),
                radius: 20,
              ),
            ),
            if (_activeProfile!.isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[400],
                    shape: BoxShape.circle,
                    border: Border.all(color: _cardColor, width: 2),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _activeProfile!.name,
              style: TextStyle(
                color: _secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              _activeProfile!.isOnline ? "Online" : "Offline",
              style: TextStyle(
                color: _activeProfile!.isOnline
                    ? Colors.greenAccent[400]
                    : Colors.grey,
                fontSize: 12,
                fontWeight: _activeProfile!.isOnline
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChatListScreen() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          color: _cardColor,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search messages...",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon:
                  Icon(Icons.search, color: _primaryColor.withOpacity(0.7)),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: _primaryColor.withOpacity(0.5)),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: _backgroundColor,
          child: Row(
            children: [
              Text(
                "Recent Chats",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _secondaryColor,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                icon: Icon(Icons.filter_list, size: 18, color: _primaryColor),
                label: Text(
                  "Filter",
                  style: TextStyle(color: _primaryColor),
                ),
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _chatProfiles.length,
            itemBuilder: (context, index) {
              return _buildChatProfileItem(_chatProfiles[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatProfileItem(ChatProfile profile) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: InkWell(
        onTap: () => _openChat(profile),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Hero(
                      tag: "avatar-${profile.id}",
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(profile.imageUrl),
                        radius: 28,
                      ),
                    ),
                  ),
                  if (profile.unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.5),
                              blurRadius: 6,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Center(
                          child: Text(
                            profile.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (profile.isOnline)
                    Positioned(
                      right: 3,
                      bottom: 3,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent[400],
                          shape: BoxShape.circle,
                          border: Border.all(color: _cardColor, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          profile.name,
                          style: TextStyle(
                            fontWeight: profile.unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 16,
                            color: _secondaryColor,
                          ),
                        ),
                        Text(
                          profile.time,
                          style: TextStyle(
                            color: profile.unreadCount > 0
                                ? _primaryColor
                                : Colors.grey,
                            fontSize: 12,
                            fontWeight: profile.unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      profile.lastMessage,
                      style: TextStyle(
                        color: profile.unreadCount > 0
                            ? _secondaryColor
                            : Colors.grey[600],
                        fontWeight: profile.unreadCount > 0
                            ? FontWeight.w500
                            : FontWeight.normal,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatScreen() {
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        image: DecorationImage(
          image: NetworkImage(
              "https://www.transparenttextures.com/patterns/subtle-white-feathers.png"),
          repeat: ImageRepeat.repeat,
          opacity: 0.3,
        ),
      ),
      child: Column(
        children: [
          // Initial message bubble from recipient
          FadeTransition(
            opacity: _animationController,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.1),
                end: Offset.zero,
              ).animate(_animationController),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Hero(
                      tag: "avatar-${_activeProfile!.id}",
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(_activeProfile!.imageUrl),
                        radius: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _activeProfile!.lastMessage,
                            style: TextStyle(
                              color: _secondaryColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _activeProfile!.time,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // User messages area
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: _activeProfile?.messages.length ?? 0,
                itemBuilder: (context, index) {
                  return _buildMessageItem(
                      _activeProfile!.messages[index], index);
                },
              ),
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message, int index) {
    // Only show user message bubbles (sent from current user)
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.2, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5 + (index * 0.1).clamp(0.0, 0.5), 1.0,
            curve: Curves.easeOut),
      )),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.5 + (index * 0.1).clamp(0.0, 0.5), 1.0,
              curve: Curves.easeOut),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primaryColor, _accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.timestamp,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  radius: 16,
                  child: const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInputField() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
            border: Border(
              top: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: _primaryColor),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.photo, color: _primaryColor),
                onPressed: () {},
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryColor, _accentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatProfile {
  final String id; // Unique identifier for each chat user
  final String name; // Display name
  String lastMessage; // Preview message shown in chat list
  String time; // Timestamp shown in chat list
  final String imageUrl; // User avatar
  int unreadCount; // Number of unread messages
  final bool isOnline; // Online status
  List<ChatMessage> messages; // List of messages (user-sent only for now)

  ChatProfile({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.imageUrl,
    required this.unreadCount,
    required this.isOnline,
    required this.messages,
  });
}

class ChatMessage {
  final String text; // Message content
  final String timestamp; // Time the message was sent
  final String senderId; // ID of sender (will be current user in this UI)
  final String recipientId; // ID of recipient

  ChatMessage({
    required this.text,
    required this.timestamp,
    required this.senderId,
    required this.recipientId,
  });
}
