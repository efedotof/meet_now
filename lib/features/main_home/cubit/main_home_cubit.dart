import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app/server/repository/socket/socket_service_interface.dart';

part 'main_home_state.dart';
part 'main_home_cubit.freezed.dart';

class MainHomeCubit extends Cubit<MainHomeState> {
  MainHomeCubit({required SocketServiceInterface socketServiceInterface})
    : _socketServiceInterface = socketServiceInterface,
      super(MainHomeState.initial()) {
    connect();
  }
  final SocketServiceInterface _socketServiceInterface;

  Future<void> connect() async {
    try {
      _socketServiceInterface.connect();
      _socketServiceInterface.getActiveTemporary();
      _socketServiceInterface.getPermanent();
    } catch (e) {
      debugPrint("error to connect: $e");
    }
  }
}
