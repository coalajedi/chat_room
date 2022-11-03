import 'package:flutter/material.dart';

class ParticipantWidget extends StatelessWidget {
  final String id;
  final Widget child;
  const ParticipantWidget({
    Key? key,
    required this.id,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => child;
}
