import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/app_colors.dart';

/// C3. 태동 카운터
/// 실시간 타이머 + 탭 카운트 + 10회 도달 시 완료 다이얼로그
class KickCounterScreen extends StatefulWidget {
  const KickCounterScreen({super.key});

  @override
  State<KickCounterScreen> createState() => _KickCounterScreenState();
}

class _KickCounterScreenState extends State<KickCounterScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  int _kickCount = 0;
  bool _isRunning = false;
  bool _isCompleted = false;
  final List<DateTime> _kickTimes = [];

  static const int _targetKicks = 10;

  @override
  void initState() {
    super.initState();
    _startCounting();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCounting() {
    _stopwatch.start();
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _togglePause() {
    setState(() {
      if (_isRunning) {
        _stopwatch.stop();
        _timer?.cancel();
        _isRunning = false;
      } else {
        _stopwatch.start();
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (mounted) {
            setState(() {});
          }
        });
        _isRunning = true;
      }
    });
  }

  void _onTap() {
    if (!_isRunning || _isCompleted) return;

    HapticFeedback.mediumImpact();

    setState(() {
      _kickCount++;
      _kickTimes.insert(0, DateTime.now());
    });

    if (_kickCount >= _targetKicks) {
      _isCompleted = true;
      _stopwatch.stop();
      _timer?.cancel();
      _isRunning = false;
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    final elapsed = _stopwatch.elapsed;
    final minutes = elapsed.inMinutes;
    final seconds = elapsed.inSeconds % 60;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('🎉 10회 도달!', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$minutes분 $seconds초',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.coral,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '아기가 활발하게 움직이고 있어요',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop(); // 카운터 화면 닫기
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('확인'),
            ),
          ),
        ],
      ),
    );
  }

  void _endCounting() {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('태동 세기 종료'),
        content: Text('$_kickCount회 기록되었습니다.\n종료하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('계속하기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coral,
              foregroundColor: Colors.white,
            ),
            child: const Text('종료'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  String _formatElapsed() {
    final elapsed = _stopwatch.elapsed;
    final hours = elapsed.inHours.toString().padLeft(2, '0');
    final minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
        ),
        title: Text('태동 카운터', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),

          // 타이머 표시
          Text(
            '⏱️ ${_formatElapsed()}',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w300,
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),

          // 카운트 표시
          Text(
            '$_kickCount / $_targetKicks',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.coral,
            ),
          ),
          const SizedBox(height: 8),

          // 프로그레스 바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _kickCount / _targetKicks,
                backgroundColor: AppColors.coralLight,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.coral,
                ),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 탭 버튼
          GestureDetector(
            onTap: _onTap,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRunning ? AppColors.coral : AppColors.textHint,
                boxShadow: _isRunning
                    ? [
                        BoxShadow(
                          color: AppColors.coral.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _onTap,
                  customBorder: const CircleBorder(),
                  splashColor: Colors.white.withValues(alpha: 0.3),
                  child: const Center(
                    child: Text(
                      '👋\n탭!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 가이드 텍스트
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '2시간 내 10회 미만이면 의료진과 상의하세요',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.info),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 최근 태동 기록 리스트
          Expanded(
            child: _kickTimes.isEmpty
                ? Center(
                    child: Text(
                      '탭하면 태동이 기록돼요',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _kickTimes.length,
                    itemBuilder: (context, index) {
                      final time = _kickTimes[index];
                      final number = _kickTimes.length - index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.coralLight,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$number',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.coralDark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // 하단 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isCompleted ? null : _togglePause,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.textHint),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(_isRunning ? '일시정지' : '재개'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _endCounting,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textSecondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('종료'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
