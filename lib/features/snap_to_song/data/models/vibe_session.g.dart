// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vibe_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VibeSessionAdapter extends TypeAdapter<VibeSession> {
  @override
  final int typeId = 0;

  @override
  VibeSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VibeSession(
      timestamp: fields[0] as DateTime,
      detectedLabels: (fields[1] as List).cast<String>(),
      suggestedSongs: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, VibeSession obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.detectedLabels)
      ..writeByte(2)
      ..write(obj.suggestedSongs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VibeSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
