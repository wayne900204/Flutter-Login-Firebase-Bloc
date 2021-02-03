import 'package:firebase_login_flutter/login/login_bloc.dart';
import 'package:firebase_login_flutter/models/user_repository.dart';
import 'package:firebase_login_flutter/login/loginPage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (BuildContext context) =>
            LoginBloc(userRepository: _userRepository),
        child: LoginPage(userRepository: _userRepository),
      ),
    );
  }
}
