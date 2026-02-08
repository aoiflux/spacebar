import 'package:flutter/material.dart';
import 'package:spacebar/core/common/models/progress_state.dart';

class StepProgressWidget extends StatelessWidget {
  final ProgressUpdate currentProgress;

  const StepProgressWidget({super.key, required this.currentProgress});

  // Layout constants
  static const double _containerPadding = 32.0;
  static const double _progressBarHeight = 8.0;
  static const double _progressBarRadius = 12.0;
  static const double _stageIndicatorSize = 40.0;
  static const double _stageSpacing = 16.0;
  static const double _connectorHeight = 16.0;
  static const double _connectorWidth = 2.0;
  static const double _connectorLeftPadding = 20.0;

  String _getStageName(ProgressStage stage) {
    switch (stage) {
      case ProgressStage.init:
        return "Initializing...";
      case ProgressStage.hashing:
        return 'Calculating hash...';
      case ProgressStage.hashDone:
        return '✓ Hash complete';
      case ProgressStage.appendCheck:
        return 'Checking existing data...';
      case ProgressStage.streaming:
        return 'Streaming file...';
      case ProgressStage.streamDone:
        return '✓ Upload complete';
    }
  }

  Color _getStageColor(ProgressStage stage) {
    final currentStage = currentProgress.stage;

    if (stage == currentStage) return Colors.blue;
    if (stage.index < currentStage.index) return Colors.green;
    return Colors.grey;
  }

  bool _isStageActive(ProgressStage stage) {
    return stage == currentProgress.stage;
  }

  bool _isStageCompleted(ProgressStage stage) {
    return stage.index < currentProgress.stage.index;
  }

  @override
  Widget build(BuildContext context) {
    final stages = ProgressStage.values;
    final currentStageIndex = currentProgress.stage.index;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(_containerPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOverallProgressBar(stages, currentStageIndex),
            const SizedBox(height: _containerPadding),
            _buildStagesList(context, stages, currentStageIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallProgressBar(
    List<ProgressStage> stages,
    int currentStageIndex,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_progressBarRadius),
      child: LinearProgressIndicator(
        value: (currentStageIndex + 0.5) / stages.length,
        minHeight: _progressBarHeight,
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
      ),
    );
  }

  Widget _buildStagesList(
    BuildContext context,
    List<ProgressStage> stages,
    int currentStageIndex,
  ) {
    return Column(
      children: List.generate(stages.length, (index) {
        final stage = stages[index];
        final isLastStage = index == stages.length - 1;

        return Column(
          children: [
            _buildStageRow(context, stage, index),
            if (!isLastStage) _buildStageConnector(index, currentStageIndex),
            const SizedBox(height: 8),
          ],
        );
      }),
    );
  }

  Widget _buildStageRow(BuildContext context, ProgressStage stage, int index) {
    final isActive = _isStageActive(stage);
    final isCompleted = _isStageCompleted(stage);

    return Row(
      children: [
        _buildStageIndicator(context, stage, index, isActive, isCompleted),
        const SizedBox(width: _stageSpacing),
        Expanded(child: _buildStageContent(context, stage, isActive)),
      ],
    );
  }

  Widget _buildStageIndicator(
    BuildContext context,
    ProgressStage stage,
    int index,
    bool isActive,
    bool isCompleted,
  ) {
    return Container(
      width: _stageIndicatorSize,
      height: _stageIndicatorSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getStageColor(stage),
        border: Border.all(
          color: isActive ? Colors.blue[800]! : Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: _buildIndicatorIcon(context, index, isActive, isCompleted),
      ),
    );
  }

  Widget _buildIndicatorIcon(
    BuildContext context,
    int index,
    bool isActive,
    bool isCompleted,
  ) {
    if (isCompleted) {
      return const Icon(Icons.check, color: Colors.white, size: 22);
    }

    if (isActive) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return Text(
      '${index + 1}',
      style: Theme.of(
        context,
      ).textTheme.labelSmall?.copyWith(color: Colors.white),
    );
  }

  Widget _buildStageContent(
    BuildContext context,
    ProgressStage stage,
    bool isActive,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStageTitle(context, stage, isActive),
        if (isActive && _shouldShowStreamingProgress(stage))
          _buildStreamingProgress(context),
        if (isActive && currentProgress.message != null)
          _buildStageMessage(context),
      ],
    );
  }

  Widget _buildStageTitle(
    BuildContext context,
    ProgressStage stage,
    bool isActive,
  ) {
    return Text(
      _getStageName(stage),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        color: isActive ? Colors.blue[800] : null,
      ),
    );
  }

  bool _shouldShowStreamingProgress(ProgressStage stage) {
    return currentProgress.progress != null && stage == ProgressStage.streaming;
  }

  Widget _buildStreamingProgress(BuildContext context) {
    final progress = currentProgress.progress ?? 0;
    final percentageText = '${(progress * 100).toStringAsFixed(1)}%';

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
            ),
          ),
          const SizedBox(height: 4),
          Text(percentageText, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }

  Widget _buildStageMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        currentProgress.message!,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStageConnector(int index, int currentStageIndex) {
    final isCompleted = index < currentStageIndex;

    return Padding(
      padding: const EdgeInsets.only(left: _connectorLeftPadding, top: 8.0),
      child: Container(
        width: _connectorWidth,
        height: _connectorHeight,
        color: isCompleted ? Colors.green : Colors.grey[300],
      ),
    );
  }
}
