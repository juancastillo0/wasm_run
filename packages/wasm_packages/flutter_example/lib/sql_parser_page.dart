import 'package:flutter/material.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:flutter_example/sql_parser_state.dart';
import 'package:flutter_example/sql_types.dart';
import 'package:flutter_example/state.dart';
import 'package:flutter_example/widgets/code_text_field.dart';
import 'package:sql_parser/sql_parser.dart';

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
    final textStyle = Theme.of(context).textTheme.bodyMedium!;

    Map<int, Widget> getLineWidgets() {
      return Map.fromEntries(
        state.typeFinder!.statementsInfo.map(
          (e) => MapEntry(
            e.start.line,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ...[
                    (
                      () {
                        state.selectStatement(e);
                      },
                      Text(
                        switch ((e.prepareError != null, e.model != null)) {
                          (true, _) => 'E',
                          (_, true) => 'M',
                          _ => 'N',
                        },
                        style: textStyle.copyWith(
                          color: Colors.blue.shade800,
                        ),
                      )
                    ),
                    if (e.preparedStatement != null)
                      (
                        executeFunction(context, state, e),
                        Text(
                          'R',
                          style: textStyle.copyWith(
                            color: Colors.green.shade800,
                          ),
                        )
                      ),
                  ].map(
                    (e) => InkWell(
                      onTap: e.$1,
                      child: Container(
                        alignment: Alignment.center,
                        width: 20,
                        child: e.$2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final parsedSql = state.parsedSql;
        return Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  ErrorMessage(state: state),
                  Expanded(
                    child: CodeTextField(
                      controller: state.sqlController,
                      scrollController: state.scrollController,
                      lineWidgets:
                          state.typeFinder == null ? null : getLineWidgets(),
                      // style: codeTextStyle,
                      // maxLines: 100,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: SingleChildScrollView(
                      child: Text(
                        state.typeFinder?.statementsInfo
                                .where((e) => e.prepareError != null)
                                .map((e) => '${e.prepareError}')
                                .join('\n\n') ??
                            '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (parsedSql == null)
              const Text('data')
            else
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            state.selectStatement(null);
                          },
                          child: const Text('View All').container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: state.selectedStatement == null
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...state.typeFinder!.statementsInfo.map(
                                  (e) => InkWell(
                                    onTap: () {
                                      state.selectStatement(e);
                                    },
                                    child: Text(e.identifier).container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: state.selectedStatement == e
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state.selectedStatement != null)
                      Expanded(
                        child: StatementInfoView(
                          info: state.selectedStatement!,
                          state: state,
                        ),
                      )
                    else
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectableText(
                                parsedSql.toString(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Expanded(
                            //   child: SelectableText(
                            //      jsonEncode(parsedSql.toJson()),
                            //   ),
                            // ),
                            Expanded(
                              child: SelectableText(
                                state.typeFinder.toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

void Function() executeFunction(
  BuildContext context,
  SqlParserState state,
  StatementInfo e,
) {
  return () async {
    final values = e.preparedStatement!.parameterCount;
    final placeholders = e.placeholders.length == values
        ? e.placeholders
        : List.generate(
            values,
            (i) => (SqlValuePlaceholder('$i'), BaseType.dynamic),
          );
    final Map<String, String> args = {
      for (final v in placeholders) v.$1.value: '',
    };
    if (values != 0) {
      await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          contentPadding: const EdgeInsets.all(12),
          title: const Text('Placeholder Values'),
          children: [
            ...placeholders.map((p) {
              final name = p.$1.value;
              return Row(
                children: [
                  const SizedBox(width: 10),
                  Text(name),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: p.$2.name,
                      ),
                      onChanged: (value) {
                        args[name] = value;
                      },
                    ),
                  ),
                ],
              ).container(
                margin: const EdgeInsets.only(bottom: 4),
              );
            }),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Execute'),
            ),
          ],
        ),
      );
    }
    state.execute(e, args);
  };
}

class StatementInfoView extends StatelessWidget {
  const StatementInfoView({
    super.key,
    required this.info,
    required this.state,
  });

  final StatementInfo info;
  final SqlParserState state;

  @override
  Widget build(BuildContext context) {
    final result = state.results[info.statement];

// final String text; Select
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(info.identifier.toString()).title(),
          const Text('Result').title(),
          Text(result ?? 'No result'),
          if (info.preparedStatement != null)
            Column(
              children: [
                const SizedBox(height: 10),
                if (info.placeholders.isNotEmpty)
                  const Text('Placeholders').title(),
                ...info.placeholders.map((ok) => Text('${ok.$1} ${ok.$2}')),
                ElevatedButton(
                  onPressed: executeFunction(context, state, info),
                  child: const Text('Execute'),
                ),
              ],
            ),
          if (info.prepareError != null)
            Column(
              children: [
                const Text('Prepare Error').title(),
                Text('${info.prepareError}'),
              ],
            ),
          const Text('Model').title(),
          SelectableText(info.model.toString()),
          const Text('Parsed').title(),
          SelectableText(info.statement.toString()),
        ],
      ),
    );
  }
}
