import "package:flutter/material.dart";

class StartConvertingSelectedButton extends StatelessWidget {
  const StartConvertingSelectedButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.surface,
                ),
          ),
          child: TextButton(
            onPressed: () {
              print("Hey tehre!:)");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("hello world!"),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: <Widget>[
                  Text("Start Converting"),
                  Icon(
                    Icons.keyboard_double_arrow_right_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
