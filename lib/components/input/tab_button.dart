import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  const TabButton({
    Key? key,
    this.onPressed,
    this.text = '',
    this.active = false,
    this.collapsed = false,
    this.collapsedIcon,
    this.expandVertically,
  }) : super(key: key);

  final Function()? onPressed;
  final String text;
  final bool active;
  final Icon? collapsedIcon;
  final bool collapsed;
  final bool? expandVertically;

  Widget button() {
    final buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: active ? Colors.black : Colors.white,
      backgroundColor: active ? Colors.white : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      side: const BorderSide(
        color: Colors.white,
        width: 3,
      ),
    ).copyWith(
      side: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.hovered)) {
          return BorderSide(
            color: Colors.white.withOpacity(0.6),
            width: 3,
          );
        }
        return const BorderSide(
          color: Colors.white,
          width: 3,
        );
      }),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.hovered)) {
          return active ? Colors.white.withOpacity(0.8) : Colors.transparent;
        }
        return active ? Colors.white : Colors.transparent;
      }),
    );
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: buttonStyle,
      icon: collapsedIcon!,
      label: Text(
        text,
        style: const TextStyle(fontSize: 17, fontFamily: 'vcr'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 4).copyWith(
        bottom: expandVertically == null
            ? 0
            : expandVertically!
                ? 0
                : 10,
      ),
      child: button(),
    );
  }
}
