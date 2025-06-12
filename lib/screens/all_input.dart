import 'package:flutter/material.dart';
import '../widget/common/bar.dart';

class AllInput extends StatelessWidget {
  const AllInput({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(title: 'All Input'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        ],
      ),
    );
  }
}