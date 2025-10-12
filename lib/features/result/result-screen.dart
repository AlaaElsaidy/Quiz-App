import 'package:flutter/material.dart';
import 'package:quizzo/config/router/routes.dart';
import 'package:quizzo/config/screen_sizer/size_extension.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final int correct;
  final int wrong;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.total,
    required this.correct,
    required this.wrong,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percent = total == 0 ? 0 : (score / total) * 100;
    final bool passed = percent >= 50;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: context.h(400),
              decoration: BoxDecoration(
                color: const Color(0xFF1BC47D),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(context.w(28)),
                  bottomRight: Radius.circular(context.w(28)),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: context.w(28),
                    backgroundColor: const Color(0xFF2FE090),
                    child: Icon(
                      Icons.emoji_events,
                      size: context.w(34),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: context.h(12)),
                  Text(
                    'Congratulations!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.sp(30),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: context.h(6)),
                  Text(
                    'Quiz Completed',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: context.sp(18),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(20.0)),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(context.w(18)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: context.w(12),
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(20),
                      vertical: context.h(28),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Your Score',
                          style: TextStyle(
                            fontSize: context.sp(18),
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: context.h(15)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$score',
                              style: TextStyle(
                                fontSize: context.sp(50),
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: context.w(15)),
                            Text(
                              '/ $total',
                              style: TextStyle(
                                fontSize: context.h(24),
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.h(20)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w(14),
                            vertical: context.h(8),
                          ),
                          decoration: BoxDecoration(
                            color: passed
                                ? Colors.green.withOpacity(0.12)
                                : Colors.red.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(context.w(20)),
                          ),
                          child: Text(
                            '${percent.toStringAsFixed(0)}% - ${passed ? "Passed" : "Failed"}',
                            style: TextStyle(
                              color: passed
                                  ? Colors.green[800]
                                  : Colors.red[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: context.h(50)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatBox(
                              label: 'Correct',
                              value: correct.toString(),
                              color: Colors.green.withOpacity(0.12),
                              valueColor: Colors.green[700]!,
                            ),
                            _StatBox(
                              label: 'Wrong',
                              value: wrong.toString(),
                              color: Colors.red.withOpacity(0.08),
                              valueColor: Colors.red[700]!,
                            ),
                          ],
                        ),
                        SizedBox(height: context.h(50)),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.studentDashboard,
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1BC47D),
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(28),
                                vertical: context.h(12),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Back to dashboard',
                              style: TextStyle(
                                fontSize: context.sp(20),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color valueColor;

  const _StatBox({
    Key? key,
    required this.label,
    required this.value,
    required this.color,
    required this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w(150),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(10),
        vertical: context.h(30),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(context.w(12)),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          SizedBox(height: context.h(12)),
          Text(
            value,
            style: TextStyle(
              fontSize: context.sp(24),
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
