import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final String title;
  final void Function(String value)? onOk;
  final VoidCallback? onNo;
  final String? hintText;
  final Widget? content;

  const CustomDialog({
    super.key,
    required this.title,
    this.onOk,
    this.onNo,
    this.hintText,
    this.content,
  });

  @override
  State<CustomDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<CustomDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: widget.content ?? const Text('no data'),
      actions: [
        TextButton(
          onPressed: () {
            if (widget.onNo != null) widget.onNo!();
            Navigator.of(context).pop();
          },
          child: const Text('NO'),
        ),
        TextButton(
          onPressed: () {
            if (widget.onOk != null) {
              widget.onOk!(_controller.text);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

Future<void> showCustomDialog(
  BuildContext context,
  String title,
  Widget content,
  void Function(String)? onOk,
  
) async {
  await showDialog(
    context: context,
    builder: (context) =>
        CustomDialog(title: title, content: content, onOk: onOk),
  );
}
