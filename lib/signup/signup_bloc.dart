import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_login_flutter/models/Validators.dart';
import 'package:firebase_login_flutter/models/user_repository.dart';
import 'package:meta/meta.dart';


part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  UserRepository _userRepository;
  SignupBloc({@required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignupState.empty());

  @override
  Stream<SignupState> mapEventToState(
      SignupEvent event,
      ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password);
    }
  }

  Stream<SignupState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<SignupState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<SignupState> _mapFormSubmittedToState(
      String email,
      String password,
      ) async* {
    yield SignupState.loading();
    try {
      await _userRepository.signUp(
        email: email,
        password: password,
      );
      yield SignupState.success();
    } catch (_) {
      yield SignupState.failure();
    }
  }
}
