import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:windows_titlebar/src/color.dart';
import 'package:windows_titlebar/src/icons.dart';

const kWindowTitleBarHeight = 32.0;

class WindowButton extends StatefulWidget {
  const WindowButton({
    super.key,
    required this.icon,
    this.onTap,
    this.color = const Color(0x00000000),
    this.brightness = Brightness.light,
    this.animated = false,
  })  : _type = null,
        buttonColor = null,
        darkButtonColor = null;

  const WindowButton.close({
    super.key,
    this.onTap,
    this.color = const Color(0x00000000),
    this.brightness = Brightness.light,
    this.buttonColor = const WindowButtonColor.closeLight(),
    this.darkButtonColor = const WindowButtonColor.closeDark(),
    this.animated = false,
  })  : _type = _ButtonType.close,
        icon = null;

  const WindowButton.unmaximize({
    super.key,
    this.onTap,
    this.color = const Color(0x00000000),
    this.brightness = Brightness.light,
    this.buttonColor = const WindowButtonColor.light(),
    this.darkButtonColor = const WindowButtonColor.dark(),
    this.animated = false,
  })  : _type = _ButtonType.unmaximize,
        icon = null;

  const WindowButton.maximize({
    super.key,
    this.onTap,
    this.color = const Color(0x00000000),
    this.brightness = Brightness.light,
    this.buttonColor = const WindowButtonColor.light(),
    this.darkButtonColor = const WindowButtonColor.dark(),
    this.animated = false,
  })  : _type = _ButtonType.maximize,
        icon = null;

  const WindowButton.minimize({
    super.key,
    this.onTap,
    this.color = const Color(0x00000000),
    this.brightness = Brightness.light,
    this.buttonColor = const WindowButtonColor.light(),
    this.darkButtonColor = const WindowButtonColor.dark(),
    this.animated = false,
  })  : _type = _ButtonType.minimize,
        icon = null;

  final Widget? icon;
  final VoidCallback? onTap;
  final Color? color;
  final Brightness brightness;
  final WindowButtonColor? buttonColor;
  final WindowButtonColor? darkButtonColor;
  final bool animated;
  final _ButtonType? _type;

  static const animatedTime = 120;

  @override
  State<WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<WindowButton> {
  WindowButtonColor get _buttonColor => switch (widget.brightness) {
        Brightness.dark => widget.darkButtonColor!,
        Brightness.light => widget.buttonColor!,
      };

  Color get _backgroundColor {
    if (state.onTap) return _buttonColor.mouseDown;
    if (state.isHover) return _buttonColor.mouseOver;
    return _buttonColor.normal;
  }

  Color get _iconColor {
    if (state.onTap) return _buttonColor.iconMouseDown;
    if (state.isHover) return _buttonColor.iconMouseOver;
    return _buttonColor.iconNormal;
  }

  Widget get _icon {
    switch (widget._type!) {
      case _ButtonType.close:
        return CloseIcon(color: _iconColor);
      case _ButtonType.unmaximize:
        return RestoreIcon(color: _iconColor);
      case _ButtonType.maximize:
        return MaximizeIcon(color: _iconColor);
      case _ButtonType.minimize:
        return MinimizeIcon(color: _iconColor);
    }
  }

  Duration get _duration => widget.animated
      ? const Duration(milliseconds: WindowButton.animatedTime)
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
            color: _backgroundColor,
            constraints: const BoxConstraints(minWidth: 46, minHeight: 32),
            child: Center(child: widget.icon ?? _icon),
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
