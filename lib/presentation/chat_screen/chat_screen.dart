import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:mmm_s_application3/core/utils/database_helper.dart';
import 'package:mmm_s_application3/core/utils/storage_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  List<ChatMessage> chatMessages = [];
  late ScrollController _scrollController;

  late DatabaseHelper dbHelper;
  late String currentUsername = '';

  FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String _recordPath = '';
  late String _selectedImagePath = '';

  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    dbHelper = DatabaseHelper();
    _audioRecorder.openRecorder();
    _loadData();
  }

  void _loadData() async {
    final String? storedJwtToken = await getToken('convoToken');
    if (storedJwtToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/getUserdetails'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': storedJwtToken}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          currentUsername = responseData['username'];
          print(currentUsername);
        });
      } else {
        print(
            'Failed to get username from backend. Status Code: ${response.statusCode}');
        // Handle the error case accordingly
        return;
      }
    }
    _loadSavedMessages();
    _startGenieConversation();
  }

  void _loadSavedMessages() async {
    print(currentUsername);
    List<Map<String, dynamic>> messages =
        await dbHelper.getMessages(currentUsername);
    setState(() {
      chatMessages = messages.map((map) {
        return ChatMessage(
          sender: map['sender'],
          message: map['message'],
          time: DateTime.parse(map['time']),
          audioPath: map['audio_path'],
          audioDuration: map['audio_duration'],
          imagePath:map['image_path']
        );
      }).toList();
    });
  }

  void dispose() {
    _scrollController.dispose();
    _audioRecorder.closeRecorder();

    super.dispose();
  }

  void _startGenieConversation() {
    // Show typing indicator initially
    setState(() {
      isLoading = true;
    });

    // Delay the appearance of the greeting message
    Future.delayed(Duration(seconds: 2), () {
      DateTime currentTime = DateTime.now();
      _addMessage(
        sender: 'advisor',
        message: 'Hi, I am Genie! How may I help you?',
        time: currentTime,
        isFinish: true
      );
        setState(() {
          isLoading = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: _buildAppBarTitle(),
        ),
        body: Column(
          children: [
            Divider(
              color: Colors.grey.shade300,
              thickness: 1.0,
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  return chatMessages[index];
                },
              ),
            ),
            isLoading
                ? _buildTypingIndicator()
                : SizedBox(), // Display typing indicator only when loading
            _buildUserInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF486AE4)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/img_advisor_image_1.png'),
              radius: 20,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Genie',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Academic Advisor',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ],
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'Option 1') {
              _clearChat();
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'Option 1',
              child: Row(
                children: [
                  Icon(Icons.chat),
                  SizedBox(width: 8),
                  Text('New Chat'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _clearChat() {
    // Show typing indicator
    setState(() {
      chatMessages.clear();
      isLoading = true;
    });

    // Delay the clearing of the chat and display a message
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        _addMessage(
          sender: 'advisor',
          message: 'Is there anything else I can help you with?',
          time: DateTime.now(),
          isFinish: true
        );
      });
    });
  }

  Widget _buildUserInput() {
    bool isLastMessageFromUser = chatMessages.isNotEmpty && chatMessages.last.sender == 'user';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFECECEC),
                borderRadius: BorderRadius.circular(17.0),
              ),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Enter your message...',
                  hintStyle: TextStyle(
                      color: Color(0xFF999999), fontWeight: FontWeight.w300),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.mic, color: Color(0xFF486AE4), size: 30.0),
            onPressed: isLastMessageFromUser ? null : _toggleRecording,
          ),
          IconButton(
            icon: Icon(Icons.image, color: Color(0xFF486AE4), size: 30.0),
            onPressed: isLastMessageFromUser ? null : _pickImage,
          ),
          IconButton(
            icon: Icon(Icons.send, color: Color(0xFF486AE4), size: 30.0),
            onPressed: isLastMessageFromUser ? null : _sendMessage, // Disable send button if the last message is from the user
          ),
        ],
      ),
    );
  }

  void _toggleRecording() async {
    if (!_isRecording) {
      var status = await Permission.microphone.request();
      if (status.isGranted) {
        await _startRecording();
      } else if (status.isDenied) {
        // Permission denied, show a dialog or message to the user
        // explaining why the permission is needed and ask for permission again
        // You can use the showDialog method to display a dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Permission Denied'),
              content:
                  Text('Please grant microphone permission to record audio.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Request permission again
                    _toggleRecording();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Handle denied permissions with permanently denied option
        openAppSettings();
      }
    } else {
      await _stopRecording();
    }
  }

  DateTime? _recordingStartTime;

  Future<void> _startRecording() async {
    try {
      _recordingStartTime = DateTime.now(); // Capture the start time
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = '${appDocDir.path}/message_recording_$timestamp.aac';

      await _audioRecorder.startRecorder(toFile: filePath);

      setState(() {
        _isRecording = true;
        _recordPath = filePath;
      });
    } catch (e) {
      print('Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    DateTime currentTime = DateTime.now();
    try {
      String? path = await _audioRecorder.stopRecorder();
      setState(() {
        _isRecording = false;
        _recordPath = path ?? '';
        isLoading = true; // Show typing indicator
      });

      // Check if the audioPath is not null
      if (_recordPath.isNotEmpty) {
        // Calculate the duration of the recorded audio
        int durationInMillis = DateTime.now().millisecondsSinceEpoch -
            (_recordingStartTime?.millisecondsSinceEpoch ?? 0);
        double durationInSeconds = durationInMillis / 1000;
        int roundedDuration = durationInSeconds
            .round(); // Round the duration to the nearest integer
        print('Duration of recording: $roundedDuration seconds');

        _addMessage(
          sender: 'user',
          message: '[Audio Message]',
          time: DateTime.now(),
          audioPath: _recordPath,
          audioDuration: roundedDuration,
          isFinish: true
        );

        // Encode the audio file as base64
        List<int> bytes = File(_recordPath).readAsBytesSync();
        String audioBase64 = base64Encode(bytes);
        print(audioBase64);

        // Construct the request body
        final String? storedJwtToken = await getToken('convoToken');

      String formattedTime = currentTime.toIso8601String();

      final socket = await WebSocket.connect('ws://10.0.2.2:8080');
      Map<String, dynamic> data = {
        'token': storedJwtToken,
        'audio': audioBase64,
        'time': formattedTime
      };
      socket.add(jsonEncode(data));

      socket.listen(
        (data) {
          if (data == "Message Finished!!@@"){
            socket.close();
          }

          setState(() {
              isLoading = false;
              _addMessage(
                sender: 'advisor',
                message: data,
                time: currentTime.add(Duration(minutes: 1)),
                isFinish: true
              );

        });

        }
      );

        // Clear the message controller and scroll to the bottom of the list
        setState(() {
          messageController.clear();
        });
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      print('Failed to stop recording: $e');
    }
  }

void _pickImage() async {
    DateTime currentTime = DateTime.now();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
        print(_selectedImagePath);
        _addMessage(
          sender: 'user',
          message: '', // Empty message for image
          time: DateTime.now(),
          imagePath: _selectedImagePath,
          isFinish: true,
        );
      });
      final File imageFile = File(pickedFile.path);
      final bytes = imageFile.readAsBytesSync();
      String base64Image = base64Encode(bytes);

      // Construct the request body
      final String? storedJwtToken = await getToken('convoToken');


      String formattedTime = currentTime.toIso8601String();

      final socket = await WebSocket.connect('ws://10.0.2.2:8080');
      Map<String, dynamic> data = {
        'token': storedJwtToken,
        'image': base64Image,
        'time': formattedTime
      };
      socket.add(jsonEncode(data));
      setState((){
        isLoading=true;
      });
      socket.listen(
        (data) {
          if (data == "Message Finished!!@@"){
            socket.close();
          }else{
            setState(() {
              isLoading = false;
              _addMessage(
                sender: 'advisor',
                message: data,
                time: currentTime.add(Duration(minutes: 1)),
                isFinish: true,
              );
          });
          }

          

        }
      );
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
//change 1 ended
  void _sendMessage() async {
    String message = messageController.text.trim();
    DateTime currentTime = DateTime.now();

    if (message.isNotEmpty) {
      messageController.clear();
      setState(() {
        isLoading = true; // Show typing indicator
        _addMessage(
          sender: 'user',
          message: message,
          time: currentTime,
          isFinish: true
        );
      });

      final String? storedJwtToken = await getToken('convoToken');

      String formattedTime = currentTime.toIso8601String();
      
      final socket = await WebSocket.connect('ws://10.0.2.2:8080');
      Map<String, dynamic> data = {
        'token': storedJwtToken,
        'message': message,
        'time': formattedTime
      };
      socket.add(jsonEncode(data));

      bool isComplete = false;
      socket.listen(
        (data) {

          if (data == "Message Finished!!@@"){
            isComplete = true;
            socket.close();
          }

          setState(() {
              isLoading = false;
              _addMessage(
                sender: 'advisor',
                message: data,
                time: currentTime.add(Duration(minutes: 1)),
                isFinish: isComplete
              );

        });
        }
      );

      // Scroll to the bottom of the list after a short delay
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  String fullMessage="";

  void _addMessage(
      {required String sender,
      required String message,
      required DateTime time,
      required bool isFinish,
      String? audioPath,
      int? audioDuration,
      String? imagePath})
       {
    if(message != "Message Finished!!@@"){
    setState(() {
    if (chatMessages.isNotEmpty &&
        chatMessages.last.sender == sender &&
        sender == 'advisor' && !isFinish) {
          final previousMessage = chatMessages.last;
          final updatedMessage = '${previousMessage.message}$message';
          fullMessage= updatedMessage;
          chatMessages[chatMessages.length - 1] = ChatMessage(
            sender: previousMessage.sender,
            message: updatedMessage,
            time: previousMessage.time,
            audioPath: previousMessage.audioPath,
            audioDuration: previousMessage.audioDuration,
            imagePath:previousMessage.imagePath,
          );
    } else {
      // Otherwise, add the message as a new chat message
      chatMessages.add(
        ChatMessage(
          sender: sender,
          message: message,
          time: time,
          audioPath: audioPath,
          audioDuration: audioDuration,
          imagePath: imagePath,
        ),
      );
      if(isFinish){
        dbHelper.insertMessage(sender, message, time.toString(), currentUsername,
        audioPath: audioPath, audioDuration: audioDuration, imagePath: imagePath);
      }
    }
  });
  }else{
        dbHelper.insertMessage(sender, fullMessage, time.toString(), currentUsername,
        audioPath: audioPath, audioDuration: audioDuration,imagePath: imagePath);
  }

    // Scroll to the bottom of the list if the scroll controller is attached
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });   
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage:
                AssetImage('assets/images/img_advisor_image_1.png'),
            radius: 20,
          ),
          SizedBox(width: 10), // Add spacing between avatar and "Typing"
          Text(
            'is typing',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(width: 5), // Add spacing between "Typing" and dots
          _buildDotsIndicator(), // Call a method to build the dots indicator
        ],
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      children: [
        Dot(),
        SizedBox(width: 4), // Adjust spacing between dots
        Dot(),
        SizedBox(width: 4), // Adjust spacing between dots
        Dot(),
      ],
    );
  }
}

