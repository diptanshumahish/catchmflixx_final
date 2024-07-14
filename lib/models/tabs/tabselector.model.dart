import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabSelector {
  final int tab;

  TabSelector({
    required this.tab,
  });

  TabSelector copyWith({
    int? tab,
  }) {
    return TabSelector(
      tab: tab ?? this.tab,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tab': tab,
    };
  }

  factory TabSelector.fromMap(Map<String, dynamic> map) {
    return TabSelector(
      tab: map['tab'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TabSelector.fromJson(String source) =>
      TabSelector.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TabSelector(tab: $tab)';

  @override
  bool operator ==(covariant TabSelector other) {
    if (identical(this, other)) return true;

    return other.tab == tab;
  }

  @override
  int get hashCode => tab.hashCode;
}
