import 'package:flutter/material.dart';

class UploadActionButton extends StatelessWidget {
  final VoidCallback callback;
  UploadActionButton({this.callback});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Upload a photo',
      onPressed: callback,
      child: Icon(
        Icons.add,
      ),
    );
  }
}
