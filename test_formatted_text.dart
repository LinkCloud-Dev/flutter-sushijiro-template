import 'package:flutter/material.dart';

void main() {
  final inputs = [
    '<p><span style="color: #003366;">Sample</span></p>',
    'Just some text',
    '<span style="color: #FF0000">Red text</span> and plain text',
    'Some <b>bold</b> text',
    null,
  ];
  
  for (var input in inputs) {
    print('Testing: \$input');
    print(_parseHtmlToSpans(input ?? '', TextStyle(fontSize: 14)));
  }
}

List<InlineSpan> _parseHtmlToSpans(String input, TextStyle? defaultStyle) {
  final strippedInput = input.replaceAll('<p>', '').replaceAll('</p>', '');
  
  final List<InlineSpan> spans = [];
  final RegExp spanRegex = RegExp(r'<span[^>]*style="color:\s*#([0-9a-fA-F]{6});?"[^>]*>(.*?)<\/span>');
  
  int lastMatchEnd = 0;
  
  for (final Match match in spanRegex.allMatches(strippedInput)) {
    if (match.start > lastMatchEnd) {
      spans.add(TextSpan(
        text: strippedInput.substring(lastMatchEnd, match.start),
        style: defaultStyle,
      ));
    }
    
    final String hexColor = match.group(1)!;
    final String content = match.group(2)!;
    final Color color = Color(int.parse('FF\$hexColor', radix: 16));
    
    spans.add(TextSpan(
      text: content,
      style: defaultStyle?.copyWith(color: color) ?? TextStyle(color: color),
    ));
    
    lastMatchEnd = match.end;
  }
  
  if (lastMatchEnd < strippedInput.length) {
    spans.add(TextSpan(
      text: strippedInput.substring(lastMatchEnd),
      style: defaultStyle,
    ));
  }
  
  if (spans.isEmpty) {
    final cleanText = input.replaceAll(RegExp(r'<[^>]*>'), '');
    spans.add(TextSpan(text: cleanText, style: defaultStyle));
  }
  
  return spans;
}
