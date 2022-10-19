import 'package:flutter/material.dart';

class CustomActionRow extends StatelessWidget {
  final String actionName;
  final Function actionFunction;

  CustomActionRow(this.actionName, this.actionFunction);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black54,
                width: 0,
              ),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    this.actionName,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.blueGrey,
                      primary: Colors.white,
                      backgroundColor: Colors.white,
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () async {
                      this.actionFunction();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
