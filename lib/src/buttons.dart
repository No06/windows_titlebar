import 'package:flutter/material.dart';
import 'package:windows_titlebar/src/color.dart';
import 'package:windows_titlebar/src/icons.dart';

const kWindowTitleBarHeight = 32.0;

class WindowButton extends StatefulWidget {
  const WindowButton({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
    this.mouseOverColor,
    this.mouseDownColor,
    this.animated,
    this.animatedTime,
    this.constraints,
  })  : _type = null,
        buttonColor = null;

  const WindowButton.close({
    super.key,
    this.onTap,
    this.buttonColor = const WindowButtonColor.closeLight(),
    this.animated,
    this.animatedTime,
    this.constraints,
  })  : _type = _ButtonType.close,
        color = null,
        mouseDownColor = null,
        mouseOverColor = null,
        icon = null;

  const WindowButton.unmaximize({
    super.key,
    this.onTap,
    this.buttonColor = const WindowButtonColor.light(),
    this.animated,
    this.animatedTime,
    this.constraints,
  })  : _type = _ButtonType.unmaximize,
        color = null,
        mouseDownColor = null,
        mouseOverColor = null,
        icon = null;

  const WindowButton.maximize({
    super.key,
    this.onTap,
    this.buttonColor = const WindowButtonColor.light(),
    this.animated,
    this.animatedTime,
    this.constraints,
  })  : _type = _ButtonType.maximize,
        color = null,
        mouseDownColor = null,
        mouseOverColor = null,
        icon = null;

  const WindowButton.minimize({
    super.key,
    this.onTap,
    this.buttonColor = const WindowButtonColor.light(),
    this.animated,
    this.animatedTime,
    this.constraints,
  })  : _type = _ButtonType.minimize,
        color = null,
        mouseOverColor = null,
        mouseDownColor = null,
        icon = null;

  final Widget? icon;
  final VoidCallback? onTap;
  final Color? color;
  final Color? mouseOverColor;
  final Color? mouseDownColor;
  final WindowButtonColor? buttonColor;
  final bool? animated;
  final int? animatedTime;
  final _ButtonType? _type;
  final BoxConstraints? constraints;

  @override
  State<WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<WindowButton> {
  Duration get _duration => widget.animated ?? false
      ? Duration(milliseconds: widget.animatedTime ?? 120)
      : Duration.zero;

  final state = _ButtonState();

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.buttonColor ?? const WindowButtonColor.light();

    backgroundColor() {
      if (state.onTap) {
        return widget.mouseDownColor ?? buttonColor.mouseDown;
      }
      if (state.isHover) {
        return widget.mouseOverColor ?? buttonColor.mouseOver;
      }
      return widget.color ?? buttonColor.normal;
    }

    iconColor() {
      if (state.onTap) return buttonColor.iconMouseDown;
      if (state.isHover) return buttonColor.iconMouseOver;
      return buttonColor.iconNormal;
    }

    defaultIcon() {
      switch (widget._type!) {
        case _ButtonType.close:
          return CloseIcon(color: iconColor());
        case _ButtonType.unmaximize:
          return RestoreIcon(color: iconColor());
        case _ButtonType.maximize:
          return MaximizeIcon(color: iconColor());
        case _ButtonType.minimize:
          return MinimizeIcon(color: iconColor());
      }
    }

    ;

    return MouseRegion(
      onExit: (value) => state.isHover = false,
      onHover: (value) => state.isHover = true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => state.onTap = true,
        onTapCancel: () => state.onTap = false,
        onTapUp: (_) => state.onTap = false,
        onTap: widget.onTap,
        child: ListenableBuilder(
          listenable: state,
          builder: (context, child) => AnimatedContainer(
            duration: _duration,
            curve: Curves.linear,
            color: backgroundColor(),
            constraints: widget.constraints ??
                const BoxConstraints(
                    minWidth: 46, minHeight: kWindowTitleBarHeight),
            child: Center(child: widget.icon ?? defaultIcon()),
          ),
        ),
      ),
    );
  }
}

class _ButtonState with ChangeNotifier {
  var _isHover = false;
  bool get isHover => _isHover;
  set isHover(bool newVal) {
    _isHover = newVal;
    notifyListeners();
  }

  var _onTap = false;
  bool get onTap => _onTap;
  set onTap(bool newVal) {
    _onTap = newVal;
    notifyListeners();
  }
}

enum _ButtonType {
  close,
  unmaximize,
  maximize,
  minimize,
}
