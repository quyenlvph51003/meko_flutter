import 'package:bloc/bloc.dart';
import 'package:meko_project/screens/tab/tab_%20manage_posting/tab_posting_vm/tab_posting_state.dart';


class PostManagerCubit extends Cubit<PostManagerState> {
  PostManagerCubit() : super(const PostManagerState());


  void selectTab(PostTab tab) {
    emit(state.copyWith(currentTab: tab));
  }


  void increaseDT() {
    emit(state.copyWith(dtPoint: state.dtPoint + 1));
  }
}