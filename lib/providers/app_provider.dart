import 'package:cgef/models/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final toolProvider = StateProvider((ref) => Tool.point);
final toolModifierProvider = StateProvider((ref) => ToolModifier.plusOne);
final selectedPrefabProvider = StateProvider((ref) => Prefab.none);
final tabProvider = StateProvider((ref) => AppTab.heights);

final setToValueProvider = StateProvider((ref) => 0);
final plusValueProvider = StateProvider((ref) => 2);

final selectedGridBlockProvider = StateProvider<int?>((ref) => null);

final pastHomeProvider = StateProvider((ref) => false);