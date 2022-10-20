class Utils {
  String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0) {
      hours == 1 ? tokens.add('${hours}hr') : tokens.add('${hours}hrs');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      minutes == 1 ? tokens.add('${minutes}min') : tokens.add('${minutes}mins');
    }
    // tokens.add('${seconds}s');

    return tokens.join(' : ');
  }

  String myDuration(Duration duration) {
    var date = duration.toString().split(":");
    var hrs = date[0];
    var mns = date[1];
    var sds = date[2].split(".")[0];
    return "$hrs:$mns:$sds";
  }
}
