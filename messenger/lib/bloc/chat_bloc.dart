import 'package:bloc/bloc.dart';
import 'package:messenger/bloc/chat_event.dart';
import 'package:messenger/bloc/chat_state.dart';
import 'package:messenger/models/message.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // Начальное состояние
  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
  }

  // Наш статический "источник" сообщений
  final List<Message> _messages = [
    Message(text: 'Привет!', sender: 'User2', timestamp: DateTime.now()),
    Message(text: 'Как дела?', sender: 'Me', timestamp: DateTime.now()),
  ];

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final List<Message> updatedMessages = List.from((state as ChatLoaded).messages);
      updatedMessages.add(
        Message(
          text: event.text,
          sender: 'Me',
          timestamp: DateTime.now(),
        ),
      );
      emit(ChatLoaded(updatedMessages));
    } else {
      // Изначально, когда состояние ChatInitial
      final List<Message> initialMessages = List.from(_messages);
      initialMessages.add(
        Message(
          text: event.text,
          sender: 'Me',
          timestamp: DateTime.now(),
        ),
      );
      emit(ChatLoaded(initialMessages));
    }
  }
}