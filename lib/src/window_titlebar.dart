import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

class WindowTitleBar extends StatelessWidget {
  const WindowTitleBar({
    super.key,
    this.decoration,
    this.title,
    this.actions,
  });

  final BoxDecoration? decoration;
  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final widget = Row(
      children: [
        Expanded(
          child: DragToMoveArea(
            child: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: title,
                ),
              ),
            ),
          ),
        ),
        ...?actions,
      ],
    );

    if (decoration != null) {
      return DecoratedBox(decoration: decoration!, child: widget);
    }

    return widget;
  }
}
