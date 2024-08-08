import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'package:logger/logger.dart';

import 'app.dart';

final logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: '.env');

  runApp(const StonksApp());

  // logger.t("This is a trace log");
  // logger.d("This is a debug log");
  // logger.i("This is an info log");
  // logger.w("This is a warning log");
  // logger.e("This is an error log", error: 'Test Error');
  // logger.f("This is a fatal log",
  //     error: Exception('Fatal Error'), stackTrace: StackTrace.current);
}
