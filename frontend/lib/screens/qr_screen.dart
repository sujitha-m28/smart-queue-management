import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatelessWidget {
  const QRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      body: Stack(
        children: [
          // Soft gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFE3EF),
                  Color(0xFFFFF5FA),
                  Color(0xFFFDE7F3),
                ],
              ),
            ),
          ),

          // Decorative floating blobs
          Positioned(
            top: -60,
            left: -50,
            child: _blob(const Color(0xFFFFC1D9), 190),
          ),
          Positioned(
            top: 140,
            right: -80,
            child: _blob(const Color(0xFFFFD9E8), 150),
          ),
          Positioned(
            bottom: -90,
            left: -60,
            child: _blob(const Color(0xFFFFB6D0), 210),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom back + title row
                  Row(
                    children: [
                      _iconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Smart Trial Room",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9C4A6E),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Hero header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF8FB8), Color(0xFFFFC1D9)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF69A4).withOpacity(0.35),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Text("💕", style: TextStyle(fontSize: 32)),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Scan to Join Queue",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF7A2E4F),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Point your camera at the code below ✨",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF9C4A6E).withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 45),

                  // QR card
                  Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.9),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF69A4).withOpacity(0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // QR framed in a soft pink circle-ish container
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5FA),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFFFFD9E8),
                              width: 1.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: QrImageView(
data: "http://192.168.0.105:3000/#/join",
                              version: QrVersions.auto,
                              size: 240,
                              backgroundColor: Colors.white,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: Color(0xFF7A2E4F),
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Color(0xFF7A2E4F),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Divider with heart
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: const Color(0xFFFFD9E8),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text("💗", style: TextStyle(fontSize: 16)),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: const Color(0xFFFFD9E8),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Scan this QR code to join\nthe trial room queue",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7A2E4F),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Footer hint
                  Center(
                    child: Text(
                      "Open your camera app or scan from within the app",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF9C4A6E).withOpacity(0.6),
                      ),
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

  // ---------- Helper widgets ----------

  static Widget _blob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.55),
        shape: BoxShape.circle,
      ),
    );
  }

  static Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.7),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 18, color: const Color(0xFF9C4A6E)),
        ),
      ),
    );
  }
}