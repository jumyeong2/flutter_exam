import 'package:flutter/material.dart';
import 'simulation_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Light background color
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 30),
                          // Header: Logo and text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/coSync.png',
                                width: 50, // Slightly smaller for elegance
                                height: 50,
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "CoSync",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF9E9E9E), // Softer grey
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    "코싱크",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF212121),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // Main Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(28.0), // More padding
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                24,
                              ), // Softer corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    0.04,
                                  ), // Lighter shadow
                                  blurRadius: 30, // Softer blur
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Inner Box (Ticket/Folder style)
                                Container(
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFF5F7FA,
                                    ), // Soft grey fill
                                    borderRadius: BorderRadius.circular(18),
                                    // Removed border for cleaner look
                                  ),
                                  child: Row(
                                    children: [
                                      // Icon Placeholder Box
                                      Container(
                                        width: 52,
                                        height: 52,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.03,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.handshake_outlined,
                                          size: 28,
                                          color: const Color(0xFF64B5F6),
                                        ),
                                      ),
                                      const SizedBox(width: 18),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Co-Founding Fit Test",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF212121),
                                                letterSpacing: -0.3,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "우리는 같은 기준으로 움직이고 있을까?",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF757575),
                                                height: 1.3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // List Items
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      _buildListItem("나의 협업 성향"),
                                      const SizedBox(height: 12),
                                      _buildListItem("팀 내 갈등 요인"),
                                      const SizedBox(height: 12),
                                      _buildListItem("현재 필요한 합의 목록"),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // 2x2 Grid Pills
                                Row(
                                  children: [
                                    Expanded(child: _buildGridPill("#성향 진단")),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildGridPill("#리스크 감지")),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(child: _buildGridPill("#갭 인식")),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildGridPill("#합의 문문화")),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Bottom Section
                      Column(
                        children: [
                          // Bottom Button
                          Container(
                            width: double.infinity,
                            height: 60, // Taller button
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF64B5F6,
                                  ).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SimulationScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFF64B5F6,
                                ), // Pastel Blue
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "지금 바로 진단 시작",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Footer Text
                          const Text(
                            "3분 소요 · 공동창업자(파트너)에게 결과를 공유하세요",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9E9E9E),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Row(
      children: [
        Icon(Icons.check_circle, size: 16, color: Colors.blueGrey[200]),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF424242),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildGridPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Neutral grey background
        borderRadius: BorderRadius.circular(14),
        // Removed border for cleaner modern look
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF616161),
        ),
      ),
    );
  }
}
