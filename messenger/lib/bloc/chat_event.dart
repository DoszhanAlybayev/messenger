import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvent {
  final String text;
  const SendMessage(this.text);
  @override
  List<Object> get props => [text];
}