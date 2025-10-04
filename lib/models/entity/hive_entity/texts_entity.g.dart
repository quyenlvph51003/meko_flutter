// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'texts_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TextsEntityAdapter extends TypeAdapter<TextsEntity> {
  @override
  final int typeId = 6;

  @override
  TextsEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextsEntity(
      size: fields[0] as double?,
      content: fields[1] as String?,
      loc: (fields[2] as List?)?.cast<int>(),
      font: fields[3] as String?,
      style: (fields[4] as List?)?.cast<int>(),
      idLocal: fields[5] as String?,
      textAlign: fields[7] as String?,
      textStyle: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TextsEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.size)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.loc)
      ..writeByte(3)
      ..write(obj.font)
      ..writeByte(4)
      ..write(obj.style)
      ..writeByte(5)
      ..write(obj.idLocal)
      ..writeByte(7)
      ..write(obj.textAlign)
      ..writeByte(8)
      ..write(obj.textStyle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextsEntityAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
