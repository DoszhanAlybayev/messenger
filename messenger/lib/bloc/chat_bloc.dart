// lib/bloc/chat/chat_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:messenger/bloc/chat_event.dart';
import 'package:messenger/bloc/chat_state.dart';
import 'package:messenger/models/message.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
  }

  // Статический список сообщений для имитации чата
  final List<Message> _messages = [
    Message(text: 'Привет!', sender: 'Анна', timestamp: DateTime.now()),
    Message(text: 'Как дела?', sender: 'Я', timestamp: DateTime.now()),
  ];

  // Метод для обработки события LoadMessages
  void _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) {
    emit(ChatLoaded(_messages));
  }

  // Метод для обработки события SendMessage
  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    // В зависимости от текущего состояния, создаем новый список сообщений
    if (state is ChatInitial) {
      final List<Message> initialMessages = List.from(_messages);
      initialMessages.add(
        Message(
          text: event.text,
          sender: 'Я', // Отправитель - текущий пользователь
          timestamp: DateTime.now(),
        ),
      );
      emit(ChatLoaded(initialMessages));
    } else if (state is ChatLoaded) {
      final List<Message> updatedMessages = List.from((state as ChatLoaded).messages);
      updatedMessages.add(
        Message(
          text: event.text,
          sender: 'Я', // Отправитель - текущий пользователь
          timestamp: DateTime.now(),
        ),
      );
      emit(ChatLoaded(updatedMessages));
    }
  }
}