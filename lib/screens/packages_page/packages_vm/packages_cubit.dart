import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/models/body/package/package_model.dart';
import 'package:meko_project/models/body/paymnent/user_payment_model.dart';
import 'package:meko_project/repository/package/package_repository.dart';
import 'package:meko_project/repository/payment/payment_repo.dart';

part 'packages_state.dart';


class PackagesCubit extends Cubit<PackagesState>{
  final PackageRepository packageRepository;
  final PaymentRepo paymentRepo;
  PackagesCubit({required this.packageRepository, required this.paymentRepo}) : super(const PackagesState());

  Future<void> changeSelectedIndex(int index)async{
    emit(state.copyWith(selectedIndex: index,isLoading: true));
    if(index==0){
      await fetchUserPayments();
    }else{
      await fetchPackages();
    }
    emit(state.copyWith(isLoading: false));
  }
  
  Future<void> initCubit()async{
    emit(state.copyWith(isLoading: true));
    await fetchUserPayments();
    emit(state.copyWith(isLoading: false));
  }

  Future<void> fetchUserPayments()async{
    try{
      final result=await paymentRepo.getUserPayments();
      if(result!=null && result.data != null){
        emit(state.copyWith(userPayments: result.data));
      }

    }catch(error){
      print('Lỗi call payment repo ${error.toString()}');
    }
  }

  Future<void> fetchPackages()async{
    try{
      final result=await packageRepository.getPaymens();
      if(result.data != null){
        emit(state.copyWith(packages: result.data));
      }

    }catch(error){
      print('Lỗi call package repo ${error.toString()}');
    }
  }


}