import 'package:flutter/material.dart';

Widget circleLoading() {
  return const Center(
    child: CircleAvatar(
      radius: 100,
      backgroundImage: AssetImage('assets/images/portal.gif'),
    ),
  );
}
