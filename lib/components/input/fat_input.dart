import 'package:cgef/helpers/layout_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layout/layout.dart';

class FatInput extends StatelessWidget {
  const FatInput({
    Key? key,
    this.controller,
    this.onChanged,
    this.customBorderRadius,
  }) : super(key: key);
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final BorderRadius? customBorderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = customBorderRadius != null
        ? customBorderRadius!
        : const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          );
    return Margin(
      margin: const EdgeInsets.only(bottom: LayoutHelper.standardMargin),
      child: SizedBox(
        width: double.infinity,
        child: TextField(
          controller: controller,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              try {
                final text = newValue.text;
                if (text.isNotEmpty && text != '-') {
                  var num = double.parse(text);
                  if (num > 50) return newValue.copyWith(text: '50');
                  if (num < -50) return newValue.copyWith(text: '-50');
                }
                return newValue;
              } catch (e) {}
              return oldValue;
            }),
          ],
          onEditingComplete: () {
            var parsedNum = int.tryParse(controller!.text);
            if (parsedNum == null) {
              controller!.text = '0';
            }
          },
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: radius),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 3,
                ),
                borderRadius: radius),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 3,
                ),
                borderRadius: radius),
          ),
        ),
      ),
    );
  }
}