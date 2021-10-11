import 'package:flutter/material.dart';

final textInputDecoration = InputDecoration(

  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent, width: 2.5),
      borderRadius: BorderRadius.circular(15),
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green, width: 2.5),
      borderRadius: BorderRadius.circular(15)
  ),
);