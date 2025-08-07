// lib/bloc/chat/chat_state.dart
import 'package:equatable/equatable.dart';
import 'package:messenger/models/message.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object> get props => [];
}

// Начальное состояние
class ChatInitial extends ChatState {}

// Состояние с загруженными сообщениями
class ChatLoaded extends ChatState {
  final List<Message> messages;
  const ChatLoaded(this.messages);
  @override
  List<Object> get props => [messages];
}