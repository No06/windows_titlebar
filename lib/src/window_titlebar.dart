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
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: title ?? const SizedBox.expand()),
        ...?actions,
      ],
    );

    if (decoration != null) {
      return DecoratedBox(decoration: decoration!, child: widget);
    }

    return widget;
  }
}
