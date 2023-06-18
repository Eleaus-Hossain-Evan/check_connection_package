import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'bot_toast_widget.dart';

final connectivity = Provider((ref) => InternetConnectionChecker());

final connectivityStream = StreamProvider<InternetConnectionStatus>(
    (ref) => ref.watch(connectivity).onStatusChange);

final checkConnection = Provider((ref) {
  ref.watch(connectivityStream).whenData((status) {
    switch (status) {
      case InternetConnectionStatus.connected:
        print('Data connection is available.');
        BotToast.removeAll();
        break;
      default:
        print('You are disconnected from the internet.');
        showAttachedWidget(
          builder: (cancelFunc) {
            return AlertDialog(
              content: const Text(
                "No Internet Connection",
                textAlign: TextAlign.center,
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Retry"),
                  ),
                ),
              ],
            );
          },
        );
        break;
    }
  });

  return null;
});
