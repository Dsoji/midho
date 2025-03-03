import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

extension StringExtension on String {
  /// [get asset paths]
  /// [Shared]
  String get svg2 => 'assets/svgs/shared/$this.svg';
  String get png2 => 'assets/pngs/shared/$this.png';
  String get json2 => 'assets/jsons/shared/$this.json';
  String get lottie => 'assets/lottie/$this.lottie';

  /// [Discover]
  String get discover2Svg => 'assets/svgs/discover/$this.svg';
  String get discoverPostSvg => 'assets/svgs/discover/post/$this.svg';
  String get discoverCircleSvg => 'assets/svgs/discover/circle/$this.svg';
  String get discover2Png => 'assets/pngs/discover/$this.png';

  /// [Telagri]
  String get telagri2Svg => 'assets/svgs/telagri/$this.svg';
  String get telagri2Png => 'assets/pngs/telagri/$this.png';

  /// [Young Ranchers]
  String get youngRanchers2Svg => 'assets/svgs/young_ranchers/$this.svg';
  String get youngRanchers2Png => 'assets/pngs/young_ranchers/$this.png';

  /// [Boat]
  String get boat2Svg => 'assets/svgs/boat/$this.svg';
  String get boat2Png => 'assets/pngs/boat/$this.png';

  /// [Telagri]
  String get telagriBg2Png => 'assets/pngs/telagri/$this.png';
  String get telagriBg2Svg => 'assets/svgs/telagri/$this.svg';

  /// [Farm Tinder]
  String get farmTinder2Svg => 'assets/svgs/farm_tinder/$this.svg';
  String get farmTinder2Png => 'assets/pngs/farm_tinder/$this.png';

  /// [Profile]
  String get profile2Svg => 'assets/svgs/profile/$this.svg';
  String get profile2Png => 'assets/pngs/profile/$this.png';

  String stripHtmlTags() {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  String stripHtmlTagsAndWhitespace() {
    // Remove HTML tags
    String withoutTags = replaceAll(RegExp(r'<[^>]*>'), '');

    // Remove excess white spaces and new lines
    String withoutExcessWhitespace = withoutTags
        .replaceAll(RegExp(r'\s+'),
            ' ') // Replace multiple spaces/new lines with a single space
        .trim(); // Trim leading and trailing spaces

    return withoutExcessWhitespace;
  }

  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String capitalizeAllFirstLetter() {
    if (isEmpty) return this;

    return split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  String getInitials() {
    if (isEmpty) {
      return '';
    }
    List<String> words = split(' ');
    String initials = words
        .take(3) // Only take first 3 words
        .map((word) {
          if (word.isNotEmpty) {
            return word[0].toUpperCase();
          } else {
            return '';
          }
        })
        .where((initial) => initial.isNotEmpty)
        .join('');

    return initials;
  }

  String get capitalize {
    return isNotEmpty ? substring(0, 1).toUpperCase() + substring(1) : this;
  }

  DateTime get cleanDate {
    final results = split(' ').first.split('-');

    if (results.isNotEmpty && results.length == 3) {
      final day = int.parse(results.first);
      final month = int.parse(results[1]);
      final year = int.parse(results.last);

      return DateTime(year, month, day);
    }

    return DateTime.now();
  }

  String format() {
    try {
      int value = int.parse(replaceAll(',', ''));
      String formattedValue = value.toStringAsFixed(0);
      String result = formattedValue.replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      return result;
    } catch (e) {
      return "0"; // Return the original string in case of an error
    }
  }

  String formatAsNaira() {
    try {
      double value = double.parse(replaceAll(',', ''));
      String formattedValue = value.toStringAsFixed(2);
      String result =
          '₦${formattedValue.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
      return result;
    } catch (e) {
      log('Error: $e');
      return this; // Return the original string in case of an error
    }
  }

  String? extractVideoUrl() {
    final RegExp regex = RegExp(
      r'src="([^"]+)"',
      caseSensitive: false,
    );
    final match = regex.firstMatch(this);
    if (match != null && match.groupCount > 0) {
      return match.group(1);
    }
    return null;
  }

  String formatPhoneNumber() {
    if (length == 10 && int.tryParse(this) != null) {
      return '+234$this';
    } else {
      String removeExcessZero = replaceFirst('0', '');
      return '+234$removeExcessZero';
    }
  }

  bool containsHtml() {
    final htmlTagPattern = RegExp(r'<[^>]+>');
    return htmlTagPattern.hasMatch(this);
  }

  DateTime toDateTime() {
    try {
      return DateFormat('dd-MM-yyyy').parse(this);
    } catch (e) {
      return DateTime.now();
    }
  }

  DateTime toFromYearDateTime() {
    try {
      return DateFormat('yyyy-MM-dd').parse(this);
    } catch (e) {
      return DateTime.now();
    }
  }

  String getFileExtension() {
    switch (toLowerCase()) {
      // Document formats
      case 'pdf':
        return 'pdf';
      case 'doc':
      case 'word':
        return 'doc';
      case 'docx':
        return 'docx';
      case 'excel':
        return 'xlsx';
      case 'xls':
        return 'xls';
      case 'xlsx':
        return 'xlsx';
      case 'ppt':
        return 'ppt';
      case 'pptx':
        return 'pptx';
      case 'txt':
        return 'txt';
      case 'rtf':
        return 'rtf';

      // Image formats
      case 'image':
      case 'jpg':
      case 'jpeg':
        return 'jpg';
      case 'png':
        return 'png';
      case 'gif':
        return 'gif';
      case 'bmp':
        return 'bmp';
      case 'svg':
        return 'svg';

      // Video formats
      case 'video':
      case 'mp4':
        return 'mp4';
      case 'avi':
        return 'avi';
      case 'mov':
        return 'mov';
      case 'mkv':
        return 'mkv';
      case 'flv':
        return 'flv';
      case 'wmv':
        return 'wmv';

      // Audio formats
      case 'audio':
      case 'mp3':
        return 'mp3';
      case 'wav':
        return 'wav';
      case 'aac':
        return 'aac';
      case 'ogg':
        return 'ogg';

      // Web and markup formats
      case 'html':
      case 'htm':
      case 'link':
        return 'html';
      case 'css':
        return 'css';
      case 'js':
        return 'js';

      // Archive formats
      case 'zip':
        return 'zip';
      case 'rar':
        return 'rar';
      case '7z':
        return '7z';
      case 'tar':
        return 'tar';
      case 'gz':
        return 'gz';

      // Data and structured formats
      case 'csv':
        return 'csv';
      case 'json':
        return 'json';
      case 'xml':
        return 'xml';

      // E-book formats
      case 'epub':
        return 'epub';
      case 'mobi':
        return 'mobi';

      default:
        return 'dat';
    }
  }
}
