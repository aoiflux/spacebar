import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/core/common/widgets/step_progress_widget.dart';
import 'package:spacebar/core/utils/file_picker.dart';
import 'package:spacebar/core/utils/show_snackbar.dart';
import 'package:spacebar/features/evi_list/presentation/pages/evi_list_page.dart';
import 'package:spacebar/features/evi_store/presentation/bloc/evi_store_bloc/evi_store_bloc.dart';
import 'package:spacebar/features/evi_store/presentation/widgets/evi_store_empty.dart';
import 'package:spacebar/features/evi_store/presentation/widgets/evi_store_success.dart';

class EviStorePage extends StatelessWidget {
  final Evidence? initialEvidence;

  const EviStorePage({super.key, this.initialEvidence});

  void store(BuildContext context) async {
    final bloc = context.read<EviBloc>();
    final data = await pickFile();
    if (data == null) {
      return;
    }
    bloc.add(EviStore(eviData: data));
  }

  void _handleDroppedFile(BuildContext context, PickedFileData data) {
    final bloc = context.read<EviBloc>();
    bloc.add(EviStore(eviData: data));
  }

  void _goToEviList(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const EviListPage()));
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    // If initial evidence provided, show it directly without BLoC
    if (initialEvidence != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("DUES"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              onPressed: () => _goHome(context),
              tooltip: 'Home',
              icon: const Icon(Icons.home_outlined),
            ),
            IconButton(
              onPressed: () => _goToEviList(context),
              tooltip: 'Evidence List',
              icon: const Icon(Icons.list_outlined),
            ),
          ],
        ),
        body: EviStoreSuccessView(evidence: initialEvidence!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("DUES"),
        actions: [
          IconButton(
            onPressed: () => _goHome(context),
            tooltip: 'Home',
            icon: const Icon(Icons.home_outlined),
          ),
          IconButton(
            onPressed: () => _goToEviList(context),
            tooltip: 'Evidence List',
            icon: const Icon(Icons.list_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => store(context),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<EviBloc, EviStoreState>(
        listener: (context, state) {
          if (state is EviStoreFailure) {
            showSnackBar(context, state.msg);
          }
        },

        builder: (context, state) {
          if (state is EviStoreLoading) {
            return StepProgressWidget(currentProgress: state.progress);
          }
          if (state is EviStoreSuccess) {
            return EviStoreSuccessView(evidence: state.evidence);
          }
          return EviStoreEmpty(
            onStorePressed: () => store(context),
            onFilesDropped: (filePath) => _handleDroppedFile(context, filePath),
          );
        },
      ),
    );
  }
}
