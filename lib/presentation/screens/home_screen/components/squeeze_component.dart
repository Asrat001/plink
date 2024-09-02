import 'package:flutter/material.dart';

class SqueezeAnimationExample extends StatefulWidget {
  @override
  _SqueezeAnimationExampleState createState() =>
      _SqueezeAnimationExampleState();
}

class _SqueezeAnimationExampleState extends State<SqueezeAnimationExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  bool _isSqueezed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _sizeAnimation =
        Tween<double>(begin: 1.0, end: 0.5).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _toggleAnimation() {
    if (_isSqueezed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isSqueezed = !_isSqueezed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Squeeze Animation')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _toggleAnimation,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: 200 * _sizeAnimation.value,
                    height: 200 * _sizeAnimation.value,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: Text(
                      'Tap Me!',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleAnimation,
              child: Text('Toggle Animation'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
