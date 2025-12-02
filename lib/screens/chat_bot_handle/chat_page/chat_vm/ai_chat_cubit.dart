import 'package:meko_project/screens/chat_bot_handle/ai_data/ai_chat_repository.dart';
import 'package:meko_project/screens/chat_bot_handle/ai_model/ai_message.dart';
import 'package:meko_project/screens/chat_bot_handle/chat_page/chat_vm/ai_chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiChatCubit extends Cubit<AiChatState> {
  final AiChatRepository repository;

  AiChatCubit({required this.repository}) : super(AiChatState.initial());

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isSending) return;

    final newUserMsg = AiMessage(id: DateTime.now().microsecondsSinceEpoch.toString(), text: trimmed, isUser: true);

    final messagesAfterUser = [...state.messages, newUserMsg];

    emit(state.copyWith(messages: messagesAfterUser, isSending: true, error: null));

    try {
      final replyText = await repository.sendMessage(history: messagesAfterUser, newMessage: trimmed);

      final botMsg = AiMessage(id: DateTime.now().microsecondsSinceEpoch.toString(), text: replyText, isUser: false);

      emit(state.copyWith(messages: [...messagesAfterUser, botMsg], isSending: false, error: null));
    } catch (e) {
      emit(state.copyWith(isSending: false, error: e.toString()));
    }
  }
}
