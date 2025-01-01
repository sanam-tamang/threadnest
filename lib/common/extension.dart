extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String path() {
    if (this == '/') return this; // Handle root path
    if (isEmpty) return this;
    return '/$this';
  }

  String rootPath() {
    if (isEmpty) return this;
    return '/';
  }
}
