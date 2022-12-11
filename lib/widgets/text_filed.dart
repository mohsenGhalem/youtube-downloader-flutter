import 'package:flutter/material.dart';

import 'theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.fieldController,
      this.validatior,
      this.onFieldSubmitted,
      this.child})
      : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? fieldController;
  final Widget? child;
  final String? Function(String?)? validatior;
  final void Function(String)? onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Themes.titleStyle,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: Themes.titleStyle,
                  obscureText: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: hint,
                    filled: true,
                    hintStyle: Themes.subTitleStyle,
                  ),
                  controller: fieldController,
                  validator: validatior,
                  onFieldSubmitted: onFieldSubmitted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
