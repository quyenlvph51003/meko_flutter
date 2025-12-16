import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/repository/chat/chat_repository.dart';
import 'package:meko_project/models/body/chat/message_model.dart';
import 'package:meko_project/screens/chat_page/vm/chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatPageCubit() : super(const ChatPageState());

  final _repo = ChatRepository(restClient: getIt<RestClient>());

  Future<void> fetchMessages(int conversationId) async {
    if (conversationId == 0) return emit(state.copyWith(messages: []));
    emit(state.copyWith(isLoading: true, error: null));
    final res = await _repo.getlistMessages(conversationId);
    if (res.success) {
      List<MessageChatModel> messages = (res.data ?? []).reversed.toList();
      emit(state.copyWith(isLoading: false, messages: messages));
    } else {
      emit(state.copyWith(isLoading: false, error: res.message, messages: const []));
    }
  }

  void addIncoming(MessageChatModel message) {
    final updated = List.of(state.messages)..add(message);
    emit(state.copyWith(messages: updated));
  }
}
