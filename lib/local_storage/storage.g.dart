// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CredentialsAdapter extends TypeAdapter<Credentials> {
  @override
  final int typeId = 1;

  @override
  Credentials read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Credentials()
      ..token = fields[0] as String?
      ..mail = fields[1] as String?
      ..password = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, Credentials obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.mail)
      ..writeByte(2)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CredentialsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
