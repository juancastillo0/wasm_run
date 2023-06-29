import 'dart:convert' show jsonEncode;

import 'package:flutter/material.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:flutter_example/state.dart';

class SqlParserPage extends StatelessWidget {
  const SqlParserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sqlParserLoader = Inherited.get<GlobalState>(context).sqlParser;
    final state = sqlParserLoader.value;
    if (state == null) {
      return const CircularProgressIndicator();
    }
    // final isSmall = MediaQuery.of(context).size.width < 1000;
    // final isVerySmall = MediaQuery.of(context).size.width < 660;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final parsedSql = state.parsedSql;
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      controller: state.sqlController,
                      maxLines: 100,
                    ),
                  ),
                  ErrorMessage(state: state),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SelectableText(
                parsedSql == null ? '' : parsedSql.toString(),
              ),
            ),
            const SizedBox(width: 10),
            // Expanded(
            //   child: SelectableText(
            //     parsedSql == null ? '' : jsonEncode(parsedSql.toJson()),
            //   ),
            // ),
            Expanded(
              child: SelectableText(
                parsedSql == null ? '' : state.typeFinder.toString(),
              ),
            ),
          ],
        );
      },
    );
  }
}
