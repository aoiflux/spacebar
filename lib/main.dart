import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacebar/features/evi_list/presentation/bloc/evi_bloc/evi_bloc.dart';
import 'package:spacebar/features/evi_list/presentation/pages/evi_list_page.dart';
import 'package:spacebar/init_deps.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDeps();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => serviceLocator<EviBloc>())],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const EviListPage());
  }
}
