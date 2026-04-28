// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_action_bank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NameActionBank _$NameActionBankFromJson(Map<String, dynamic> json) =>
    _NameActionBank(
      theme: json['theme'] as String,
      actions:
          (json['actions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$NameActionBankToJson(_NameActionBank instance) =>
    <String, dynamic>{'theme': instance.theme, 'actions': instance.actions};
