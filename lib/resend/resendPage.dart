import 'package:firebase_login_flutter/Style/Theme.dart';
import 'package:firebase_login_flutter/login/loginPage.dart';
import 'package:firebase_login_flutter/resend/resend_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResendPage extends StatefulWidget {
  @override
  _ResendPageState createState() => _ResendPageState();
}

class _ResendPageState extends State<ResendPage> {
  var size;

  final TextEditingController _emailController = TextEditingController();

  ResendBloc _resendBloc;
  bool isResendButtonEnabled(ResendState state) {
   return state.isFormValid && _emailController.text.isNotEmpty &&
        !state.isSubmitting;
  }

  @override
  void initState() {
    _resendBloc = BlocProvider.of<ResendBloc>(context);
    _emailController.addListener(_onEmailChanged);
    super.initState();
  }


  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return BlocConsumer<ResendBloc,ResendState>(
      listener: (BuildContext context, ResendState state){
        if(state.isSubmitting){
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text('Loading'),   CircularProgressIndicator(),],
              ),
              backgroundColor: Colors.cyan[200],
            ));
        }
        if(state.isSuccess){
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text('Resend Success'),  Icon(Icons.whatshot),],
              ),
              backgroundColor: Colors.cyan[500],
            ));
        }
        if(state.isFailure){
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text('Resend Failure'), Icon(Icons.error)],
              ),
              backgroundColor: Colors.red,
            ));
        }
      },
      builder: (BuildContext context,ResendState state){
        return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: _buildAppBar(),
              body: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(gradient: Style.greenGradient),
                padding: EdgeInsets.all(20),
                child: Form(
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Image.asset(
                          'assets/LOGO/aFFA.png',
                          height: 200,
                        ),
                      ),
                      _buildEmailField(state),
                      LoginButton(
                          text: "Resend",
                          onPressed: isResendButtonEnabled(state)
                              ? _onFormSubmitted
                              : null),
                    ],
                  ),
                ),
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

  Widget _buildEmailField(ResendState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.cyan,
          border: _outLine(Colors.black, 4),
          prefixIcon: Icon(
            Icons.account_circle,
            color: Colors.white,
          ),
          hintText: 'Email',
          hintStyle: TextStyle(color: Colors.white),
        ),
        autovalidateMode: AutovalidateMode.always,
        autocorrect: false,
        validator: (_) {
          return !state.isEmailValid ? 'Invalid Email' : null;
        },
      ),
    );
  }
  /// Function
  void _onEmailChanged() {
    _resendBloc.add(ResendEmailChanged(email: _emailController.text),
    );
  }
  void _onFormSubmitted(){
  _resendBloc.add(RegisterButtonOnPressed(email: _emailController.text));
  }
}
