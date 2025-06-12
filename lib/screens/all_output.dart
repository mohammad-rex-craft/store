import 'package:flutter/material.dart';
import '../hooks.dart';
import '../widget/common/bar.dart';

var primeColor = hexToColor('#03A9F4');


class AllOutput extends StatelessWidget {
  const AllOutput({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(title: 'All Output'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [],
      ),
    );
  }
}