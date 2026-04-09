import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:desktop_drop/desktop_drop.dart';
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
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const EviListPage())),
              icon: const Icon(Icons.list_outlined),
              label: const Text('View Evidence List'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
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
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.cloud_upload_outlined,
        size: 40,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Upload Your Files',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      'Securely store and manage your files with advanced encryption, deduplication, and smart compression',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
        onEnter: (_) {
          if (!_isDragHovering) setState(() => _isDragHovering = true);
        },
        onExit: (_) {
          if (_isDragHovering) setState(() => _isDragHovering = false);
        },
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
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.04)
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.02),
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
                'or tap the button below',
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
    );
  }

  Widget _buildWebDropZone(BuildContext context) {
    return Stack(
      children: [
        DropzoneView(
          onCreated: (controller) {},
          onHover: () {
            setState(() => _isDragHovering = true);
          },
          onLeave: () {
            setState(() => _isDragHovering = false);
          },
          onDropFile: (file) {
            setState(() => _isDragHovering = false);
            final pickedFile = PickedFileData(
              name: file.name,
              platformFile: file.getNative(),
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
                    'or tap the button below',
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

  Widget _buildHint(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          message: 'Use the floating button to add a file',
          child: Opacity(
            opacity: 0.6,
            child: Text(
              '💡 Tip: Use the button in the bottom right corner',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 6),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
