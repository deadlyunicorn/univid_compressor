import "package:flutter/material.dart";
import "package:univid_compressor/skeleton/video_queue/list_container.dart";

class VideoQueueList extends StatelessWidget {
  const VideoQueueList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const ListContainer(
          child: Column(
            children: <Widget>[Text("Haha?")],
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.white),
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.surface,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("hello world!"))
                );
                print("Does this import?");
              },
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
