import 'dart:async';

import 'package:cgef/helpers/color_helper.dart';
import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/models/enums.dart';
import 'package:cgef/models/grid_block.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';

class GridBlockComponent extends RectangleComponent
    with Tappable, HasGameRef, HasComponentRef {
  GridBlockComponent(this.index);
  int index = 0;

  TextComponent? text;
  RectangleComponent? hover;

  GridBlock get thisBlock => ref.read(gridProvider(index));

  @override
  FutureOr<void> onMount() {
    super.onMount();

    final cellMulti = 0.98;
    width = cellSize() * cellMulti;
    height = cellSize() * cellMulti;

    final x = (index % ParsingHelper.arenaSize) * cellSize();
    final y = (index ~/ ParsingHelper.arenaSize) * cellSize();
    position = Vector2(x, y);

    // print('position: $position');
    text = TextComponent(
        // text: thisBlock.height.toString(),
        size: Vector2.all(10),
        scale: Vector2.all(0.6),
        priority: 100);
    reloadCell(ref.read(tabProvider));
    text!.anchor = Anchor.center;
    text!.position = Vector2(width / 2, height / 2);
    add(text!);

    listen(gridProvider(index), (_, GridBlock? next) {
      if (next != null) {
        // this.setColor(Colors.red);
        text!.text = next.height.toString();
      }
    });

    listen(paintedOverProvider, (_, IList<int>? next) {
      if (next != null && next.contains(index)) {
        var color = ColorHelper.heightToColor(thisBlock.height);
        color = Color.alphaBlend(Colors.red.withOpacity(0.2), color);
        this.setColor(color);
      } else {
        this.setColor(
          ColorHelper.heightToColor(thisBlock.height),
        );
        // move cell to bottom
        priority = 0;
        if (hover != null) {
          parent?.remove(hover!);
          hover = null;
        }
      }
    });

    listen(hoveredProvider, (_, IList<int>? next) {
      if (next != null && next.contains(index)) {
        if (hover == null) {
          hover = RectangleComponent(
            position: position + Vector2.all(cellSize() / 2),
            size: Vector2(width * 1.1, height * 1.1),
            anchor: Anchor.center,
            priority: 50,
          )..setColor(Colors.red);
          parent?.add(hover!);
          // move cell to top
          priority = 80;
        }
      } else {
        setColor(
          ColorHelper.heightToColor(thisBlock.height),
        );
        // move cell to bottom
        priority = 0;
        if (hover != null) {
          parent?.remove(hover!);
          hover = null;
        }
      }
    });

    listen(tabProvider, (_, AppTab next) {
      reloadCell(next);
    });
  }

  void reloadCell(AppTab activeTab) {
    if (activeTab == AppTab.heights) {
      text!.text = thisBlock.height.toString();
    } else {
      text!.text = thisBlock.prefab;
    }

    setColor(ColorHelper.heightToColor(thisBlock.height));
    text?.textRenderer = TextPaint(
      style: TextStyle(
        color: ColorHelper.blockTextColor(thisBlock.height),
        fontSize: 25,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  double cellSize() {
    return (gameRef.size.x / ParsingHelper.arenaSize);
  }
}