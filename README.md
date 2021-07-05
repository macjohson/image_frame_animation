# image_frame_animation

播放视频图片序列，主要用于将视频作为背景，视频为循环视频

### 使用`ffmpeg`将视频转换为frames

```
    ffmpeg -i video.mp4 frame_%d.jpg
```

### 将图片放到`assets`目录
```
   -assets
      -b2_frames
```

### 添加到`pubspec.yaml`
```yaml
  assets:
    - assets/b2_frame/
```

### example

```dart
main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FrameController _controller = FrameController(
      assetPath: "assets/b2_frame",
      assetBaseName: "frame_",
      assetFileSuffix: "jpg"
  );

  bool _loaded = false;

  @override
  void initState() {
    
  }
  
  Future<void> _init() async {
    await _controller.load();
    setState((){
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loaded ?
    ImageFrameAnimation(
        frameController: _controller,
        duration: const Duration(seconds: 20)
    )
        : Container(
      child: Center(
        child: CircularProgressIndicator()
      )
    );
  }
}

```

### FrameController
主要用于加载、解码、缓存图片。

#### 参数说明，都是必填参数
参数名称 | 说明
------|-------
assetPath | 用于放置图片集的文件夹，后面不需要`/`
assetBaseName | 基础名称
assetFileSuffix | 文件扩展名
frames | 总的帧数

*前三个参数主要用于查找到文件，最终会拼接成 `"$assetPath/$assetBaseName${i + 1}.$assetFileSuffix"`*

### 注意事项
如果没有特殊需求，不要使用此插件；图片读取完之后会一直保留，所以视频尽量小，文件小，时间短。此插件会导致内存占用高。