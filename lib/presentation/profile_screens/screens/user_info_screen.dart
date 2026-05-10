import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:packare/blocs/account_bloc/account_bloc.dart';
import 'package:packare/config/typography.dart';
import 'package:packare/presentation/profile_screens/widgets/user_detailed_info_app_bar.dart';
import '../../../data/models/account_model.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  bool isEditState = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  late Account account;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Information',
          style: AppTypography(context: context).title3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && isEditState == true) {
                final firstName = _nameController.text.split(" ").first;
                final lastName =
                    _nameController.text.substring(firstName.length).trim();
                if (isEditState) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                          'Do you want to save your information?',
                          style: AppTypography(context: context).bodyText,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: AppTypography(context: context)
                                  .subhead
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<AccountBloc>().add(
                                    UpdateUserProfileEvent(
                                      account: account.copyWith(
                                        user: account.user.copyWith(
                                          firstName: firstName,
                                          lastName: lastName,
                                          phoneNumber: _phoneController.text,
                                        ),
                                      ),
                                    ),
                                  );
                              Navigator.pop(context);
                            },
                            child: Text('OK',
                                style: AppTypography(context: context)
                                    .subhead
                                    .copyWith(color: Colors.lightBlue)),
                          ),
                        ],
                      );
                    },
                  );
                }
              }
              setState(() {
                isEditState = !isEditState;
              });
            },
            child: Text(
              isEditState ? 'Save' : 'Edit',
              style: AppTypography(context: context).bodyText,
            ),
          ),
        ],
      ),
      body: BlocConsumer<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state.status == AccountStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Profile updated successfully!'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state.status == AccountStatus.failed &&
              state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == AccountStatus.success) {
            account = state.account!;
            _nameController.text =
                '${account.user.firstName} ${account.user.lastName}';
            _phoneController.text = account.user.phoneNumber.substring(3);
   
          }
          return Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const UserDetailedInfoAppBar(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        readOnly: !isEditState,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      IntlPhoneField(
                        decoration: InputDecoration(
                          prefixIcon: null,
                          label: Text(
                            'Phone Number',
                            style: AppTypography(context: context).bodyText,
                          ),
                          hintText: 'Phone Number',
                        ),
                        initialCountryCode: 'VN',
                        controller: _phoneController,
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
                          _phoneController.text = phone!.completeNumber;
                        },
                        disableLengthCheck: true,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    'Log out',
                    style: AppTypography(context: context)
                        .subhead
                        .copyWith(color: Colors.lightBlue),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
