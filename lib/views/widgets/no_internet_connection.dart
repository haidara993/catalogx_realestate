import 'package:catalog/views/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class NoInternetConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 30,
            ),
            CustomText(
              text: 'Please check your internet connection..',
              fontSize: 16,
              alignment: Alignment.center,
            ),
          ],
        ),
      ),
    );
  }
}
