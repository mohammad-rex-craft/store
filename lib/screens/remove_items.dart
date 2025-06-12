import 'package:flutter/material.dart';
import '../hooks.dart';
import '../widget/common/bar.dart';

var primeColor = hexToColor('#03A9F4');


class RemoveItems extends StatelessWidget {
  const RemoveItems({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(title: 'Remove Items'),
      body: Center(child: Text('dsadas')),
    );

  }
}