class Dot extends StatefulWidget {
  @override
  _DotState createState() => _DotState();
}

class _DotState extends State<Dot> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true); // Repeat the animation indefinitely
  }

  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0.0, 0.5), // Move the dots vertically down
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      )),
      child: Container(
        width: 6, // Adjust the size of the dot
        height: 6, // Adjust the size of the dot
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String sender;
  final String message;
  final DateTime time;
  final String? audioPath;
  final int? audioDuration;
  final String? imagePath;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.time,
    this.audioPath,
    this.audioDuration,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    Color messageBackgroundColor =
        sender == 'user' ? Color(0xFF486AE4) : Color(0xFFDCDADA);
    Color messageTextColor =
        sender == 'user' ? Colors.white : Color(0xFF667085);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: sender == 'user'
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: sender == 'user'
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (sender == 'advisor')
                CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/img_advisor_image_1.png')),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: messageBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: audioPath != null
                    ? _buildAudioPlayer(context, audioDuration ?? 0)
                    : imagePath != null
                        ? Image.file(File(imagePath!))
                        : Text(
                            message,
                            style: TextStyle(
                              color: messageTextColor,
                            ),
                          ),
              ),
              if (sender == 'user')
                CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/user_image.png')),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              _formatTime(time),
              style: TextStyle(fontSize: 10.0, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer(BuildContext context, int audioDuration) {
    String durationString =
        '${(audioDuration ~/ 60).toString().padLeft(2, '0')}:${(audioDuration % 60).toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: () async {
        FlutterSoundPlayer audioPlayer = FlutterSoundPlayer();
        await audioPlayer.openPlayer();
        await audioPlayer.startPlayer(fromURI: audioPath!);
      },
      child: SizedBox(
        width: 180.0, // Set a specific width
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: Color(0xFF486AE4),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_arrow, color: Colors.white, size: 30.0),
              SizedBox(width: 4.0),
              Text(
                durationString,
                style: TextStyle(color: Colors.white, fontSize: 12.0),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat.Hm().format(time);
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatScreen(),
  ));
}
