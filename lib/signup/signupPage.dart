import 'package:firebase_login_flutter/Style/Theme.dart';
import 'package:firebase_login_flutter/authentication/authentication_bloc.dart';
import 'package:firebase_login_flutter/login/loginPage.dart';
import 'package:firebase_login_flutter/signup/signup_bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var size;
  SignupBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(SignupState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<SignupBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedInEvent());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: _buildAppBar(),
            body: Container(
              decoration: BoxDecoration(
                gradient: Style.greenGradient
              ),
              padding: EdgeInsets.all(20),
              child: Form(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Image.asset(
                        'assets/LOGO/aFFA.png',
                        height: 200,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: 30.0),
                        child: Center(
                            child: Text(
                          "註 冊 帳 號",
                          style: TextStyle(
                              fontSize: 40,
                              color: Colors.brown,
                              fontStyle: FontStyle.italic),
                        ))),
                    _buildAccount(state),
                    _buildPassword(state),
                    LoginButton(
                        onPressed: isRegisterButtonEnabled(state)
                            ? _onFormSubmitted
                            : null,
                      text: "Register",
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Decoration
  OutlineInputBorder _outLine(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(7),
          topRight: Radius.circular(7)),
      borderSide: BorderSide(color: color, width: width),
    );
  }
  /// Widget
  Widget _buildAppBar() {
    return AppBar(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      leadingWidth: size.width * 0.2,
      leading: Builder(
        builder: (context) => IconButton(
          icon: new Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      ),
    );
  }
  Widget _buildAccount(SignupState state){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email,color: Colors.white),
          hintText: 'Email',
          filled: true,
          fillColor: Colors.cyan,
          border: _outLine(Colors.black, 4),
        ),

        autocorrect: false,
        autovalidateMode: AutovalidateMode.always,
        validator: (_) {
          return !state.isEmailValid ? 'Invalid Email' : null;
        },
      ),
    );
  }
  Widget _buildPassword(SignupState state){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.cyan,
          border: _outLine(Colors.black, 4),
          prefixIcon: Icon(Icons.lock,color: Colors.white),
          hintText: 'Password',
        ),
        obscureText: true,
        autocorrect: false,
        autovalidateMode: AutovalidateMode.always,
        validator: (_) {
          return !state.isPasswordValid ? 'Invalid Password' : null;
        },
      ),
    );
  }
  /// Function
  void _onEmailChanged() {
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}

