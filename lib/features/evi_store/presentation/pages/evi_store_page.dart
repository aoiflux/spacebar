import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacebar/core/common/widgets/loader.dart';
import 'package:spacebar/core/utils/show_snackbar.dart';
import 'package:spacebar/features/evi_store/presentation/bloc/evi_store_bloc/evi_bloc.dart';

class EviListPage extends StatelessWidget {
  const EviListPage({super.key});

  void store(BuildContext context) async {
    final bloc = context.read<EviBloc>();
    final path = await _pickFile();
    if (path.isEmpty) {
      return;
    }
    bloc.add(EviStore(eviPath: path));
  }

  Future<String> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      return result.files.single.path!;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DUES")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => store(context),
        child: Icon(Icons.add),
      ),
      body: BlocConsumer<EviBloc, EviStoreState>(
        listener: (context, state) {
          if (state is EviStoreFailure) {
            showSnackBar(context, state.msg);
          }
        },

        builder: (context, state) {
          if (state is EviStoreLoading) {
            return Loader();
          }
          if (state is EviStoreSuccess) {
            return Placeholder();
          }
          return Placeholder();
        },
      ),
    );
  }
}
