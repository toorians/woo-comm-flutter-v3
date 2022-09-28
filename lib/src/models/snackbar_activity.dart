class SnackBarActivity {
  SnackBarActivity({
    this.show = true,
    this.success = false,
    this.message = '',
    this.loading = false,
    this.duration = const Duration(milliseconds: 4000),
  });

  bool show;
  bool success;
  String message;
  bool loading;
  Duration duration;
}