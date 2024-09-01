import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slam_pakistan_1/Pages/reg_screen.dart';

class AnimatedApplyButton extends StatefulWidget {
  const AnimatedApplyButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedApplyButtonState createState() => _AnimatedApplyButtonState();
}

class _AnimatedApplyButtonState extends State<AnimatedApplyButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTapDown: (_) => _onPressed(true),
        onTapUp: (_) => _onPressed(false),
        onTapCancel: () => _onPressed(false),
        child: GestureDetector(
          onTap: () {
            Get.to(RegistrationForm());
          },
          child: AnimatedContainer(
            width: 150,
            duration: const Duration(milliseconds: 100),
            curve: Curves.bounceOut,
            padding: EdgeInsets.symmetric(
              horizontal: _isHovered ? 30 : 25,
              vertical: _isHovered ? 18 : 15,
            ),
            decoration: BoxDecoration(
              color: _isPressed ? Colors.orange.shade700 : Colors.orangeAccent,
              borderRadius: BorderRadius.zero,
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: Colors.orangeAccent.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: const Center(
              child: Text(
                'Apply',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  void _onPressed(bool isPressed) {
    setState(() {
      _isPressed = isPressed;
    });
  }
}
