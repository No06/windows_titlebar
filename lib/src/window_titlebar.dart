import 'package:flutter/widgets.dart';

class WindowTitleBar extends StatelessWidget {
  const WindowTitleBar({
    super.key,
    this.decoration,
    this.title,
    this.padding,
    this.actions,
  });

  final BoxDecoration? decoration;
  final Widget? title;
  final EdgeInsetsGeometry? padding;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final widget = Row(
      children: [
        Expanded(
          child: Padding(
            padding: padding ?? const EdgeInsets.only(left: 16),
            child: title,
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
