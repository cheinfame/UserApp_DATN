import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packare/presentation/global_widgets/info_text_field.dart';
import 'package:packare/presentation/home_screens/screens/main_screen.dart';
import '../../../blocs/account_bloc/account_bloc.dart';
import '../../../config/typography.dart';
import '../../global_widgets/big_button.dart';

class LoginTab extends StatefulWidget {
  const LoginTab({Key? key}) : super(key: key);

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordObscure = true;

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.loginStatus == LoginStatus.login) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        } else if (state.loginStatus == LoginStatus.failed) {
          showDialog(
            context: context,
            builder: (context) {
              // Remove "Exception:" prefix from the error message
              final errorMessage = state.error!.replaceFirst('Exception: ', '');
              return AlertDialog(
                content: Text(
                  errorMessage,
                  style: AppTypography(context: context).bodyText,
                ),
              );
            },
          );
        }
      },
      builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InfoTextField(
                    context: context,
                    isValid: false,
                    isObscure: false,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    hintText: 'Username',
                    label: 'Username',
                    textFieldController: usernameController,
                    formValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      } else if (value.length < 6) {
                        return 'Username must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  InfoTextField(
                    context: context,
                    isObscure: _isPasswordObscure,
                    isValid: false,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    haveSuffixObscureIcon: true,
                    hintText: 'Password',
                    label: 'Password',
                    textFieldController: passwordController,
                    formValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  bigButton(
                    context,
                    "Login",
                    () {
                      if (_formKey.currentState!.validate()) {
                        // Validation passed, proceed with form submission
                        final username = usernameController.text;
                        final password = passwordController.text;

                        // Dispatch LoginEvent by adding it to AuthBloc
                        context.read<AccountBloc>().add(
                            LoginEvent(username: username, password: password));
                      }
                    },
                  ),
                ],
              ),
            ),
            (state.loginStatus == LoginStatus.loading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox()
          ],
        );
      },
    );
  }
}
