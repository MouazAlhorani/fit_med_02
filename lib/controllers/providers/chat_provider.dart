import 'package:fit_medicine_02/models/chatitem_model.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatitemModel> _chatitems = [];
  ChatProvider(List<ChatitemModel> chatitems) {
    _chatitems = chatitems;
  }
  List<ChatitemModel> get chatitmes => _chatitems;
}
