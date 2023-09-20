import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';

class SearchProductWidget extends StatefulWidget {
  final String? storeId;
  final String? category;
  final double width;
  final double? height;
  final double borderRadius;
  final double contentHorizontalPadding;
  final Color fillColor;
  final String label;
  final String hint;
  final double? labelSpacing;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? suggestTextStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry suggestionPadding;
  String initValue;
  final List<String> countries;
  final String language;
  final Function()? initHandler;
  final Function(Map<String, dynamic>)? completeHandler;
  bool isEmpty;
  bool isReadOnly;

  SearchProductWidget({
    @required this.storeId,
    @required this.category,
    this.width = double.infinity,
    @required this.height,
    this.borderRadius = 0,
    this.contentHorizontalPadding = 15,
    this.fillColor = Colors.transparent,
    this.label = "",
    this.hint = "",
    this.labelSpacing,
    this.labelStyle,
    this.textStyle,
    this.hintStyle,
    this.suggestTextStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.suggestionPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.initValue = "",
    this.countries = const [],
    this.language = "en",
    @required this.initHandler,
    @required this.completeHandler,
    this.isEmpty = true,
    this.isReadOnly = false,
  });
  @override
  _SearchProductWidgetState createState() => _SearchProductWidgetState();
}

class _SearchProductWidgetState extends State<SearchProductWidget> {
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  Timer? debouncer;
  OverlayEntry? overlayEntry;

  RenderBox? searchFieldRenderBox;
  Size? seachFieldSize;
  Offset? seachFieldPosition;
  String? selectedPlaceID;

  String? oldSearchString;

  String? oldInitVale;

  @override
  void initState() {
    super.initState();

    selectedPlaceID = "";
  }

  @override
  void dispose() {
    clearOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    oldInitVale = widget.initValue;

    if (widget.initValue != "") {
      oldInitVale = widget.initValue;
      _controller.text = widget.initValue;
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
    }
    return KeicyTextFormField(
      width: widget.width,
      height: widget.height,
      controller: _controller,
      focusNode: _focusNode,
      fillColor: widget.fillColor,
      border: Border.all(color: Colors.transparent),
      errorBorder: Border.all(color: Colors.transparent),
      borderRadius: widget.borderRadius,
      contentHorizontalPadding: widget.contentHorizontalPadding,
      label: widget.label,
      labelStyle: widget.labelStyle,
      labelSpacing: widget.labelSpacing,
      prefixIcons: widget.prefixIcon == null ? [] : [widget.prefixIcon!],
      readOnly: widget.isReadOnly,
      suffixIcons: widget.suffixIcon == null
          ? []
          : [
              widget.isEmpty
                  ? SizedBox()
                  : GestureDetector(
                      onTap: () {
                        _controller.clear();
                        clearOverlay();
                        widget.initHandler!();
                        setState(() {
                          widget.initValue = "";
                          widget.isEmpty = true;
                        });
                        widget.completeHandler!({"name": ""});
                      },
                      child: widget.suffixIcon,
                    )
            ],
      textStyle: widget.textStyle,
      hintStyle: widget.hintStyle,
      hintText: widget.hint,
      onChangeHandler: (input) {
        if (oldSearchString == input) return;
        oldSearchString = input;

        if (input.isEmpty != widget.isEmpty) {
          setState(() {
            widget.initValue = "";
            widget.isEmpty = input.isEmpty;
          });
        }

        if (widget.completeHandler != null && _controller.text.trim().isNotEmpty) {
          widget.completeHandler!({"name": _controller.text.trim()});
        }

        onSearchInputChange();
      },
      onEditingCompleteHandler: () {
        // if (widget.completeHandler != null && _controller.text.trim().isNotEmpty) {
        //   widget.completeHandler({"name": _controller.text.trim()});
        // }
        clearOverlay();
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onFieldSubmittedHandler: (input) {
        // if (widget.completeHandler != null && _controller.text.trim().isNotEmpty) {
        //   widget.completeHandler({"name": input.trim()});
        // }
        clearOverlay();
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  void onSearchInputChange() {
    if (_controller.text.isEmpty) {
      debouncer?.cancel();
      searchPlace(_controller.text);
      return;
    }

    if (debouncer?.isActive ?? false) {
      debouncer!.cancel();
    }

    debouncer = Timer(Duration(milliseconds: 500), () {
      searchPlace(_controller.text);
    });
  }

  /// Hides the autocomplete overlay
  void clearOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  void searchPlace(String searchKey) {
    if (context == null) return;

    clearOverlay();

    if (searchKey.length < 1) return;

    searchFieldRenderBox = context.findRenderObject() as RenderBox;
    seachFieldSize = searchFieldRenderBox!.size;
    seachFieldPosition = searchFieldRenderBox!.localToGlobal(Offset.zero);

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: seachFieldPosition!.dx,
        top: seachFieldPosition!.dy + seachFieldSize!.height,
        width: seachFieldSize!.width,
        child: Material(
          elevation: 1,
          color: Colors.white,
          child: Container(
            padding: widget.suggestionPadding,
            child: Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(overlayEntry!);

    autoCompleteSearch(searchKey);
  }

  /// Fetches the place autocomplete list with the query [place].
  void autoCompleteSearch(String searchKey) async {
    var result;
    if (widget.category == "products") {
      result = await ProductApiProvider.getProductList(
        storeIds: [widget.storeId!],
        categories: [],
        searchKey: searchKey,
        page: 1,
        limit: 5,
      );
    } else {
      result = await ServiceApiProvider.getServiceList(
        storeIds: [widget.storeId!],
        categories: [],
        searchKey: searchKey,
        page: 1,
        limit: 5,
      );
    }

    if (result["success"] && result["data"]["docs"].length != 0) {
      displayAutoCompleteSuggestions(result["data"]["docs"]);
    } else {
      clearOverlay();
    }
  }

  /// Display autocomplete suggestions with the overlay.
  void displayAutoCompleteSuggestions(List<dynamic> suggestions) {
    clearOverlay();

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: seachFieldPosition!.dx,
        top: seachFieldPosition!.dy + seachFieldSize!.height,
        width: seachFieldSize!.width,
        child: Material(
          elevation: 1,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: suggestions
                .map(
                  (suggestion) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        child: InkWell(
                          onTap: () {
                            clearOverlay();
                            if (widget.completeHandler != null) {
                              widget.completeHandler!(suggestion);
                              _controller.text = suggestion["name"];
                            }
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Container(
                            color: Colors.white,
                            padding: widget.suggestionPadding,
                            child: Text(
                              suggestion["name"],
                              style: widget.suggestTextStyle,
                            ),
                          ),
                        ),
                      ),
                      suggestion["_id"] == suggestions.last["_id"]
                          ? SizedBox()
                          : Divider(
                              color: Color(0xFFC7CBD6),
                              height: 1,
                              thickness: 1,
                              indent: widget.suggestionPadding.horizontal / 2,
                              endIndent: widget.suggestionPadding.horizontal / 2,
                            ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(overlayEntry!);
  }
}
