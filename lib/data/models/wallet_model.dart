// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WalletModel {
  final String walletName;
  final double amount;
  final String iconPath;
  WalletModel({
    required this.walletName,
    required this.amount,
    required this.iconPath,
  });

  WalletModel copyWith({
    String? walletName,
    double? amount,
    String? iconPath,
  }) {
    return WalletModel(
      walletName: walletName ?? this.walletName,
      amount: amount ?? this.amount,
      iconPath: iconPath ?? this.iconPath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'walletName': walletName,
      'amount': amount,
      'iconPath': iconPath,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      walletName: map['walletName'] as String,
      amount: map['amount'] as double,
      iconPath: map['iconPath'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletModel.fromJson(String source) =>
      WalletModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'WalletModel(walletName: $walletName, amount: $amount, iconPath: $iconPath)';

  @override
  bool operator ==(covariant WalletModel other) {
    if (identical(this, other)) return true;

    return other.walletName == walletName &&
        other.amount == amount &&
        other.iconPath == iconPath;
  }

  @override
  int get hashCode => walletName.hashCode ^ amount.hashCode ^ iconPath.hashCode;
}
