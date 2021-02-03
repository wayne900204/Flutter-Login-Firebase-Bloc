part of 'resend_bloc.dart';

@immutable
abstract class ResendEvent extends Equatable {
  const ResendEvent();
  @override
  List<Object> get props => [];
}
class ResendEmailChanged extends ResendEvent {
  final String email;

  const ResendEmailChanged({@required this.email});

  @override
  String toString() => 'EmailChanged { email :$email }';

  @override
  List<Object> get props => [email];
}
class RegisterButtonOnPressed extends ResendEvent{
  final String email;
  const RegisterButtonOnPressed({@required this.email});

  @override
  String toString() =>'RegisButtonOnPressed { email : $email }';
}
