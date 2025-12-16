import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/main.dart';
import 'package:meko_project/repository/chat/chat_repository.dart';
import 'package:meko_project/screens/tab/tab_chat/tab_chat_vm/tab_chat_state.dart';

class TabChatCubit extends Cubit<TabChatState> {
  TabChatCubit() : super(TabChatState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));

    final result = await ChatRepository(restClient: getIt<RestClient>()).getConversations();

    emit(state.copyWith(isLoading: false, conversations: result.data ?? []));
  }
}
