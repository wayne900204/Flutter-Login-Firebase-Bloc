import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login_flutter/authentication/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Welcome, ${user.displayName}'+"\n"+user.email.toString(),
                style: TextStyle(
                    fontSize: 24
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Logout'),
                onPressed: (){
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(LoggedOutEvent());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
