import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/finisherrands.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/widgets.dart';

class InfoTile extends StatefulWidget {
  final String uid;
  InfoTile({this.uid});
  @override
  _InfoTileState createState() => _InfoTileState();
}

class _InfoTileState extends State<InfoTile> {
  List<FinishedErrands> finishederrands;
  @override
  Widget build(BuildContext context) {
    finishederrands = Provider.of<List<FinishedErrands>>(context) ?? [];
    print('finished Errands: ${finishederrands.length}');
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildSubLabelText('Total earnings as of today', 18.0,
                Colors.blue[900], FontWeight.normal),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FutureBuilder(
                future: ServicesDatabase()
                    .getTotalEarningsofToday(finished: finishederrands),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return buildLabelText(
                        '0', 16.0, Colors.black, FontWeight.bold);
                  }
                  return buildLabelText(
                      '${snap.data}', 16.0, Colors.black, FontWeight.bold);
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    buildSubLabelText('Finished errands as of today', 12.0,
                        Colors.grey, FontWeight.normal),
                    buildLabelText('${finishederrands.length}', 14.0,
                        Colors.black, FontWeight.bold)
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    buildSubLabelText('Total accomplished errands', 12.0,
                        Colors.grey, FontWeight.normal),
                    StreamBuilder<Object>(
                        stream: ProfileDatabase(uid: widget.uid).totalErrands,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return buildLabelText(
                                '0', 14.0, Colors.black, FontWeight.bold);
                          }
                          // List<FinishedErrands> total =
                          //     Provider.of<List<FinishedErrands>>(context) ?? [];
                          List<FinishedErrands> total = snapshot.data;
                          return buildLabelText('${total.length}', 14.0,
                              Colors.black, FontWeight.bold);
                        })
                  ],
                ),
              )
            ],
          ),
          separator(8)
        ],
      ),
    );
  }
}
