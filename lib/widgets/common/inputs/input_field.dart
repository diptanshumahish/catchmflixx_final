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
  const CatchMFLixxInputField(
      {super.key,
      required this.labelText,
      this.obscureText = false,
      this.validator,
      this.inputFormatters,
      this.onchange,
      required this.icon,
      required this.controller,
      required this.type});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obscureText!,
      validator: validator,
      onChanged: onchange,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(22),
        errorMaxLines: 2,
        prefixIcon: Icon(icon),
        labelText: labelText,
        labelStyle: MediaQuery.of(context).size.height > 750
            ? TextStyles.formSubTitle
            : TextStyles.formSubTitleForSmallerScreens,
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white30)),
        errorBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      ),
      style: MediaQuery.of(context).size.height > 750
          ? TextStyles.textInputText
          : TextStyles.textInputTextForSmallScreens,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
