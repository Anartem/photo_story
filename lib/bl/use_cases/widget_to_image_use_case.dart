import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WidgetToImageUseCase {
  Future<Uint8List> toImage({required Widget widget, Size? size}) async {
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    final RenderView renderView = RenderView(
      window: window,
      child: RenderPositionedBox(alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: size ?? window.physicalSize / window.devicePixelRatio,
      ),
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child:widget,
      ),
    ).attachToRenderTree(buildOwner);

    //need to wait for widget init
    await Future.delayed(const Duration(milliseconds: 300));

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    return repaintBoundary
        .toImage(pixelRatio: window.devicePixelRatio)
        .then((image) => image.toByteData(format: ImageByteFormat.png))
        .then((data) => data?.buffer.asUint8List() ?? Uint8List(0));
  }
}