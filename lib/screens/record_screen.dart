//record_screen.dart
import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/surah.dart';
import '../theme/app_colors.dart';
import '../widgets/gradient_button.dart';
import '../widgets/waveform_widget.dart';
import 'verify_screen.dart';

class RecordScreen extends StatefulWidget {
  final Surah surah;

  const RecordScreen({super.key, required this.surah});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> with TickerProviderStateMixin {
  bool _isRecording = false;
  bool _hasRecording = false;
  int _timerSeconds = 0;
  Timer? _timer;
  final AudioRecorder _recorder = AudioRecorder();
  String? _audioPath;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _recorder.dispose();
    super.dispose();
  }

 Future<void> _toggleRecord() async {
  print("RECORD BUTTON CLICKED");
  if (_isRecording) {
    final path = await _recorder.stop();

    _timer?.cancel();
    _pulseController.stop();

    setState(() {
      _isRecording = false;
      _hasRecording = true;
      _audioPath = path;
    });
  } else {
    final hasPermission = await _recorder.hasPermission();
    print("Permission: $hasPermission");
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required')),
      );
      return;
    }

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/quran_recitation.wav';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
      ),
      path: path,
    );

    _timerSeconds = 0;
    _pulseController.repeat();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _timerSeconds++);
    });

    setState(() {
      _isRecording = true;
      _hasRecording = false;
      _audioPath = null;
    });
  }
}

  String get _formattedTime {
    final m = _timerSeconds ~/ 60;
    final s = _timerSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.4, -0.6),
            radius: 1.5,
            colors: [Color(0xFFF5E6C8), AppColors.bg, Color(0xFFF0DFC0)],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
                  child: Column(
                    children: [
                      // Ornament circle with Basmala
                      _buildOrnamentCircle(),
                      const SizedBox(height: 24),

                      // Timer + Waveform
                      _buildTimerBox(),
                      const SizedBox(height: 24),

                      // Record button
                      _buildRecordButton(),
                      const SizedBox(height: 20),

                      // Hint text
                      Text(
                        _isRecording
                            ? 'Recite clearly into your microphone...'
                            : _hasRecording
                                ? 'Tap Verify to check your recitation'
                                : "Tap Record when you're ready to begin",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMid,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Verify button
                      GradientButton(
                        label: '✦  Verify Recitation',
                        enabled: _hasRecording && _audioPath != null,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, a, __) => VerifyScreen(surah: widget.surah, audioFile: File(_audioPath!),),
                              transitionsBuilder: (_, a, __, child) => SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(parent: a, curve: Curves.easeOut)),
                                child: child,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF5E8CC), AppColors.bgCard],
          transform: GradientRotation(2.97),
        ),
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              '‹ Back',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.goldLight,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "NOW RECITING",
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 3,
              color: AppColors.goldLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.surah.arabic,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 32,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${widget.surah.name} · ${widget.surah.meaning}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMid,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _metaBadge('Surah ${widget.surah.number}'),
              const SizedBox(width: 8),
              _metaBadge('${widget.surah.verses} Verses'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metaBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.brown,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildOrnamentCircle() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.goldPale, Color(0xFFFFE8A0)],
        ),
        border: Border.all(color: AppColors.goldLight, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFFCF0), AppColors.bgDark],
            ),
          ),
          child: const Center(
            child: Text(
              '﷽',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                color: AppColors.gold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerBox() {
    return Column(
      children: [
        // Waveform or mic icon
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isRecording
              ? const WaveformWidget(key: ValueKey('wave'))
              : const Text(
                  '🎙',
                  key: ValueKey('mic'),
                  style: TextStyle(fontSize: 28),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          _formattedTime,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: AppColors.text,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedOpacity(
          opacity: _hasRecording ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.greenBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.greenBorder),
            ),
            child: const Text(
              '✓ Recording saved',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.green,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordButton() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse ring
          if (_isRecording)
            AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) {
                final scale = 1.0 + 0.18 * _pulseController.value;
                final opacity = 0.7 - 0.5 * _pulseController.value;
                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFC0392B).withOpacity(0.25),
                      ),
                    ),
                  ),
                );
              },
            ),
          // Button
          GestureDetector(
            onTap: _toggleRecord,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isRecording
                      ? const [Color(0xFFC0392B), Color(0xFFE74C3C)]
                      : const [AppColors.gold, AppColors.goldLight],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isRecording ? '⏹' : '⏺',
                    style: const TextStyle(fontSize: 22),
                  ),
                  Text(
                    _isRecording ? 'STOP' : 'RECORD',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
