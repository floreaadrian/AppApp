import 'package:flutter/material.dart';

Container getToolbar(BuildContext context) {
  return new Container(
    margin: new EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ),
    child: new BackButton(
      color: Theme.of(context).primaryColor,
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}
