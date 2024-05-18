// Switched to CustomPaint icons by https://github.com/esDotDev

import 'dart:math';

import 'package:flutter/widgets.dart';

/// Close
class CloseIcon extends StatelessWidget {
  const CloseIcon({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Stack(children: [
        // Use rotated containers instead of a painter because it renders slightly crisper than a painter for some reason.
        Transform.rotate(
          angle: pi * .25,
          child: Center(
            child: ColoredBox(
              color: color,
              child: const SizedBox(width: 14, height: 1),
            ),
          ),
        ),
        Transform.rotate(
          angle: pi * -.25,
          child: Center(
            child: ColoredBox(
              color: color,
              child: const SizedBox(width: 14, height: 1),
            ),
          ),
        ),
      ]),
    );
  }
}

/// Maximize
class MaximizeIcon extends _PaintIcon {
  MaximizeIcon({super.key, required super.color})
      : super(
          painter: _MaximizePainter(color),
        );
}

class _MaximizePainter extends _IconPainter {
  _MaximizePainter(super.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTRB(1, 1, size.width, size.height), p);
  }
}

/// Restore
class RestoreIcon extends _PaintIcon {
  RestoreIcon({super.key, required super.color})
      : super(
          painter: _RestorePainter(color),
        );
}

class _RestorePainter extends _IconPainter {
  _RestorePainter(super.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTRB(0, 2, size.width - 2, size.height), p);
    canvas.drawLine(const Offset(2, 1), const Offset(2, 0), p);
    canvas.drawLine(const Offset(1, 0), Offset(size.width, 0), p);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height - 2), p);
    canvas.drawLine(
        Offset(size.width - 2, size.height - 2), Offset(size.width - 1, size.height - 2), p);
  }
}

/// Minimize
class MinimizeIcon extends _PaintIcon {
  MinimizeIcon({super.key, required super.color})
      : super(
          painter: _MinimizePainter(color),
        );
}

class _MinimizePainter extends _IconPainter {
  _MinimizePainter(super.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width + 0.1, size.height / 2),
      p,
    );
  }
}

/// Helpers
abstract class _IconPainter extends CustomPainter {
  _IconPainter(this.color) : p = _getPaint(color);

  final Color color;
  final Paint p;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PaintIcon extends StatelessWidget {
  const _PaintIcon({super.key, required this.color, required this.painter});

  final Color color;
  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: CustomPaint(size: const Size(10, 10), painter: painter),
    );
  }
}

Paint _getPaint(Color color, [bool isAntiAlias = false]) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..isAntiAlias = isAntiAlias
  ..strokeWidth = 1;
