import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

class WindowTitleBar extends StatelessWidget {
  const WindowTitleBar({
    super.key,
    this.brightness = Brightness.light,
    this.title,
    this.actions,
  });

  final Brightness brightness;
  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: DragToMoveArea(
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: brightness == Brightness.light
                          ? const Color(0x00000000).withOpacity(0.8956)
                          : const Color(0x00FFFFFF),
                      fontSize: 14,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: title,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ...?actions,
        ],
      ),
    );
  }
}
