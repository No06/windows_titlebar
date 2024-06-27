import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_titlebar/windows_titlebar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  final windowOptions = WindowOptions(
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
  final isMaximized = ValueNotifier<bool?>(null);

  @override
  void initState() {
    super.initState();
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
      title: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text("Window Title"),
        ),
      ),
      actions: [
        WindowButton.minimize(
          buttonColor: windowButtonColor,
          onTap: windowManager.minimize,
        ),
        FutureBuilder(
          future: windowManager.isMaximized(),
          builder: (context, snapshot) => ValueListenableBuilder(
            valueListenable: isMaximized,
            builder: (context, isMaximized, child) {
              isMaximized = isMaximized ??= snapshot.hasData && snapshot.data!;
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
            },
          ),
        ),
        WindowButton.close(
          buttonColor: closeWindowButtonColor,
          onTap: windowManager.close,
        ),
      ],
    );
  }
}
