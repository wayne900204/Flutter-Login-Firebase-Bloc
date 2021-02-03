import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_login_flutter/models/Validators.dart';
import 'package:firebase_login_flutter/models/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';


part 'resend_event.dart';
part 'resend_state.dart';

class ResendBloc extends Bloc<ResendEvent, ResendState> {
  final UserRepository _userRepository;

  ResendBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(ResendState.empty());

  @override
  Stream<ResendState> mapEventToState(ResendEvent event,) async* {
    // TODO: implement mapEventToState
    if(event is ResendEmailChanged){
       yield* _mapResendEmailChangedToState(event.email);
    }else if(event is RegisterButtonOnPressed){
      yield* _mapRegisterButtonOnPressedToState(event.email);
    }
  }
  Stream<ResendState> _mapResendEmailChangedToState(String email) async*{
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }
  Stream<ResendState> _mapRegisterButtonOnPressedToState(String email) async*{
    yield ResendState.loading();
    try {
      await _userRepository.sendPasswordResetEmail(email: email);
      yield ResendState.success();
    } catch (_) {
      yield ResendState.failure();
    }
  }
}
