import 'package:flutter/material.dart';
import 'package:flutter_study/common/layout/default_layout.dart';

class RootTab extends StatelessWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: Center(
        child: Text('Root tab'),
      ),
    );
  }
}
