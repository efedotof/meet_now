import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:meet_now_app/route/app_route.dart';

@RoutePage()
class LockedScreen extends StatelessWidget {
  const LockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 80, color: Colors.red),
              const SizedBox(height: 32),

              Text(
                "Вы были заблокированы",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Text(
                "Ваш аккаунт будет удален в течение 30 дней.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                "Для разблокировки или чтобы узнать причину блокировки, "
                "напишите в поддержку.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushRoute(SupportRoute());
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Обратиться в поддержку",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    if (Platform.isAndroid || Platform.isIOS) {
                      SystemNavigator.pop();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(),
                  ),
                  child: const Text(
                    "Выйти",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
