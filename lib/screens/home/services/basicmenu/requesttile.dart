import 'package:flutter/material.dart';
import 'package:sugoapp/screens/home/services/requesterrand/chooseErrand.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/defaultbutton.dart';
import 'package:sugoapp/shared/widgets.dart';

class RequestButtonTile extends StatelessWidget {
  final img = 'images/icons/Request a service.png';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: getMediaQueryHeightViaDivision(context, 4),
                  width: getMediaQueryWidthViaDivision(context, 2),
                  decoration: BoxDecoration(
                      color: Colors.blue[20],
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                          image: ExactAssetImage(img), fit: BoxFit.fill)),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        buildLabelText(
                            'Post your errand and ask others for help.',
                            14.0,
                            Colors.black,
                            FontWeight.normal),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: DefaultButton(
                      callback: () {
                        print('request');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChooseRequestErrand()));
                      },
                      label: 'Request now',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
