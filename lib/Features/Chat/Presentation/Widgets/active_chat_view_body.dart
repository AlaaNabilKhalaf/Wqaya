import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import '../../../../Core/utils/assets_data.dart';
import 'chat_text_field.dart';

class ActiveChatViewBody extends StatefulWidget {
  const ActiveChatViewBody({super.key});

  @override
  State<ActiveChatViewBody> createState() => _ActiveChatViewBodyState();
}

class _ActiveChatViewBodyState extends State<ActiveChatViewBody> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  //Function This is Sending Requests
  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _messages.add({"user": _controller.text});
      _messages.add({"bot": _getBotResponse(_controller.text)});
      _controller.clear();
    });
  }

  //Function This is Getting Responds

  String _getBotResponse(String message) {
    return "I'm here to help! Ask me anything.";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AssetsData.chatIcon,height: 90.h,width: 190.w,),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              String sender = _messages[index].keys.first;
              String message = _messages[index][sender]!;
              bool isUser = sender == "user";
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue : const Color(0xFFF2F4F5),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: isUser ? myWhiteColor : primaryColor, fontFamily: medium,fontSize: 16.sp),
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
                child: SizedBox(
                  height: 55.sp,
                  child: ChatTextField(fieldController: _controller,),
                ),
              ),
              // GestureDetector(
              //     onTap: _sendMessage,
              //     child: Image.asset(AssetsData.sendIcon)),

              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue ,size: 35,),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}