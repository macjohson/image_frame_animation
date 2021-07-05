part of image_frame_animation;

class FrameController {
  final String assetPath;
  final String assetBaseName;
  final String assetFileSuffix;
  final int frames;

  FrameController(
      {required this.assetPath,
      required this.assetBaseName,
      required this.assetFileSuffix,
      required this.frames});

  List<ui.Image> images = [];

  Future<List<ByteData>> _loadBytes() async {
    final List<ByteData> bytes = [];

    for (int i = 0; i < frames; i++) {
      final _bytes = await rootBundle
          .load("$assetPath/$assetBaseName${i + 1}.$assetFileSuffix");
      bytes.add(_bytes);
    }

    return bytes;
  }

  Future<List<ui.Codec>> _loadCodec(List<ByteData> bytes) async {
    final List<ui.Codec> codecs = [];
    for (ByteData byte in bytes) {
      final ui.Codec codec =
          await ui.instantiateImageCodec(byte.buffer.asUint8List());
      codecs.add(codec);
    }

    return codecs;
  }

  Future<List<ui.FrameInfo>> _loadFrameInfo(List<ui.Codec> codecs) async {
    final List<ui.FrameInfo> frameInfos = [];
    for (ui.Codec codec in codecs) {
      final frameInfo = await codec.getNextFrame();
      frameInfos.add(frameInfo);
    }

    return frameInfos;
  }

  _loadImage(List<ui.FrameInfo> frameInfos) {
    for (ui.FrameInfo frameInfo in frameInfos) {
      final image = frameInfo.image;
      images.add(image);
    }
  }

  load() async {
    final bytes = await _loadBytes();
    final codecs = await _loadCodec(bytes);
    final frameInfos = await _loadFrameInfo(codecs);
    _loadImage(frameInfos);
  }

  void dispose() {
    for (var image in images) {
      image.dispose();
    }
  }
}
