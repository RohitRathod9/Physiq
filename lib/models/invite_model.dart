import 'package:cloud_firestore/cloud_firestore.dart';

class InviteModel {
  final String code;
  final String referrerUid;
  final DateTime createdAt;
  final int uses;
  final List<String> usedBy;
  final DateTime? expiresAt;

  InviteModel({
    required this.code,
    required this.referrerUid,
    required this.createdAt,
    this.uses = 0,
    this.usedBy = const [],
    this.expiresAt,
  });

  factory InviteModel.fromMap(Map<String, dynamic> data) {
    return InviteModel(
      code: data['code'] ?? '',
      referrerUid: data['referrerUid'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      uses: data['uses'] ?? 0,
      usedBy: List<String>.from(data['usedBy'] ?? []),
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'referrerUid': referrerUid,
      'createdAt': Timestamp.fromDate(createdAt),
      'uses': uses,
      'usedBy': usedBy,
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
    };
  }
}
