import 'dart:convert';
import 'package:flutter/material.dart';

@immutable
class Language {
  final Locale loc;
  const Language({
    required this.loc,
  });

  Language copyWith({
    Locale? loc,
  }) {
    return Language(
      loc: loc ?? this.loc,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'loc': loc,
    };
  }

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(loc: map["loc"] ?? const Locale("en"));
  }

  String toJson() => json.encode(toMap());

  factory Language.fromJson(String source) =>
      Language.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Language(loc: $loc)';

  @override
  bool operator ==(covariant Language other) {
    if (identical(this, other)) return true;

    return other.loc == loc;
  }

  @override
  int get hashCode => loc.hashCode;
}
