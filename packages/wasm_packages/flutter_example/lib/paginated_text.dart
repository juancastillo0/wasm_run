import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_example/flutter_utils.dart';

class SearchValue {
  final String context;
  final int page;

  SearchValue(this.context, this.page);
}

class PaginatedTextController extends ChangeNotifier {
  PaginatedTextController(
    String text, {
    this.pageSize = defaultPageSize,
    this.searchContextSize = 30,
    this.useRegExpSearch = false,
  }) {
    final pageCount = ((text.length + 1) / pageSize).ceil();
    for (var i = 0; i < pageCount; i++) {
      final textController = TextEditingController();
      final end = (i + 1) * pageSize;
      textController.text = text.substring(
        i * pageSize,
        end < text.length ? end : text.length,
      );
      textControllers.add(textController);
    }
    searchController.addListener(_updateSearch);
    searchFocusNode.addListener(
      () {
        if (searchFocusNode.hasFocus) notifyListeners();
      },
    );
  }

  static const defaultPageSize = identical(0, 0.1) ? 30000 : 300000;

  void _updateSearch() {
    if (_searchTimer == null) {
      _searchTimer = Timer(const Duration(milliseconds: 1000), _computeSearch);
      notifyListeners();
    }
  }

  void _computeSearch() {
    _searchTimer = null;
    searchError = '';
    if (searchController.text.isEmpty) {
      searchValues = [];
      notifyListeners();
      return;
    }
    final Pattern pattern;
    try {
      pattern = useRegExpSearch
          ? RegExp(searchController.text)
          : searchController.text;
    } catch (e) {
      setSearchError(e.toString());
      return;
    }
    final sizes = textControllers.fold(
      <int>[0],
      (s, e) => s..add((s.isEmpty ? 0 : s.last) + e.text.length),
    );

    searchValues = pattern.allMatches(joinedText).map((matches) {
      final page = matches.start == 0
          ? 0
          : sizes.indexWhere((e) => e > matches.start) - 1;
      final start = matches.start - sizes[page];
      final end = matches.end - sizes[page];
      final textController = textControllers[page];
      return SearchValue(
        // baseOffset: start - page * pageSize,
        // extentOffset: end - page * pageSize,
        textController.text.substring(
          max(start - searchContextSize, 0),
          min(end + searchContextSize, textController.text.length),
        ),
        page,
      );
    }).toList(growable: false);
    notifyListeners();
  }

  Timer? _searchTimer;
  String searchError = '';
  bool useRegExpSearch;
  final int searchContextSize;
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  List<SearchValue> searchValues = [];

  bool get isSearching => _searchTimer != null;

  final int pageSize;
  final List<TextEditingController> textControllers = [];
  TextEditingController get pageController => textControllers[page];
  int get pageCount => textControllers.length;
  String get joinedText => textControllers.map((e) => e.text).join();

  int _page = 0;
  int get page => _page;
  set page(int page) {
    _page = page;
    notifyListeners();
  }

  void nextPage() {
    if (page + 1 < pageCount) page++;
  }

  void prevPage() {
    if (page - 1 >= 0) page--;
  }

  void toggleUseRegExpSearch() {
    useRegExpSearch = !useRegExpSearch;
    _updateSearch();
    notifyListeners();
  }

  void setSearchError(String searchError) {
    this.searchError = searchError;
    notifyListeners();
  }
}

class PaginatedTextField extends StatelessWidget {
  const PaginatedTextField({super.key, required this.controller});
  final PaginatedTextController controller;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.pageCount == 1) {
            return TextField(
              controller: controller.pageController,
              maxLines: 1000,
              style: codeTextStyle,
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 4,
                child: controller.isSearching
                    ? const LinearProgressIndicator()
                    : const SizedBox(),
              ),
              Expanded(
                child: Builder(
                  // animation: controller.searchFocusNode,
                  builder: (context) {
                    if (controller.searchController.text.isNotEmpty &&
                        controller.searchFocusNode.hasFocus) {
                      if (controller.searchValues.isEmpty) {
                        return Text(
                          controller.isSearching
                              ? 'Searching...'
                              : 'No matches found for search query:'
                                  '\n"${controller.searchController.text}"',
                          textAlign: TextAlign.center,
                        ).container(alignment: Alignment.center);
                      }
                      final distinctPages =
                          controller.searchValues.map((e) => e.page).toSet();
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${controller.searchValues.length} matches found'
                                ' in ${distinctPages.length} pages',
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () =>
                                    controller.page = controller.page,
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: controller.searchValues.length,
                              itemBuilder: (context, index) {
                                final value = controller.searchValues[index];
                                return InkWell(
                                  onTap: () {
                                    controller.searchFocusNode.previousFocus();
                                    controller.page = value.page;
                                  },
                                  child: Text(
                                          'Page ${value.page + 1}: ${value.context}')
                                      .container(
                                          padding: const EdgeInsets.all(4)),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return TextField(
                      controller: controller.pageController,
                      maxLines: 1000,
                      style: codeTextStyle,
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                alignment: WrapAlignment.end,
                runAlignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TextField(
                    controller: controller.searchController,
                    focusNode: controller.searchFocusNode,
                    style: const TextStyle(fontSize: 14),
                  ).container(width: 200),
                  TextButton(
                    onPressed: controller.toggleUseRegExpSearch,
                    style: TextButton.styleFrom(
                      backgroundColor: controller.useRegExpSearch
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : null,
                    ),
                    child: const Text('RegExp'),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${controller.page + 1}/${controller.pageCount}')
                          .container(padding: const EdgeInsets.all(6)),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          onChanged: (value) {
                            final page = int.tryParse(value);
                            if (page != null) {
                              controller.page = page - 1;
                            }
                          },
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      IconButton(
                        onPressed: () => controller.page = 0,
                        icon: const Icon(Icons.first_page),
                      ),
                      IconButton(
                        onPressed: controller.prevPage,
                        icon: const Icon(Icons.arrow_left),
                      ),
                      IconButton(
                        onPressed: controller.nextPage,
                        icon: const Icon(Icons.arrow_right),
                      ),
                      IconButton(
                        onPressed: () =>
                            controller.page = controller.pageCount - 1,
                        icon: const Icon(Icons.last_page),
                      ),
                    ],
                  ),
                ],
              ),
              controller.searchError.isNotEmpty
                  ? Text(controller.searchError).container(
                      padding: const EdgeInsets.all(4),
                      color: Colors.red.shade100,
                    )
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
