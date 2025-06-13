import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'chatbot_state.dart';

class ChatCubit extends Cubit<ChatbotState> {
  ChatCubit() : super(ChatInitial());

  final Dio _dio = Dio();

  Future<void> sendMessage(String question) async {
    if (question.trim().isEmpty) return;

    emit(ChatLoading());

    try {
      // Configure DIO with timeout and headers
      _dio.options = BaseOptions(
        connectTimeout: const Duration(seconds: 90),
        receiveTimeout: const Duration(seconds: 90),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true', // Skip ngrok warning
        },
      );

      const String apiUrl = 'https://a1c7-156-203-212-77.ngrok-free.app/ask';

      final response = await _dio.post(
        apiUrl,
        data: {
          'question': question,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final String answer = data['answer'] ?? 'No answer received';
        final List<String> sources = List<String>.from(data['sources'] ?? []);

        emit(ChatSuccess(answer: answer, sources: sources));
      } else {
        emit(ChatError(message: 'Server error: ${response.statusCode}'));
      }

    } on DioException catch (e) {
      String errorMessage = 'An error occurred';
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage = 'Connection timeout. Please check your internet connection.';
          break;
        case DioExceptionType.badResponse:
          errorMessage = 'Server error: ${e.response?.statusCode}';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'Connection failed. Please check your internet connection.';
          break;
        case DioExceptionType.cancel:
          errorMessage = 'Request was cancelled.';
          break;
        default:
          errorMessage = 'Network error: ${e.message}';
      }

      emit(ChatError(message: errorMessage));
    } catch (e) {
      emit(ChatError(message: 'Unexpected error: $e'));
    }
  }

  void resetChat() {
    emit(ChatInitial());
  }
}
