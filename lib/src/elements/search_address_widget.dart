import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:http/http.dart' as http;

class SearchAddressWidget extends StatefulWidget {
  final String? googleApiKey;
  final double width;
  final double? height;
  final double borderRadius;
  final Border? border;
  final Border? errorBorder;
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
  final Function(String)? completeHandler;
  bool isEmpty;

  SearchAddressWidget({
    @required this.googleApiKey,
    this.width = double.infinity,
    @required this.height,
    this.borderRadius = 0,
    this.border,
    this.errorBorder,
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
    this.completeHandler,
    this.isEmpty = true,
  });
  @override
  _SearchAddressWidgetState createState() => _SearchAddressWidgetState();
}

class _SearchAddressWidgetState extends State<SearchAddressWidget> {
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  Timer? debouncer;
  OverlayEntry? overlayEntry;
  String sessionToken = Uuid().generateV4();

  RenderBox? searchFieldRenderBox;
  Size? seachFieldSize;
  Offset? seachFieldPosition;
  String? selectedPlaceID;

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
    if (widget.initValue != "") _controller.text = widget.initValue;

    return KeicyTextFormField(
      width: widget.width,
      height: widget.height,
      controller: _controller,
      focusNode: _focusNode,
      fillColor: widget.fillColor,
      border: widget.border ?? Border.all(color: Colors.transparent),
      errorBorder: widget.errorBorder ?? Border.all(color: Colors.transparent),
      borderRadius: widget.borderRadius,
      contentHorizontalPadding: widget.contentHorizontalPadding,
      label: widget.label,
      labelStyle: widget.labelStyle,
      labelSpacing: widget.labelSpacing,
      prefixIcons: widget.prefixIcon == null ? [] : [widget.prefixIcon!],
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
                      },
                      child: widget.suffixIcon,
                    )
            ],
      textStyle: widget.textStyle,
      hintStyle: widget.hintStyle,
      hintText: widget.hint,
      onChangeHandler: (input) {
        if (input.isEmpty != widget.isEmpty) {
          setState(() {
            widget.isEmpty = input.isEmpty;
          });
        }

        onSearchInputChange();
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

  void searchPlace(String place) {
    if (context == null) return;

    clearOverlay();

    if (place.length < 1) return;

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

    autoCompleteSearch(place);
  }

  /// Fetches the place autocomplete list with the query [place].
  void autoCompleteSearch(String place) {
    place = place.replaceAll(" ", "+");

    // Currently, you can use components to filter by up to 5 countries. from https://developers.google.com/places/web-service/autocomplete
    String regionParam = widget.countries.isNotEmpty == true
        ? "&components=country:${widget.countries.sublist(0, min(widget.countries.length, 5)).join('|country:')}"
        : "";

    var endpoint = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    endpoint += "?key=${widget.googleApiKey}";
    endpoint += "&input=$place$regionParam";
    endpoint += "&sessiontoken=$sessionToken";
    endpoint += "&language=${widget.language}";

    http.get(Uri.parse(endpoint)).then((response) {
      try {
        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          List<dynamic> predictions = data['predictions'];

          List<AutoCompleteItem> suggestions = [];

          if (predictions.isEmpty) {
            AutoCompleteItem aci = AutoCompleteItem();
            aci.text = "No Result";
            aci.offset = 0;
            aci.length = 0;

            suggestions.add(aci);
          } else {
            for (dynamic t in predictions) {
              AutoCompleteItem aci = AutoCompleteItem();

              aci.id = t['place_id'];
              aci.text = t['description'];
              aci.offset = t['matched_substrings'][0]['offset'];
              aci.length = t['matched_substrings'][0]['length'];

              suggestions.add(aci);
            }
          }

          displayAutoCompleteSuggestions(suggestions);
        }
      } catch (e) {
        FlutterLogs.logThis(
          tag: "search_address_widget",
          level: LogLevel.ERROR,
          subTag: "autoCompleteSearch",
          exception: e is Exception ? e : null,
          error: e is Error ? e : null,
          errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
        );
        clearOverlay();
      }
    }).catchError((error) {
      FlutterLogs.logThis(
        tag: "search_address_widget",
        level: LogLevel.ERROR,
        subTag: "autoCompleteSearch",
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
      clearOverlay();
    });
  }

  /// Display autocomplete suggestions with the overlay.
  void displayAutoCompleteSuggestions(List<AutoCompleteItem> suggestions) {
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
            children: suggestions
                .map(
                  (suggestion) => Column(
                    children: [
                      Material(
                        child: InkWell(
                          onTap: () {
                            // setState(() {
                            //   selectedPlaceID = suggestion.id;
                            // });
                            clearOverlay();
                            if (widget.completeHandler != null) {
                              widget.completeHandler!(suggestion.id!);
                            }
                          },
                          child: Container(
                            color: Colors.white,
                            padding: widget.suggestionPadding,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(children: getStyledTexts(suggestion)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      suggestion.id == suggestions.last.id
                          ? SizedBox()
                          : Divider(
                              color: Color(0xFFC7CBD6),
                              height: 1,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
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

  List<TextSpan> getStyledTexts(AutoCompleteItem autoCompleteItem) {
    final List<TextSpan> result = [];

    bool isSelected = autoCompleteItem.id != null && selectedPlaceID == autoCompleteItem.id;

    String startText = autoCompleteItem.text!.substring(0, autoCompleteItem.offset);
    if (startText.isNotEmpty) {
      result.add(
        TextSpan(
          text: startText,
          style: widget.suggestTextStyle!.copyWith(color: (isSelected) ? Color(0xFF4A65C6) : Colors.black),
        ),
      );
    }

    String boldText = autoCompleteItem.text!.substring(autoCompleteItem.offset!, autoCompleteItem.offset! + autoCompleteItem.length!);

    result.add(
      TextSpan(
        text: boldText,
        style: widget.suggestTextStyle!.copyWith(
          color: (isSelected) ? Color(0xFF4A65C6) : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    String remainingText = autoCompleteItem.text!.substring(autoCompleteItem.offset! + autoCompleteItem.length!);
    result.add(
      TextSpan(
        text: remainingText,
        style: widget.suggestTextStyle!.copyWith(color: (isSelected) ? Color(0xFF4A65C6) : Colors.black),
      ),
    );

    return result;
  }
}

class Uuid {
  final Random _random = new Random();

  /// Generate a version 4 (random) uuid. This is a uuid scheme that only uses
  /// random numbers as the source of the generated uuid.
  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) => _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) => value.toRadixString(16).padLeft(count, '0');
}

class AutoCompleteItem {
  /// The id of the place. This helps to fetch the lat,lng of the place.
  String? id;

  /// The text (name of place) displayed in the autocomplete suggestions list.
  String? text;

  /// Assistive index to begin highlight of matched part of the [text] with
  /// the original query
  int? offset;

  /// Length of matched part of the [text]
  int? length;

  @override
  String toString() {
    return 'AutoCompleteItem{id: $id, text: $text, offset: $offset, length: $length}';
  }
}

class AddressPickerProvider extends ChangeNotifier {
  static AddressPickerProvider of(BuildContext context, {bool listen = false}) => Provider.of<AddressPickerProvider>(context, listen: listen);

  String? _selectedPlaceID;
  String? get selectedPlaceID => _selectedPlaceID;

  void setSelectedPlaceID(String selectedPlaceID) {
    if (_selectedPlaceID != selectedPlaceID) {
      _selectedPlaceID = selectedPlaceID;
      notifyListeners();
    }
  }
}
