import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:packare/config/typography.dart';


class InfoTextField extends StatefulWidget {
  final BuildContext context;
  final bool isObscure;
  final bool isValid;
  final Icon? prefixIcon;
  final Icon? suffixIcon; // Add suffix icon
  final bool? haveSuffixObscureIcon;
  final bool readOnly;
  final String hintText;
  final String label;
  final TextEditingController textFieldController;
  final FormFieldValidator? formValidator;
  final List<TextInputFormatter>? inputFormatters;
  final String? suffixText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final FocusNode? focusNode; // Add focus node here
  final VoidCallback? onSuffixPressed; // Add suffix icon press callback

  const InfoTextField({
    Key? key,
    required this.context,
    required this.isObscure,
    required this.isValid,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon, // Initialize suffix icon
    this.haveSuffixObscureIcon,
    this.keyboardType = TextInputType.text,
    required this.hintText,
    required this.label,
    required this.textFieldController,
    this.formValidator,
    this.inputFormatters,
    this.suffixText,
    this.onChanged,
    this.focusNode, // Add focus node parameter
    this.onSuffixPressed, // Add suffix icon press callback parameter
  }) : super(key: key);

  @override
  State<InfoTextField> createState() => _InfoTextFieldState();
}

class _InfoTextFieldState extends State<InfoTextField> {
  bool _toggleObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textFieldController,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon != null
            ? IconButton(
                // Check if suffix icon is provided
                icon: widget.suffixIcon!, // Use provided suffix icon
                onPressed: () {
                  if (widget.onSuffixPressed != null) {
                    widget.onSuffixPressed!(); // Call the callback function
                  } else {
                    setState(() {
                      _toggleObscure = !_toggleObscure;
                    });
                  }
                },
              )
            : null, // If suffix icon is not provided, show nothing
        label: Text(
          widget.label,
          style: AppTypography(context: widget.context).bodyText,
        ),
        hintText: widget.hintText,
        suffixText: widget.suffixText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      validator: widget.formValidator,
      obscureText: widget.isObscure,
      focusNode: widget.focusNode, // Assign focus node here
    );
  }
}
