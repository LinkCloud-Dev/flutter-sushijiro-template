void main() {
  final input = '<p><span style="color: #003366;">Sample</span></p>';
  final strippedInput = input.replaceAll('<p>', '').replaceAll('</p>', '');
  
  final List<String> spans = [];
  final RegExp spanRegex = RegExp(r'<span[^>]*style="color:\s*#([0-9a-fA-F]{6});?"[^>]*>(.*?)<\/span>');
  
  int lastMatchEnd = 0;
  
  for (final Match match in spanRegex.allMatches(strippedInput)) {
    if (match.start > lastMatchEnd) {
      spans.add("TEXT: " + strippedInput.substring(lastMatchEnd, match.start));
    }
    
    final String hexColor = match.group(1)!;
    final String content = match.group(2)!;
    
    spans.add("SPAN($hexColor): $content");
    lastMatchEnd = match.end;
  }
  
  if (lastMatchEnd < strippedInput.length) {
    spans.add("TEXT: " + strippedInput.substring(lastMatchEnd));
  }
  
  if (spans.isEmpty) {
    final cleanText = input.replaceAll(RegExp(r'<[^>]*>'), '');
    spans.add("FALLBACK: " + cleanText);
  }
  
  print(spans);
}
