import 'package:flutter/material.dart';
import 'package:windows_titlebar/windows_titlebar.dart';

const kWindowTitleBarHeight = 32.0;

typedef WindowButtonBuilder = Widget Function(
  BuildContext context,
  Color color,
);

class WindowButton extends StatefulWidget {
  const WindowButton({
    super.key,
    this.onTap,
    this.buttonColor = const WindowButtonColor.light(),
    this.animated = false,
    this.animationCurve = Curves.linear,
    this.animationDuration = const Duration(milliseconds: 120),
    this.constraints = const BoxConstraints(
      minWidth: 46,
      minHeight: kWindowTitleBarHeight,
    ),
    required this.builder,
  });

  WindowButton.close({
    super.key,
    this.onTap,
    this.buttonColor = const WindowButtonColor.light(),
    this.animated = false,
    this.animationCurve = Curves.linear,
    this.animationDuration = const Duration(milliseconds: 120),
    this.constraints = const BoxConstraints(
      minWidth: 46,
      minHeight: kWindowTitleBarHeight,
    ),
  }) : builder = ((context, color) => CloseIcon(color: color));

  WindowButton.unmaximize({
    super.key,
    this.onTap,
    this.buttonColor = const WindowButtonColor.light(),
    this.animated = false,
    this.animationCurve = Curves.linear,
    this.animationDuration = const Duration(milliseconds: 120),
    this.constraints = const BoxConstraints(
      minWidth: 46,
      minHeight: kWindowTitleBarHeight,
    ),
  }) : builder = ((context, color) => RestoreIcon(color: color));

  WindowButton.maximize({
    super.key,
    this.onTap,
    this.buttonColor = const WindowButtonColor.light(),
    this.animated = false,
    this.animationCurve = Curves.linear,
    this.animationDuration = const Duration(milliseconds: 120),
    this.constraints = const BoxConstraints(
      minWidth: 46,
      minHeight: kWindowTitleBarHeight,
    ),
  }) : builder = ((context, color) => MaximizeIcon(color: color));

  WindowButton.minimize({
    super.key,
    this.onTap,
    this.buttonColor = const WindowButtonColor.light(),
    this.animated = false,
    this.animationCurve = Curves.linear,
    this.animationDuration = const Duration(milliseconds: 120),
    this.constraints = const BoxConstraints(
      minWidth: 46,
      minHeight: kWindowTitleBarHeight,
    ),
  }) : builder = ((context, color) => MinimizeIcon(color: color));

  final VoidCallback? onTap;
  final WindowButtonColor buttonColor;
  final bool animated;
  final Duration animationDuration;
  final Curve animationCurve;
  final BoxConstraints constraints;
  final WindowButtonBuilder builder;

  @override
  State<WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<WindowButton> {
  var _isHover = false;
  var _isTapDown = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isTapDown
        ? widget.buttonColor.mouseDown
        : _isHover
            ? widget.buttonColor.mouseOver
            : widget.buttonColor.normal;
    final iconColor = _isTapDown
        ? widget.buttonColor.iconMouseDown
        : _isHover
            ? widget.buttonColor.iconMouseOver
            : widget.buttonColor.iconNormal;

    final Widget icon;
    if (widget.animated) {
      icon = TweenAnimationBuilder(
        tween: ColorTween(end: iconColor),
        duration: widget.animationDuration,
        builder: (context, color, child) =>
            widget.builder(context, color ?? iconColor),
      );
    } else {
      icon = Builder(builder: (context) => widget.builder(context, iconColor));
    }

    return MouseRegion(
      onExit: (value) => setState(() => _isHover = false),
      onHover: (value) => setState(() => _isHover = true),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isTapDown = true),
        onTapCancel: () => setState(() => _isTapDown = false),
        onTapUp: (_) => setState(() => _isTapDown = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: widget.animationDuration,
          curve: widget.animationCurve,
          color: backgroundColor,
          constraints: widget.constraints,
          child: Center(child: icon),
        ),
      ),
    );
  }
}
