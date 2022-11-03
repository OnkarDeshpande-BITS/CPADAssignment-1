import 'package:flutter/material.dart';

class CustomActionRow extends StatelessWidget {
  final String actionName;
  final Function actionFunction;
  Color? borderColor;
  Color? backgroundColor ;

  CustomActionRow(this.actionName, this.actionFunction, {this.borderColor ,this.backgroundColor });

  @override
  Widget build(BuildContext context) {
    backgroundColor ??= Colors.blue.shade50;

    borderColor ??= Colors.blue;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: backgroundColor,
          elevation: 2,
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
                color: borderColor!,
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 4, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(
                    this.actionName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  )),
                  IconButton(

                    icon: Icon(
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
