import "package:flutter/material.dart";
import "package:univid_compressor/core/widgets/snackbars.dart";

class StartConvertingSelectedButton extends StatelessWidget {
  const StartConvertingSelectedButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextButton(
          onPressed: () async {//TODO HERE
            showNormalSnackbar(context: context, message: "helloWorld!");
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
      ],
    );
  }
}
