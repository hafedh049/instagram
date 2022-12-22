import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:fluttertoast/fluttertoast.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'constants.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key, required this.remoteData});
  final Map<String, dynamic> remoteData;
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List<types.Message> _messages = [];
  final _user = types.User(id: FirebaseAuth.instance.currentUser!.uid);
  late final _remoteUser;

  @override
  void initState() {
    super.initState();
    _remoteUser = types.User(id: widget.remoteData["uid"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FontAwesomeIcons.chevronLeft,
            size: 15,
            color: bgColor == Colors.white ? Colors.black : Colors.white,
          ),
        ),
        actions: [
          IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.video,
              size: 15,
              color: bgColor == Colors.white ? Colors.black : Colors.white,
            ),
          ),
          IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.phone,
              size: 15,
              color: bgColor == Colors.white ? Colors.black : Colors.white,
            ),
          ),
        ],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 15,
              backgroundColor: Colors.pinkAccent,
              backgroundImage: AssetImage("assets/hafedh.png"),
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "hafedh",
                  style: GoogleFonts.abel(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        bgColor == Colors.white ? Colors.black : Colors.white,
                  ),
                ),
                Text(
                  "Active now",
                  style: GoogleFonts.abel(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection(widget.remoteData["uid"])
            .orderBy("created_at", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                snapshot.data!.docs;
            _messages =
                data.map((QueryDocumentSnapshot<Map<String, dynamic>> e) {
              if ("audio" == e.get("type")) {
                return types.AudioMessage(
                  uri: e.get("uri"),
                  size: e.get("size") as num,
                  duration: Duration(milliseconds: e.get("duration")),
                  mimeType: e.get("mimetype"),
                  waveForm: <double>[
                    for (int i = 1; i <= 10; i++) i.toDouble()
                  ],
                  name: e.get("name"),
                  author: e.get("owner_id") == widget.remoteData["uid"]
                      ? _remoteUser
                      : _user,
                  id: e.get("message_id"),
                  createdAt: e.get("created_at"),
                  remoteId: widget.remoteData["uid"],
                  showStatus: true,
                  status: types.Status.delivered,
                  type: types.MessageType.audio,
                );
              } else if (e.get("type") == "custom") {
                return types.CustomMessage(
                  author: e.get("owner_id") == widget.remoteData["uid"]
                      ? _remoteUser
                      : _user,
                  id: e.get("message_id"),
                  createdAt: e.get("created_at"),
                  remoteId: widget.remoteData["uid"],
                  showStatus: true,
                  status: types.Status.delivered,
                  type: types.MessageType.custom,
                );
              } else if (e.get("type") == "file") {
                return types.FileMessage(
                  uri: e.get("file_uri"),
                  size: e.get("size") as num,
                  name: e.get("name"),
                  author: e.get("owner_id") == widget.remoteData["uid"]
                      ? _remoteUser
                      : _user,
                  id: e.get("file_id"),
                  createdAt: e.get("created_at"),
                  remoteId: widget.remoteData["uid"],
                  showStatus: true,
                  mimeType: e.get("mimeType"),
                  status: types.Status.delivered,
                  type: types.MessageType.file,
                );
              } else if (e.get("type") == "image") {
                return types.ImageMessage(
                  uri: e.get("image_uri"),
                  size: e.get("size"),
                  height: 300,
                  width: 200,
                  name: e.get("name"),
                  author: e.get("owner_id") == widget.remoteData["uid"]
                      ? _remoteUser
                      : _user,
                  id: e.get("image_id"),
                  createdAt: e.get("created_at"),
                  remoteId: widget.remoteData["uid"],
                  showStatus: true,
                  status: types.Status.delivered,
                  type: types.MessageType.image,
                );
              } else if (e.get("type") == "system") {
                return types.SystemMessage(
                  author: e.get("owner_id") == widget.remoteData["uid"]
                      ? _remoteUser
                      : _user,
                  id: e.get("message_id"),
                  text: e.get("message"),
                  createdAt: e.get("created_at"),
                  metadata: const <String, dynamic>{},
                  remoteId: widget.remoteData["uid"],
                  showStatus: true,
                  status: types.Status.delivered,
                  type: types.MessageType.system,
                );
              } else if (e.get("type") == "text") {
                return types.TextMessage(
                  author: e.get("owner_id") == widget.remoteData["uid"]
                      ? _remoteUser
                      : _user,
                  id: e.get("message_id"),
                  text: e.get("message"),
                  createdAt: e.get("created_at"),
                  remoteId: widget.remoteData["uid"],
                  showStatus: true,
                  status: types.Status.delivered,
                  type: types.MessageType.text,
                );
              } else if (e.get("type") == "video") {
                return types.VideoMessage(
                  uri: e.get("uri"),
                  size: e.get("size") as num,
                  height: 300,
                  width: 200,
                  name: e.get("name"),
                  author: e.get("owner_id") == widget.remoteData["uid"]
                      ? _remoteUser
                      : _user,
                  id: e.get("message_id"),
                  createdAt: e.get("created_at"),
                  remoteId: widget.remoteData["uid"],
                  showStatus: true,
                  status: types.Status.delivered,
                  type: types.MessageType.video,
                );
              } else {
                return types.UnsupportedMessage(
                  author: e.get("owner_id") == widget.remoteData["uid"]
                      ? _remoteUser
                      : _user,
                  id: e.get("message_id"),
                );
              }
            }).toList();
            return Chat(
              //isAttachmentUploading: true,
              scrollPhysics: const BouncingScrollPhysics(),
              isLastPage: true,
              theme: const DarkChatTheme(
                messageInsetsVertical: 10,
              ),
              useTopSafeAreaInset: true,
              bubbleRtlAlignment: BubbleRtlAlignment.left,
              messages: _messages,
              onAttachmentPressed: _handleAttachmentPressed,
              onMessageTap: _handleMessageTap,
              onSendPressed: _handleSendPressed,
              showUserAvatars: true,
              showUserNames: true,
              user: _user,
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else {
            Fluttertoast.showToast(msg: snapshot.error.toString());
            return Container();
          }
        },
      ),
    );
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                icon: Icon(
                  FontAwesomeIcons.photoFilm,
                  color: bgColor == Colors.white ? Colors.black : Colors.white,
                  size: 20,
                ),
              ),
              Container(
                color: Colors.grey,
                width: .5,
                height: 50,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                icon: Icon(
                  FontAwesomeIcons.fileImport,
                  color: bgColor == Colors.white ? Colors.black : Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowCompression: true,
        allowedExtensions: const <String>[
          "pdf",
          "txt",
          "doc",
          "xml",
          "csv",
        ]);
    if (result != null && result.files.single.path != null) {
      DateTime now = DateTime.now();
      Uint8List bytes = await File(result.files.first.path!).readAsBytes();
      List<String> l = [
        FirebaseAuth.instance.currentUser!.uid + widget.remoteData["uid"]
      ];
      l.sort();
      Fluttertoast.showToast(msg: "Uploading ...");
      await FirebaseStorage.instance
          .ref("chats_files/${l.toString()}")
          .child(now.millisecondsSinceEpoch.toString())
          .putData(bytes)
          .then(
        (TaskSnapshot ref) async {
          String uri = await ref.ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection("chats")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection(widget.remoteData["uid"])
              .doc(now.toString())
              .set(
            {
              "owner_id": FirebaseAuth.instance.currentUser!.uid,
              "file_uri": uri,
              "created_at": now.millisecondsSinceEpoch,
              "file_id": now.toString(),
              "name": result.files.single.name,
              "size": bytes.length,
              "type": "file",
              "mimeType": lookupMimeType(result.files.single.path!)
            },
          ).then(
            (value) async {
              await FirebaseFirestore.instance
                  .collection("chats")
                  .doc(widget.remoteData["uid"])
                  .collection(FirebaseAuth.instance.currentUser!.uid)
                  .doc(now.toString())
                  .set(
                {
                  "owner_id": FirebaseAuth.instance.currentUser!.uid,
                  "file_uri": uri,
                  "created_at": now.millisecondsSinceEpoch,
                  "file_id": now.toString(),
                  "name": result.files.single.name,
                  "size": bytes.length,
                  "type": "file",
                  "mimeType": lookupMimeType(result.files.single.path!)
                },
              ).then(
                (value) {
                  Fluttertoast.showToast(msg: "File uploading is done");
                },
              );
            },
          );
        },
      );
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 100,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      Uint8List bytes = await result.readAsBytes();
      List<String> l = [
        FirebaseAuth.instance.currentUser!.uid + widget.remoteData["uid"]
      ];
      l.sort();
      DateTime now = DateTime.now();
      Fluttertoast.showToast(msg: "Uploading ...");
      await FirebaseStorage.instance
          .ref("chats_files/${l.toString()}")
          .child(now.millisecondsSinceEpoch.toString())
          .putData(bytes)
          .then(
        (TaskSnapshot ref) async {
          String uri = await ref.ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection("chats")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection(widget.remoteData["uid"])
              .doc(now.toString())
              .set(
            {
              "owner_id": FirebaseAuth.instance.currentUser!.uid,
              "image_uri": uri,
              "created_at": now.millisecondsSinceEpoch,
              "image_id": now.toString(),
              "name": result.name,
              "size": bytes.length,
              "type": "image",
            },
          ).then(
            (value) async {
              await FirebaseFirestore.instance
                  .collection("chats")
                  .doc(widget.remoteData["uid"])
                  .collection(FirebaseAuth.instance.currentUser!.uid)
                  .doc(now.toString())
                  .set(
                {
                  "owner_id": FirebaseAuth.instance.currentUser!.uid,
                  "image_uri": uri,
                  "created_at": now.millisecondsSinceEpoch,
                  "image_id": now.toString(),
                  "name": result.name,
                  "size": bytes.length,
                  "type": "image",
                },
              ).then(
                (value) {
                  Fluttertoast.showToast(msg: "Picture Uploading is done");
                },
              );
            },
          );
        },
      );
    }
  }

  void _handleSendPressed(types.PartialText message) async {
    DateTime now = DateTime.now();
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(widget.remoteData["uid"])
        .doc(now.toString())
        .set(
      {
        "owner_id": FirebaseAuth.instance.currentUser!.uid,
        "message_id": now.toString(),
        "message": message.text,
        "created_at": now.millisecondsSinceEpoch,
        "type": "text"
      },
    ).then((value) async {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(widget.remoteData["uid"])
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .doc(now.toString())
          .set(
        {
          "owner_id": FirebaseAuth.instance.currentUser!.uid,
          "message_id": now.toString(),
          "message": message.text,
          "created_at": now.millisecondsSinceEpoch,
          "type": "text"
        },
      ).then((value) {});
    });
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;
      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          _messages[index] = updatedMessage;

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          _messages[index] = updatedMessage;
        }
      }
      Fluttertoast.showToast(msg: "Opening file ...");
      await OpenFilex.open(localPath);
    }
  }
}
