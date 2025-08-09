import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CatchMFLixxInputField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType type;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final String? Function(String?)? onchange;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final String? hintText;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  const CatchMFLixxInputField(
      {super.key,
      required this.labelText,
      this.obscureText = false,
      this.validator,
      this.inputFormatters,
      this.onchange,
      required this.icon,
       required this.controller,
       required this.type,
       this.suffixIcon,
       this.hintText,
       this.textInputAction,
       this.onFieldSubmitted});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obscureText!,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onchange,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(22),
        errorMaxLines: 2,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        labelText: labelText,
        hintText: hintText,
        labelStyle: MediaQuery.of(context).size.height > 750
            ? TextStyles.formSubTitle
            : TextStyles.formSubTitleForSmallerScreens,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white30),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: MediaQuery.of(context).size.height > 750
          ? TextStyles.textInputText
          : TextStyles.textInputTextForSmallScreens,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
