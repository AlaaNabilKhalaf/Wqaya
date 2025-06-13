part of 'chatbot_cubit.dart';

@immutable
sealed class ChatbotState {}

class ChatInitial extends ChatbotState {}

class ChatLoading extends ChatbotState {}

class ChatSuccess extends ChatbotState {
  final String answer;
  final List<String> sources;

  ChatSuccess({required this.answer, required this.sources});
}

class ChatError extends ChatbotState {
  final String message;

  ChatError({required this.message});
}