import 'package:flutter/material.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

Widget header(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
        left: getMediaQueryWidthViaDivision(context, 20), top: 20.0),
    child: Column(
      children: <Widget>[
        buildLabelText('Services', 18.0, Colors.white, FontWeight.bold),
      ],
    ),
  );
}

Widget subheader(BuildContext context, {String focus}) {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 20),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: buildSubLabelText(
                  'Request',
                  14.0,
                  focus == 'Request' ? Colors.white : Colors.white30,
                  FontWeight.normal),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: buildSubLabelText(
                  'Current',
                  14.0,
                  focus == 'Current' ? Colors.white : Colors.white30,
                  FontWeight.normal),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: buildSubLabelText(
                  'Past',
                  14.0,
                  focus == 'Past' ? Colors.white : Colors.white30,
                  FontWeight.normal),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget subheaderPagination(BuildContext context, List<String> pages,
    {String focus}) {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 20),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          children: <Widget>[
            for (int i = 0; i < pages.length; i++)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: buildSubLabelText(
                    pages[i],
                    14.0,
                    focus == pages[i] ? Colors.white : Colors.white30,
                    FontWeight.normal),
              ),
          ],
        ),
      ),
    ),
  );
}
