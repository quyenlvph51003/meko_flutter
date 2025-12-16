import 'package:equatable/equatable.dart';
import 'package:meko_project/models/body/chat/message_model.dart';

class ChatPageState extends Equatable {
  final bool isLoading;
  final List<MessageChatModel> messages;
  final String? error;

  const ChatPageState({this.isLoading = false, this.messages = const [], this.error});

  ChatPageState copyWith({bool? isLoading, List<MessageChatModel>? messages, String? error}) {
    return ChatPageState(isLoading: isLoading ?? this.isLoading, messages: messages ?? this.messages, error: error);
  }

  @override
  List<Object?> get props => [isLoading, messages, error];
}
