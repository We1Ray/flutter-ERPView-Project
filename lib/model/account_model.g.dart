// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) {
  return AccountModel(
    account_uid: json['account_uid'] as String,
    name: json['name'] as String,
    account: json['account'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    token: json['token'] as String,
  );
}

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'account_uid': instance.account_uid,
      'name': instance.name,
      'account': instance.account,
      'email': instance.email,
      'password': instance.password,
      'token': instance.token,
    };
