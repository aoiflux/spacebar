import 'dart:math';

String fmtBytes(int b) {
  if (b <= 0) return '0 B';
  const s = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB'];
  if (b < 1024) return '$b B';
  final rawIndex = (log(b) / log(1024)).floor();
  final i = min(rawIndex, s.length - 1);
  return '${(b / pow(1024, i)).toStringAsFixed(1)} ${s[i]}';
}
