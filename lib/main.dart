import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://a6e3cd6a1c9ed0b1c2bfbd39707534af@o4507937846657024.ingest.us.sentry.io/4507937965998080';
    options.tracesSampleRate = 0.01;

      },

    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentry Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SentryHomePage(),
    );
  }
}

class SentryHomePage extends StatelessWidget {
  const SentryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    makeError();
    return const Scaffold(
      body: Center(
        child: Text("Hi Sentry"),
      ),
    );
  }

 Future<void> makeError() async{
    try {
      String? firstName;
      String? lastName;
      print(firstName!+lastName!);
    } catch (exception, stackTrace) {
      Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    }
  }
}
