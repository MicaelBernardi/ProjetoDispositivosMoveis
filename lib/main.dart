import 'package:projeto_dispositivos_moveis/app_widget.dart';
import 'package:flutter/material.dart';

import 'core/database/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase().database;

  runApp(const MyApp());
}
