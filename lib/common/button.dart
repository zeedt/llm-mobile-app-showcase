import 'package:flutter/material.dart';

class CButton extends StatelessWidget {
  final Function() onPress;
  final String text;
  final bool? disable;

  const CButton(
      {super.key, required this.onPress, required this.text, this.disable});

  @override
  Widget build(BuildContext context) {
    return (Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: disable == true
              ? const Color.fromARGB(255, 180, 147, 237)
              : const Color.fromRGBO(76, 40, 130, 1),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          )),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 8),
      // color: const Color.fromRGBO(76, 40, 130, 1),
      child: TextButton(
        onPressed: disable == true ? () {} : onPress,
        child: Text(
          text,
          style: const TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
      ),
    ));
  }
}
