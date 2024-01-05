import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String placeholder;
  final String error;
  final int lines;
  final TextEditingController controller;
  const InputWidget(
      {super.key, required this.placeholder, required this.lines, required this.controller, required this.error});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          labelText: placeholder),
      maxLines: lines,
      validator: (value) {
                if (value == null || value.isEmpty) {
                  return error;
                }
                return null;
              },
    );
  }
}
