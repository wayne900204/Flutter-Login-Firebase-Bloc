import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login_flutter/models/user_repository.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository!=null),
        _userRepository = userRepository,
        super(InitializedState());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppStartedEvent) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedInEvent) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOutEvent) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final bool isSigned = _userRepository.isSignedIn();
      if (isSigned) {
        final User user = _userRepository.getUser();
        yield AuthenticatedState(user: user);
      } else {
        yield UnauthenticatedState();
      }
    } catch (_) {
      yield UnauthenticatedState();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final User user = _userRepository.getUser();
    yield AuthenticatedState(user: user);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    _userRepository.logOut();
    yield UnauthenticatedState();
  }
}
