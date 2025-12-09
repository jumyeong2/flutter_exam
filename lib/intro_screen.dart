import 'package:flutter/material.dart';
import 'simulation_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Light background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header: Logo and text
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/coSync.png', width: 60, height: 60),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "CoSync",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF757575),
                        ),
                      ),
                      Text(
                        "코싱크",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // Main Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Inner Box (Ticket/Folder style)
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(
                        children: [
                          // Icon Placeholder Box
                          Container(
                            width: 50,
                            height: 50,
                            // decoration: BoxDecoration(
                            //   border: Border.all(color: Colors.grey[400]!),
                            //   borderRadius: BorderRadius.circular(4),
                            // ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.handshake_outlined,
                              size: 40,
                              color: const Color.fromARGB(255, 70, 170, 232),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Co-Founding Fit Test",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF212121),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "우리는 같은 기준으로 움직이고 있을까?",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF757575),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // List Items
                    _buildListItem("나의 협업 성향"),
                    const SizedBox(height: 8),
                    _buildListItem("팀 내 갈등 요인"),
                    const SizedBox(height: 8),
                    _buildListItem("현재 필요한 합의 목록"),

                    const SizedBox(height: 24),

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

              const Spacer(),

              // Bottom Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimulationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF64B5F6), // Pastel Blue
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "지금 바로 진단 시작",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Footer Text
              const Text(
                "3분 소요 · 공동창업자(파트너)에게 결과를 공유하세요",
                style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Row(
      children: [
        const SizedBox(width: 16), // Indent slightly
        Container(
          width: 10,
          height: 1.5, // Thin dash
          color: Colors.black54,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF424242),
          ),
        ),
      ],
    );
  }

  Widget _buildGridPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // Very light blue
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFBBDEFB),
          width: 1,
        ), // Subtle border
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF424242),
        ),
      ),
    );
  }
}
