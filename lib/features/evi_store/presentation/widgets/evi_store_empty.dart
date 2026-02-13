import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:desktop_drop/desktop_drop.dart';

class EviStoreEmpty extends StatefulWidget {
  final VoidCallback onStorePressed;
  final Function(String)? onFilesDropped;

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
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUploadIcon(context),
              const SizedBox(height: 32),
              _buildTitle(context),
              const SizedBox(height: 8),
              _buildDescription(context),
              const SizedBox(height: 48),
              _buildDragDropArea(context),
              const SizedBox(height: 48),
              _buildFeatures(context),
              const SizedBox(height: 32),
              _buildHint(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.cloud_upload_outlined,
        size: 56,
        color: Theme.of(context).colorScheme.primary,
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
    } else {
      return _buildDesktopDropZone(context);
    }
  }

  Widget _buildDesktopDropZone(BuildContext context) {
    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragHovering = true),
      onDragExited: (_) => setState(() => _isDragHovering = false),
      onDragDone: (value) {
        setState(() => _isDragHovering = false);
        _handleDroppedFile(value.files.first.path);
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
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
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
                  size: 48,
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
    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) {
        setState(() => _isDragHovering = true);
        return true;
      },
      onLeave: (data) {
        setState(() => _isDragHovering = false);
      },
      onAcceptWithDetails: (details) {
        setState(() => _isDragHovering = false);
        _handleDroppedFile(details.data.toString());
      },
      builder: (context, candidateData, rejectedData) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isDragHovering = true),
          onExit: (_) => setState(() => _isDragHovering = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
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
                    size: 48,
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
        );
      },
    );
  }

  void _handleDroppedFile(String filePath) {
    if (widget.onFilesDropped != null) {
      widget.onFilesDropped!(filePath);
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
            const SizedBox(width: 12),
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
        const SizedBox(height: 12),
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
            const SizedBox(width: 12),
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
      padding: const EdgeInsets.all(12),
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
          Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
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
