import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_model.g.dart';

// 變成 黨名.g.dart
@JsonSerializable()
class AccountModel extends Equatable {
  // ignore: non_constant_identifier_names
  final String account_uid; // json 欄位名稱
  final String name; // json 欄位名稱
  final String account; // json 欄位名稱
  final String email; // json 欄位名稱
  final String password;
  final String token;
  AccountModel({
    // ignore: non_constant_identifier_names
    this.account_uid = '',
    this.name = '',
    this.account = '',
    this.email = '',
    this.password = '',
    this.token = '',
  }); // required 裡面也要改成
  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
  // 這裡的 PostModel.fromJson 的 PostModel 也要改動，後面的 _$PostModelFromJson 的 PostModelFromJson 也要改動
  // 變成 XXX.fromJson _$XXXFromJson
  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
  // 這裡的 _$PostModelToJson(this) 的 PostModel 也要改動，變成  _$XXXToJson(this)
  @override
  String toString() => "$account_uid $name $account $email $password $token";

  @override
  List<Object?> get props =>
      [account_uid, name, account, email, password, token];
}
