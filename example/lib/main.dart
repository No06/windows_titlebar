import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_titlebar/windows_titlebar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  const windowSize = Size(500, 200);
  final windowOptions = WindowOptions(
    size: windowSize,
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle:
        Platform.isWindows ? TitleBarStyle.hidden : TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kWindowCaptionHeight),
          child: _WindowTitleBar(),
        ),
        body: Center(
          child: TextButton(
            onPressed: () {},
            child: const Text("Switch Theme"),
          ),
        ),
      ),
    );
  }
}

class _WindowTitleBar extends StatefulWidget {
  const _WindowTitleBar();

  @override
  State<_WindowTitleBar> createState() => _WindowTitleBarState();
}

class _WindowTitleBarState extends State<_WindowTitleBar> with WindowListener {
  late final ValueNotifier<FutureOr<bool>> isMaximized;

  @override
  void initState() {
    super.initState();
    isMaximized = ValueNotifier(windowManager.isMaximized());
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    isMaximized.dispose();
    super.dispose();
  }

  @override
  void onWindowMaximize() => isMaximized.value = true;

  @override
  void onWindowUnmaximize() => isMaximized.value = false;

  @override
  Widget build(BuildContext context) {
    final windowButtonColor = () {
      switch (Theme.of(context).brightness) {
        case Brightness.dark:
          return const WindowButtonColor.dark();
        case Brightness.light:
          return const WindowButtonColor.light();
      }
    }();

    final closeWindowButtonColor = () {
      switch (Theme.of(context).brightness) {
        case Brightness.dark:
          return const WindowButtonColor.closeDark();
        case Brightness.light:
          return const WindowButtonColor.closeLight();
      }
    }();

    return WindowTitleBar(
      title: const DragToMoveArea(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text("Window Title"),
          ),
        ),
      ),
      actions: [
        // Custom Button
        const WindowButton(
          icon: Icon(Icons.settings),
          color: Colors.blue,
          mouseOverColor: Colors.green,
          mouseDownColor: Colors.amber,
          animated: true,
        ),
        WindowButton.minimize(
          buttonColor: windowButtonColor,
          onTap: windowManager.minimize,
        ),
        ValueListenableBuilder(
          valueListenable: isMaximized,
          builder: (context, isMaximized, child) {
            Widget builder(bool isMaximized) {
              if (isMaximized) {
                return WindowButton.unmaximize(
                  buttonColor: windowButtonColor,
                  onTap: windowManager.unmaximize,
                );
              }
              return WindowButton.maximize(
                buttonColor: windowButtonColor,
                onTap: windowManager.maximize,
              );
            }

            if (isMaximized is Future<bool>) {
              return FutureBuilder(
                future: isMaximized,
                builder: (context, snapshot) {
                  final isMaximized = snapshot.data ?? false;
                  return builder(isMaximized);
                },
              );
            }
            return builder(isMaximized);
          },
        ),
        WindowButton.close(
          buttonColor: closeWindowButtonColor,
          onTap: windowManager.close,
        ),
      ],
    );
  }
}
