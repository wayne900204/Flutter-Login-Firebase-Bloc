import 'package:firebase_login_flutter/models/user_repository.dart';
import 'package:firebase_login_flutter/signup/signup_bloc.dart';
import 'package:firebase_login_flutter/signup/signupPage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';


class SignupScreen extends StatelessWidget {
  final UserRepository _userRepository;
  SignupScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
          create: (_) =>
              SignupBloc(userRepository: _userRepository),
          child: SignupPage(),
        ));
  }
}