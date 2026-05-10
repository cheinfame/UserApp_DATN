import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../data/models/wallet_model.dart';
import '../../../blocs/account_bloc/account_bloc.dart';
import '../../../data/models/account_model.dart';
import '../../../data/models/user_model.dart';
import '../../global_widgets/info_text_field.dart';
import '../../../config/typography.dart';
import '../../global_widgets/big_button.dart';
import '../../home_screens/screens/main_screen.dart';

class SignUpTab extends StatefulWidget {
  const SignUpTab({Key? key}) : super(key: key);

  @override
  State<SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<SignUpTab> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
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
      builder: (context, state) => Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.445,
                          child: InfoTextField(
                            isValid: false,
                            context: context,
                            isObscure: false,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            hintText: 'First Name',
                            label: 'First Name',
                            textFieldController: firstNameController,
                            formValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.445,
                          child: InfoTextField(
                            isValid: false,
                            context: context,
                            isObscure: false,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            hintText: 'Last Name',
                            label: 'Last Name',
                            textFieldController: lastNameController,
                            formValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    IntlPhoneField(
                      decoration: InputDecoration(
                        prefixIcon: null,
                        label: Text(
                          'Phone Number',
                          style: AppTypography(context: context).bodyText,
                        ),
                        hintText: 'Phone Number',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                      initialCountryCode: 'VN',
                      validator: (phone) {
                        if (phone == null || phone.number.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (phone.number.length != 9) {
                          return 'Please enter a valid 9-digit phone number';
                        }
                        return null; // Return null if validation succeeds
                      },
                      onSaved: (phone) {
                        phoneController.text = phone!.completeNumber;
                      },
                      disableLengthCheck: true,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InfoTextField(
                      context: context,
                      isObscure: false,
                      isValid: false,
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
                      isValid: false,
                      isObscure: true,
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
                      height: 10.0,
                    ),
                    InfoTextField(
                      context: context,
                      isObscure: true,
                      isValid: false,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      haveSuffixObscureIcon: true,
                      hintText: 'Confirm Password',
                      label: 'Confirm Password',
                      textFieldController: confirmPasswordController,
                      formValidator: (value) {
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    bigButton(
                      context,
                      "Create User",
                      () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          // Validation passed, proceed with form submission
                          final user = User(
                            userId: '',
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            phoneNumber: phoneController.text,
                            orderHistory: [],
                          );

                          final wallet = Wallet(
                            userId: '',
                            balance: 0.0,
                            transactionHistory: [],
                          );

                          final account = Account(
                            username: usernameController.text,
                            password: passwordController.text,
                            user: user,
                            wallet: wallet,
                          );

                          // Dispatch SignUpEvent with the account data
                          context
                              .read<AccountBloc>()
                              .add(SignUpEvent(account: account));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          (state.status == AccountStatus.loading)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
