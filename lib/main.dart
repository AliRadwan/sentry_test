import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {

  if(kReleaseMode){
    // Initialize Sentry with enhanced configuration
    await SentryFlutter.init(
          (options) {
        options.dsn =
        'https://a6e3cd6a1c9ed0b1c2bfbd39707534af@o4507937846657024.ingest.us.sentry.io/4507937965998080';
        options.tracesSampleRate = 0.01; // Enable performance monitoring for all transactions
        // options.attachStacktrace = true; // Automatically attach stack traces to exceptions
        options.beforeSend = (event, hint) {
          // Modify or drop events before sending them to Sentry
          return event;
        };
        options.addInAppInclude('your.app.package'); // Include your app's package in the stack trace
      },
      appRunner: () => runApp(const MyApp()),
    );
  }else{
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentry Enhanced Demo',
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
    // Creating a Sentry transaction for performance monitoring
    Sentry.startTransaction(
      'homePageTransaction',
      'navigation',
      bindToScope: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sentry Enhanced Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Hi Sentry"),
            ElevatedButton(
              onPressed: () async {
                await makeError();
              },
              child: const Text('Trigger Error'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makeError() async {
    try {
      // Add a breadcrumb before the error happens
      Sentry.addBreadcrumb(Breadcrumb(
        message: 'About to make an error in makeError function',
        category: 'error',
        level: SentryLevel.info,
      ));

      String? firstName;
      String? lastName;
      print(firstName! + lastName!);
    } catch (exception, stackTrace) {
      // Capture additional context with the error
      Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setContexts('Custom Context', {'info': 'Additional error context'});
        },
      );
    }
  }
}
