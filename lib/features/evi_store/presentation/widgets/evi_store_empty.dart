import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/features/evi_list/presentation/pages/evi_list_page.dart';

class EviStoreEmpty extends StatefulWidget {
  final VoidCallback onStorePressed;
  final Function(PickedFileData)? onFilesDropped;

  const EviStoreEmpty({
    super.key,
    required this.onStorePressed,
    this.onFilesDropped,
  });

  @override
  State<EviStoreEmpty> createState() => _EviStoreEmptyState();
}

class _EviStoreEmptyState extends State<EviStoreEmpty> {
  bool _isDragHovering = false;
  DropzoneViewController? _dropzoneController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          _buildUploadIcon(context),
          const SizedBox(height: 12),
          _buildTitle(context),
          const SizedBox(height: 2),
          _buildDescription(context),
          const SizedBox(height: 12),
          Expanded(child: _buildDragDropArea(context)),
          const SizedBox(height: 12),
          _buildFeatures(context),
          const SizedBox(height: 8),
          _buildHint(context),
          const SizedBox(height: 16),

          // Navigation Button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const EviListPage())),
              icon: const Icon(
                Icons.list_outlined,
                size: 16,
                color: Color(0xFF0B57D0),
              ),
              label: const Text(
                'View Evidence List',
                style: TextStyle(
                  color: Color(0xFF0B57D0),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(
                  0xFF0B57D0,
                ).withValues(alpha: 0.08),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: const Color(0xFF0B57D0).withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B57D0), Color(0xFF0946B0)],
        ),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x440B57D0),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(
        Icons.cloud_upload_outlined,
        size: 38,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Upload Evidence File',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: const Color(0xFF0F1C2E),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      'Securely store and manage evidence files with hash-based deduplication, smart compression, and chain-of-custody preservation.',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF52637A),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDragDropArea(BuildContext context) {
    if (kIsWeb) {
      return _buildWebDropZone(context);
    }
    return _buildDesktopDropZone(context);
  }

  Widget _buildDesktopDropZone(BuildContext context) {
    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragHovering = true),
      onDragExited: (_) => setState(() => _isDragHovering = false),
      onDragDone: (value) {
        setState(() => _isDragHovering = false);

        final picked = value.files.first;
        final pickedFile = PickedFileData(name: picked.name, path: picked.path);
        _handleDroppedFile(pickedFile);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          if (!_isDragHovering) setState(() => _isDragHovering = true);
        },
        onExit: (_) {
          if (_isDragHovering) setState(() => _isDragHovering = false);
        },
        child: GestureDetector(
          onTap: _onDesktopDropzoneClicked,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: _isDragHovering
                    ? const Color(0xFF0B57D0)
                    : const Color(0xFFDDE5F0),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
              color: _isDragHovering
                  ? const Color(0xFF0B57D0).withValues(alpha: 0.06)
                  : const Color(0xFFFFFFFF).withValues(alpha: 0.6),
              boxShadow: _isDragHovering
                  ? [
                      BoxShadow(
                        color: const Color(0xFF0B57D0).withValues(alpha: 0.12),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: _isDragHovering ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.folder_open_outlined,
                    size: 36,
                    color: const Color(
                      0xFF0B57D0,
                    ).withValues(alpha: _isDragHovering ? 1.0 : 0.5),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Drag & drop files here',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF0B57D0),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'or tap the button below',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF52637A),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebDropZone(BuildContext context) {
    return Stack(
      children: [
        DropzoneView(
          onCreated: (controller) {
            _dropzoneController = controller;
          },
          onHover: () {
            setState(() => _isDragHovering = true);
          },
          onLeave: () {
            setState(() => _isDragHovering = false);
          },
          onDropFile: (file) async {
            setState(() => _isDragHovering = false);
            final controller = _dropzoneController;
            if (controller == null) {
              return;
            }

            final size = await controller.getFileSize(file);
            final stream = controller.getFileStream(file);

            final platformFile = PlatformFile(
              name: file.name,
              size: size,
              readStream: stream,
            );

            final pickedFile = PickedFileData(
              name: file.name,
              platformFile: platformFile,
            );
            _handleDroppedFile(pickedFile);
          },
        ),
        IgnorePointer(
          child: MouseRegion(
            onEnter: (_) => setState(() => _isDragHovering = true),
            onExit: (_) => setState(() => _isDragHovering = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isDragHovering
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
                color: _isDragHovering
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.04)
                    : Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.02),
                boxShadow: _isDragHovering
                    ? [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.08),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: _isDragHovering ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.folder_open_outlined,
                      size: 36,
                      color: Theme.of(context).colorScheme.primary.withValues(
                        alpha: _isDragHovering ? 1.0 : 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Drag & drop files here',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'or use the button below',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Clickable overlay for web file picker
        if (kIsWeb)
          Positioned.fill(
            child: GestureDetector(
              onTap: _onWebDropzoneClicked,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
      ],
    );
  }

  void _handleDroppedFile(PickedFileData fileData) {
    if (widget.onFilesDropped != null) {
      widget.onFilesDropped!(fileData);
    } else {
      widget.onStorePressed();
    }
  }

  Future<void> _onDesktopDropzoneClicked() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result == null || result.files.isEmpty) {
        return;
      }

      for (final file in result.files) {
        final pickedFile = PickedFileData(name: file.name, path: file.path);
        _handleDroppedFile(pickedFile);
      }
    } catch (e) {
      debugPrint('File picker error: $e');
    }
  }

  Future<void> _onWebDropzoneClicked() async {
    final controller = _dropzoneController;
    if (controller == null) {
      return;
    }

    try {
      final uploadedFiles = await controller.pickFiles();
      if (uploadedFiles.isEmpty) {
        return;
      }

      for (final file in uploadedFiles) {
        final size = await controller.getFileSize(file);
        final stream = controller.getFileStream(file);

        final platformFile = PlatformFile(
          name: file.name,
          size: size,
          readStream: stream,
        );

        final pickedFile = PickedFileData(
          name: file.name,
          platformFile: platformFile,
        );
        _handleDroppedFile(pickedFile);
      }
    } catch (e) {
      // File picker was cancelled or error occurred
      debugPrint('File picker error: $e');
    }
  }

  Widget _buildHint(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lightbulb_outline, size: 13, color: const Color(0xFF52637A)),
        const SizedBox(width: 6),
        Text(
          'Use the + button in the bottom right to pick a file',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: const Color(0xFF52637A)),
        ),
      ],
    );
  }

  Widget _buildFeatures(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                context,
                icon: Icons.lock_outlined,
                title: 'End-to-End Encryption',
                description: 'Military-grade encryption keeps your data secure',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildFeatureCard(
                context,
                icon: Icons.layers_outlined,
                title: 'Smart Deduplication',
                description: 'Eliminates duplicate data automatically',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                context,
                icon: Icons.compress_outlined,
                title: 'Hybrid Compression',
                description: 'Advanced compression reduces storage needs',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildFeatureCard(
                context,
                icon: Icons.storage_outlined,
                title: 'Efficient Storage',
                description: 'Store more with less space required',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDE5F0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: const Color(0xFF0B57D0)),
          const SizedBox(height: 6),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F1C2E),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFF52637A),
              height: 1.35,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
