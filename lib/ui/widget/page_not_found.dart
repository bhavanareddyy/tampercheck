 
import 'package:flutter/material.dart';

import '../../locale.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          S.of(context).pageNotFound,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.blueGrey),
        ),
      ),
    );
  }
}
