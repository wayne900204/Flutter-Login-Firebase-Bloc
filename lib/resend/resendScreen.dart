import 'package:firebase_login_flutter/models/user_repository.dart';
import 'package:firebase_login_flutter/resend/resendPage.dart';
import 'package:firebase_login_flutter/resend/resend_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResendScreen extends StatelessWidget {
  final UserRepository _userRepository;
  ResendScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
          create: (_) =>
              ResendBloc(userRepository: _userRepository),
          child: ResendPage(),
        ));
  }
}
