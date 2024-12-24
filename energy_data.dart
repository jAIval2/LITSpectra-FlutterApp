class BarChartTile {
  final String title;
  final List<String> timeOptions;
  final String selectedTime;
  final Map<String, List<UsageData>> data;

  BarChartTile({
    required this.title,
    required this.timeOptions,
    required this.selectedTime,
    required this.data,
  });

  // fromJson method to create BarChartTile from JSON
  factory BarChartTile.fromJson(Map<String, dynamic> json) {
    return BarChartTile(
      title: json['title'],
      timeOptions: List<String>.from(json['timeOptions']),
      selectedTime: json['selectedTime'],
      data: (json['data'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((item) => UsageData.fromJson(item)).toList(),
        ),
      ),
    );
  }
}

class UsageData {
  final String month;
  final int usage;

  UsageData({required this.month, required this.usage});

  // fromJson method to create UsageData from JSON
  factory UsageData.fromJson(Map<String, dynamic> json) {
    return UsageData(
      month: json['month'],
      usage: json['usage'],
    );
  }
}

class CircleCompletionTile {
  final String title;
  final int usagePercentage;
  final String usageText;
  final String currentUsage;

  CircleCompletionTile({
    required this.title,
    required this.usagePercentage,
    required this.usageText,
    required this.currentUsage,
  });

  // fromJson method to create CircleCompletionTile from JSON
  factory CircleCompletionTile.fromJson(Map<String, dynamic> json) {
    return CircleCompletionTile(
      title: json['title'],
      usagePercentage: json['usagePercentage'],
      usageText: json['usageText'],
      currentUsage: json['currentUsage'],
    );
  }
}

class SavingSuggestionsTile {
  final String title;
  final List<String> suggestions;

  SavingSuggestionsTile({required this.title, required this.suggestions});

  // fromJson method to create SavingSuggestionsTile from JSON
  factory SavingSuggestionsTile.fromJson(Map<String, dynamic> json) {
    return SavingSuggestionsTile(
      title: json['title'],
      suggestions: List<String>.from(json['suggestions']),
    );
  }
}

class DueBillTile {
  final String title;
  final String amountDue;
  final String dueDate;
  final String status;

  DueBillTile({
    required this.title,
    required this.amountDue,
    required this.dueDate,
    required this.status,
  });

  // fromJson method to create DueBillTile from JSON
  factory DueBillTile.fromJson(Map<String, dynamic> json) {
    return DueBillTile(
      title: json['title'],
      amountDue: json['amountDue'],
      dueDate: json['dueDate'],
      status: json['status'],
    );
  }
}
