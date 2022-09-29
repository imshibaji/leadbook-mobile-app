// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final int typeId = 4;

  @override
  Profile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profile()
      ..id = fields[0] as String?
      ..uid = fields[1] as String?
      ..name = fields[2] as String?
      ..email = fields[3] as String?
      ..password = fields[9] as String?
      ..mobile = fields[4] as String?
      ..website = fields[5] as String?
      ..apiServerLink = fields[6] as String?
      ..authKey = fields[7] as String?
      ..imageLink = fields[8] as String?
      ..bankAccountHolder = fields[10] as String?
      ..bankAccountNumber = fields[11] as String?
      ..bankIfsc = fields[12] as String?
      ..upiCode = fields[13] as String?;
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.mobile)
      ..writeByte(5)
      ..write(obj.website)
      ..writeByte(6)
      ..write(obj.apiServerLink)
      ..writeByte(7)
      ..write(obj.authKey)
      ..writeByte(8)
      ..write(obj.imageLink)
      ..writeByte(10)
      ..write(obj.bankAccountHolder)
      ..writeByte(11)
      ..write(obj.bankAccountNumber)
      ..writeByte(12)
      ..write(obj.bankIfsc)
      ..writeByte(13)
      ..write(obj.upiCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
