import 'package:bloc/bloc.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';
import 'package:meko_project/screens/tab/tab_%20manage_posting/tab_posting_vm/tab_posting_state.dart';

class TabPostingCubit extends Cubit{
  TabPostingCubit() : super(TabPostingState());


  Future<void> isCheckLogin() async {
    final logged = await SharedPref.instance.getBool(AppConsts.keyLoginSuccess) ?? false;
    emit(state.copyWith(isLoggedIn: logged));
  }

}