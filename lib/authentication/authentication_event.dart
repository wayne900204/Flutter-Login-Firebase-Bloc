part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AppStartedEvent extends AuthenticationEvent {
  const AppStartedEvent();
  @override
  List<Object> get props => [];
}

class LoggedInEvent extends AuthenticationEvent {
  const LoggedInEvent();

  @override
  String toString() => 'LoggedIn';

  @override
  List<Object> get props => [];
}

class LoggedOutEvent extends AuthenticationEvent {
  const LoggedOutEvent();

  @override
  String toString() => 'LoggedOut';

  @override
  List<Object> get props => [];
}
