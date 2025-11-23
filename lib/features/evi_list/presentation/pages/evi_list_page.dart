import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacebar/core/common/widgets/loader.dart';
import 'package:spacebar/core/utils/show_snackbar.dart';
import 'package:spacebar/features/evi_list/presentation/bloc/evi_bloc/evi_bloc.dart';

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
      body: BlocConsumer<EviBloc, EviState>(
        listener: (context, state) {
          if (state is EviFailure) {
            showSnackBar(context, state.msg);
          }
        },

        builder: (context, state) {
          if (state is EviLoading) {
            return Loader();
          }
          if (state is EviSuccessStore) {
            return Placeholder();
          }
          if (state is EviSuccessList) {
            return Placeholder();
          }
          return Placeholder();
        },
      ),
    );
  }
}
