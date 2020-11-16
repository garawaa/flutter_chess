import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

Future<String> get rootDir async {
  final directory = await getApplicationDocumentsDirectory();
  // For your reference print the AppDoc directory
  return directory.path;
}

class ContextSingleton {
  static ContextSingleton _instance;
  final BuildContext _context;

  ContextSingleton(this._context) {
    _instance = this;
  }

  static get context {
    return _instance._context;
  }
}

bool _showing = false;

void showTextDialog(title, text, onDoneText, onDone) async {
  if (_showing) return;

  _showing = true;

  //show dialog
  await showGeneralDialog(
    context: ContextSingleton.context,
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
      return Transform(
        transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
        child: Opacity(
          opacity: a1.value,
          child: AlertDialog(
            title: Center(
                child: Text(
              title,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.start,
            )),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(strings.cancel),
                  onPressed: () {
                    _showing = false;
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                  child: Text(onDoneText),
                  onPressed: () {
                    _showing = false;
                    Navigator.of(context).pop();
                    if (onDone != null) onDone();
                  })
            ],
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 200),
  ).then((value) {
    _showing = false;
  });
}
