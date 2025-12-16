import 'package:equatable/equatable.dart';
import 'package:meko_project/models/body/chat/conversation_model.dart';

class TabChatState extends Equatable {
  final bool isLoading;
  final List<ConversationModel> conversations;

  const TabChatState({this.isLoading = false, this.conversations = const []});

  TabChatState copyWith({bool? isLoading, List<ConversationModel>? conversations}) {
    return TabChatState(isLoading: isLoading ?? this.isLoading, conversations: conversations ?? this.conversations);
  }

  @override
  List<Object?> get props => [isLoading, conversations];
}
