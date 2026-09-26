import 'package:flutter/material.dart';

const kTextField=InputDecoration(
  prefixIcon: Icon(Icons.email),
  hintText: "Enter your email",
  hintStyle: TextStyle(
    color: Color(0xFFa2acbd),
    fontSize: 16,
  ),
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0 ,horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(
      color: Color(0xFF757575),
      width: 1,),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Color(0xFFBDBDBD), width: 4.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
Widget kStack(Widget child) {
  return Stack(
    children: [
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.black,
            ],
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [
              const Color(0xFFFFF176).withOpacity(0.6),
              Colors.transparent,
            ],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
      child,
    ],
  );
}
