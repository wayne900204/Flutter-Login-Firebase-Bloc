part of 'resend_bloc.dart';

class ResendState {
  final bool isEmailValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => isEmailValid;

  ResendState({
    @required this.isEmailValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });
  factory ResendState.empty(){
    return ResendState(
        isEmailValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
    );
  }
  factory ResendState.loading() {
    return ResendState(
      isEmailValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory ResendState.success() {
    return ResendState(
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }
  factory ResendState.failure() {
    return ResendState(
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  ResendState update({
    bool isEmailValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  ResendState copyWith({
    bool isEmailValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return ResendState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure
    );
  }

  @override
  String toString() => '{ '
      'isEmailValid: $isEmailValid, '
      'isSubmitting: $isSubmitting, '
      'isSuccess: $isSuccess'
      'isFailure: $isFailure'
      '}';
}


