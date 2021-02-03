import 'package:firebase_login_flutter/screens/HomeScreen.dart';
import 'package:firebase_login_flutter/login/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'SimpleBlocOvserver.dart';
import 'authentication/authentication_bloc.dart';
import 'models/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;
  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    awaitThreeSeconds();
  }

  void awaitThreeSeconds() async {
    await Future.delayed(Duration(seconds: 5));
    _authenticationBloc.add(AppStartedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => _authenticationBloc,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            // cubit: _authenticationBloc,
          // 如果省略cubit參數，BlocBuilder將使用BlocProvider和當前函數自動執行查找BuildContext。
            builder: (context, state) {
              if (state is AuthenticatedState)
                return HomeScreen(
                  user: state.user,
                );
              else if (state is UnauthenticatedState)
                return LoginScreen(
                  userRepository: _userRepository,
                );
              return Material(
                child: Center(
                    child: SizedBox(
                        width: 300,
                        child: TextLiquidFill(
                          text: 'Flutter Is The Best',
                          waveColor: Colors.redAccent,
                          boxBackgroundColor: Colors.cyan,
                          loadDuration: Duration(seconds: 4),
                          textStyle: TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ))),
              );
            },
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}


