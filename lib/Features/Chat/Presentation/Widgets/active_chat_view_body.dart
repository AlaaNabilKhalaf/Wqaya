import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wqaya/Core/Utils/colors.dart';
import 'package:wqaya/Core/Utils/fonts.dart';
import 'package:wqaya/Features/Chat/Presentation/Views/view_model/chatbot_cubit.dart';
import '../../../../Core/utils/assets_data.dart';
import 'chat_text_field.dart';

class ActiveChatViewBody extends StatefulWidget {
  const ActiveChatViewBody({super.key});

  @override
  State<ActiveChatViewBody> createState() => _ActiveChatViewBodyState();
}

class _ActiveChatViewBodyState extends State<ActiveChatViewBody> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text.trim();
    setState(() {
      _messages.add({
        "type": "user",
        "message": userMessage,
        "timestamp": DateTime.now(),
      });
    });

    // Send message through cubit
    context.read<ChatCubit>().sendMessage(userMessage);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
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

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          Image.asset(AssetsData.chatIcon, height: 90.h, width: 190.w),
          Expanded(
            child: BlocListener<ChatCubit, ChatbotState>(
              listener: (context, state) {
                if (state is ChatSuccess) {
                  setState(() {
                    _messages.add({
                      "type": "bot",
                      "message": state.answer,
                      "sources": state.sources,
                      "timestamp": DateTime.now(),
                    });
                  });
                  _scrollToBottom();
                } else if (state is ChatError) {
                  setState(() {
                    _messages.add({
                      "type": "error",
                      "message": state.message,
                      "timestamp": DateTime.now(),
                    });
                  });
                  _scrollToBottom();
                }
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final type = message["type"];
                        final content = message["message"];

                        bool isUser = type == "user";
                        bool isError = type == "error";

                        return Align(
                          alignment: isUser
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? Colors.blue
                                  : isError
                                      ? Colors.red.shade100
                                      : const Color(0xFFF2F4F5),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  content,
                                  style: TextStyle(
                                    color: isUser
                                        ? myWhiteColor
                                        : isError
                                            ? Colors.red.shade700
                                            : primaryColor,
                                    fontFamily: medium,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  BlocBuilder<ChatCubit, ChatbotState>(
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  backgroundColor: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Thinking ...",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontFamily: medium,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55.sp,
                    child: ChatTextField(fieldController: _controller),
                  ),
                ),
                BlocBuilder<ChatCubit, ChatbotState>(
                  builder: (context, state) {
                    bool isLoading = state is ChatLoading;
                    return IconButton(
                      icon: Icon(
                        isLoading ? Icons.hourglass_empty : Icons.send,
                        color: isLoading ? Colors.grey : Colors.blue,
                        size: 35,
                      ),
                      onPressed: isLoading ? null : _sendMessage,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
