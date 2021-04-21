import 'package:firebase_login_flutter/Style/Theme.dart';
import 'package:firebase_login_flutter/authentication/authentication_bloc.dart';
import 'package:firebase_login_flutter/login/login_bloc.dart';
import 'package:firebase_login_flutter/models/user_repository.dart';
import 'package:firebase_login_flutter/resend/resendScreen.dart';

import 'package:firebase_login_flutter/signup/signupScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class LoginPage extends StatefulWidget {
  final UserRepository _userRepository;
  LoginPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;
  SharedPreferences sharedPreferences;
  bool _rememberAccount;

  UserRepository get _userRepository => widget._userRepository;
  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isLoginButtonEnabled(LoginState state) =>
      state.isFormValid && isPopulated && !state.isSubmitting;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    SharedPreferences.getInstance().then((prefs) {
      sharedPreferences = prefs;
      _loadCheckbox();
      _loadAccount();
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (BuildContext context, LoginState state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text('Login Failure'), Icon(Icons.error)],
              ),
              backgroundColor: Colors.red,
            ));
        }
        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                )));
        }
        if (state.isSuccess) {
          if (_rememberAccount) _saveAccount(_emailController.text);
          else _saveAccount("");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedInEvent());
        }
      },
      builder: (BuildContext context, LoginState state) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: Style.greenGradient,
          ),
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Image.asset('assets/LOGO/aFFA.png', height: 200,),
                      ),
                      _buildEmailField(state),
                      _buildPassField(state),
                      _buildCheckBoxTitle(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            LoginButton(
                              text: "Login",
                                onPressed: isLoginButtonEnabled(state)
                                    ? _onFormSubmitted
                                    : null),
                            _buildGoogleButton(),
                            CreateAccountButton(userRepository: _userRepository)
                          ],
                        ),
                      ),
                      _buildFooterLogo()
                    ],
                  ),
                )),
          ),
        );
      },
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
  // 底部 Logo
  Widget _buildFooterLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
          child: Text('By Wenya',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
  Widget _buildEmailField(LoginState state){
    return                       Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.cyan,
          border: _outLine(Colors.black, 4),
          prefixIcon: Icon(Icons.account_circle,color: Colors.white,),
          hintText: 'Email',
          hintStyle: TextStyle( color: Colors.white),
        ),
        autovalidateMode: AutovalidateMode.always,
        autocorrect: false,
        validator: (_) {
          return !state.isEmailValid ? 'Invalid Email' : null;
        },
      ),
    );
  }
  Widget _buildPassField(LoginState state){
    return                       Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.cyan,
          border: _outLine(Colors.black, 4),
          prefixIcon: Icon(Icons.lock,color: Colors.white),
          hintText: 'Password',
          hintStyle: TextStyle( color: Colors.white),
        ),
        obscureText: true,
        autovalidateMode: AutovalidateMode.always,
        autocorrect: false,
        validator: (_) {
          return !state.isPasswordValid ? 'Invalid Password' : null;
        },
      ),
    );
  }
  _buildCheckBoxTitle(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: _rememberAccount ?? false,
                  onChanged: (value) {
                    setState(() {
                      _rememberAccount = value;
                    });
                    _saveCheckout(value);
                  },
            ),
            Text('Remember My Account',style: TextStyle(fontSize: 12),),
          ],
        ),
        GestureDetector(
          onTap: () {
            return Navigator.push(context, MaterialPageRoute(builder: (context){
              return ResendScreen(userRepository: _userRepository);
            }));
          },
          child: Text("Forget your password?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              )),
        ),
      ],
    );
  }
  // GoogleButton
  Widget _buildGoogleButton(){
    return GestureDetector(
      onTap: ()=>_loginBloc.add(LoginWithGooglePressed()),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Colors.teal[200],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.google,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text('Sign-in using Google',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
/// Function
  void _onEmailChanged() {
    _loginBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }

  _loadCheckbox() async {
    print("load checkout");
    print(sharedPreferences.getBool('remember_account'));
    setState(() {
      _rememberAccount = sharedPreferences.getBool('remember_account') ?? false;
    });
  }

  _saveCheckout(value) async {
    print("save checkout");

    await sharedPreferences.setBool('remember_account', value);
  }

  _loadAccount() async {
    setState(() {
      _emailController.text = sharedPreferences.getString('account') ?? "";
    });
  }

  _saveAccount(account) async {
    await sharedPreferences.setString('account', account);
  }
}
/// Widget
class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;
  final String text;
  LoginButton({Key key, VoidCallback onPressed,String text})
      : _onPressed = onPressed,
        text = text,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: MaterialButton(
        disabledColor:  Colors.teal[100],
        elevation: 2,
        height: 50,
        splashColor:  Colors.teal[200],
        highlightColor: Colors.teal[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        onPressed: _onPressed,
        color:  Colors.teal[200],
        child: Text(text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        textColor: Colors.white,
      ),
    );
  }
}

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  CreateAccountButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account ? ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              )),
          GestureDetector(
              onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return SignupScreen(userRepository: _userRepository);
                    }));
              },
              child: Text("Sign up",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  )))
        ],
      ),
    );
  }
}
