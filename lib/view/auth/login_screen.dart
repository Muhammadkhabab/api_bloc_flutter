import 'package:bloc_api_project/bloc/login_bloc/login_bloc.dart';
import 'package:bloc_api_project/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _loginBloc;

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
  }

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => _loginBloc,
        child: Form(
          key: _formKey,
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.loginStatus == LoginStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login Failed'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
              if (state.loginStatus == LoginStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login Success'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePostScreen()));
              }
            },
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 30.0,
                children: [
                  BlocBuilder<LoginBloc, LoginState>(
                    buildWhen: (current, previous) => current.email != previous.email,
                    builder: (context, state) {
                      return TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        focusNode: emailFocusNode,
                        decoration: const InputDecoration(hintText: 'Email', border: OutlineInputBorder()),
                        onChanged: (value) {
                          context.read<LoginBloc>().add(EmailChanged(email: value));
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter email';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          if (_formKey.currentState!.validate()) {
                            context.read<LoginBloc>().add(LoginApi());
                          }
                        },
                      );
                    },
                  ),
                  BlocBuilder<LoginBloc, LoginState>(
                    buildWhen: (current, previous) => current.password != previous.password,
                    builder: (context, state) {
                      return TextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: passwordFocusNode,
                        decoration: const InputDecoration(hintText: 'Password', border: OutlineInputBorder()),
                        onChanged: (value) {
                          context.read<LoginBloc>().add(PasswordChanged(password: value));
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter password';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          if (_formKey.currentState!.validate()) {
                            context.read<LoginBloc>().add(LoginApi());
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 50),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<LoginBloc>().add(LoginApi());
                          }
                        },
                        child: state.loginStatus == LoginStatus.loading ? CircularProgressIndicator() : const Text('Login'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
