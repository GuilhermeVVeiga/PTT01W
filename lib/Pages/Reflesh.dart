import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Cookie/SalveKey.dart';

class SplashPage extends StatefulWidget {
  Widget page;

  SplashPage({required this.page});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

String Keys = '';
class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.wait([
      PrefsService().isAuth(),PrefsService.GetKey()
    ]).then((value) {
      List isaut = [];
      value.forEach((element) {
        isaut.add(element);
      });
      Keys = isaut[1];
      if (isaut[0]) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget.page,));
      } else {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff2f2f2f),
      child: Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 245, 125, 13),
        ),
      ),
    );
  }
}
