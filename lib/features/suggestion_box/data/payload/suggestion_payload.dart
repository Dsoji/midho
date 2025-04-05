import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;

@immutable
class SuggestionPayload extends MapView<String, dynamic> {
  SuggestionPayload({
    String? title,
    String? content,
    List<String>? files,
  }) : super({
          'title': title,
          'content': content,
          'files': files,
        });
}
