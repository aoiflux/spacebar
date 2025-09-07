import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/features/evi_list/presentation/widgets/evi_obj.dart';

class EviObjectList extends StatelessWidget {
  final List<FileHierarchy> fileHierarchy;
  const EviObjectList({super.key, required this.fileHierarchy});

  @override
  Widget build(BuildContext context) {
    // Flatten each FileHierarchy's evis into a list of entries.
    final List<_EvidenceEntry> entries = [];
    for (final hierarchy in fileHierarchy) {
      for (final evi in hierarchy.evis) {
        entries.add(
          _EvidenceEntry(evi: evi, partitionMap: hierarchy.partitionMap),
        );
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return EviObject(evi: entry.evi, partitionMap: entry.partitionMap);
      },
    );
  }
}

// A helper class for flattening the list.
class _EvidenceEntry {
  final String evi;
  final HashMap<String, List<String>> partitionMap;
  _EvidenceEntry({required this.evi, required this.partitionMap});
}
