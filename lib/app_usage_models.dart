class AppUsageModels {
  /// The name of the application
  final String appName;

  /// The name of the application package
  String packageName;

  /// The amount of time the application has been used
  /// in the specified interval
  Duration usage;

  /// The start of the interval
  DateTime startDate;

  /// The end of the interval
  DateTime endDate;

  AppUsageModels(
      this.appName, this.endDate, this.packageName, this.startDate, this.usage);
}
