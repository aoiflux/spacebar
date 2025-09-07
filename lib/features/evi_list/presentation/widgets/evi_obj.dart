import 'package:flutter/material.dart';
import 'dart:collection';

class EviObject extends StatefulWidget {
  final String evi;
  // Using HashMap here to match your domain entity; adjust if needed.
  final HashMap<String, List<String>> partitionMap;

  const EviObject({super.key, required this.evi, required this.partitionMap});

  @override
  State<EviObject> createState() => _EviObjectState();
}

class _EviObjectState extends State<EviObject> {
  bool expanded = false;
  final Set<String> expandedPartitions = {};

  void togglePartition(String key) {
    setState(() {
      if (expandedPartitions.contains(key)) {
        expandedPartitions.remove(key);
      } else {
        expandedPartitions.add(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => setState(() => expanded = !expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Evidence card header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🗂️ Evidence: ${widget.evi}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    expanded ? Icons.expand_more : Icons.chevron_right,
                    color: Colors.grey[300],
                  ),
                ],
              ),
              if (expanded)
                ...widget.partitionMap.entries.map((entry) {
                  final partitionKey = entry.key;
                  final isExpanded = expandedPartitions.contains(partitionKey);
                  return Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252525),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade700),
                    ),
                    child: InkWell(
                      onTap: () => togglePartition(partitionKey),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Partition header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "📦 Partition: $partitionKey",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.expand_more
                                    : Icons.chevron_right,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                          if (isExpanded)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  entry.value.asMap().entries.map((e) {
                                    return Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2F2F2F),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      child: Text(
                                        "${e.key} — Indexed: ${e.value}",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
