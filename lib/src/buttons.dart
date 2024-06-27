import 'package:flutter/material.dart';
import 'package:windows_titlebar/src/color.dart';
import 'package:windows_titlebar/src/icons.dart';

const kWindowTitleBarHeight = 32.0;

class WindowButton extends StatefulWidget {
  const WindowButton({
    super.key,
    required this.icon,
    this.onTap,
    this.brightness = Brightness.light,
    this.animated = false,
    this.animatedTime,
  })  : _type = null,
        color = null,
        darkColor = null;

  const WindowButton.close({
    super.key,
    this.onTap,
    this.brightness = Brightness.light,
    this.color = const WindowButtonColor.closeLight(),
    this.darkColor = const WindowButtonColor.closeDark(),
    this.animated = false,
    this.animatedTime,
  })  : _type = _ButtonType.close,
        icon = null;

  const WindowButton.unmaximize({
    super.key,
    this.onTap,
    this.brightness = Brightness.light,
    this.color = const WindowButtonColor.light(),
    this.darkColor = const WindowButtonColor.dark(),
    this.animated = false,
    this.animatedTime,
  })  : _type = _ButtonType.unmaximize,
        icon = null;

  const WindowButton.maximize({
    super.key,
    this.onTap,
    this.brightness = Brightness.light,
    this.color = const WindowButtonColor.light(),
    this.darkColor = const WindowButtonColor.dark(),
    this.animated = false,
    this.animatedTime,
  })  : _type = _ButtonType.maximize,
        icon = null;

  const WindowButton.minimize({
    super.key,
    this.onTap,
    this.brightness,
    this.color = const WindowButtonColor.light(),
    this.darkColor = const WindowButtonColor.dark(),
    this.animated = false,
    this.animatedTime,
  })  : _type = _ButtonType.minimize,
        icon = null;

  final Widget? icon;
  final VoidCallback? onTap;
  final Brightness? brightness;
  final WindowButtonColor? color;
  final WindowButtonColor? darkColor;
  final bool animated;
  final int? animatedTime;
  final _ButtonType? _type;

  @override
  State<WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<WindowButton> {
  late final brightness = widget.brightness ?? Theme.of(context).brightness;

  WindowButtonColor get _presetButtonColor => switch (brightness) {
        Brightness.dark => widget.darkColor!,
        Brightness.light => widget.color!,
      };

  Color get _presetBackgroundColor {
    if (state.onTap) return _presetButtonColor.mouseDown;
    if (state.isHover) return _presetButtonColor.mouseOver;
    return _presetButtonColor.normal;
  }

  Color get _presetIconColor {
    if (state.onTap) return _presetButtonColor.iconMouseDown;
    if (state.isHover) return _presetButtonColor.iconMouseOver;
    return _presetButtonColor.iconNormal;
  }

  Widget get _presetIcon {
    switch (widget._type!) {
      case _ButtonType.close:
        return CloseIcon(color: _presetIconColor);
      case _ButtonType.unmaximize:
        return RestoreIcon(color: _presetIconColor);
      case _ButtonType.maximize:
        return MaximizeIcon(color: _presetIconColor);
      case _ButtonType.minimize:
        return MinimizeIcon(color: _presetIconColor);
    }
  }

  Duration get _duration => widget.animated
      ? Duration(milliseconds: widget.animatedTime ?? 120)
      : Duration.zero;

  final state = _ButtonState();

  @override
  Widget build(BuildContext context) {
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
            color: _presetBackgroundColor,
            constraints: const BoxConstraints(minWidth: 46, minHeight: 32),
            child: Center(child: widget.icon ?? _presetIcon),
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
