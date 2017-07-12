现在app都做的越来越炫酷，各种动画效果，各种特效很好的提高了用户的体验。很多app在登录界面都使用了动画效果，比如Uber，Keep，QQ等等。这些动画效果基本都是使用gif或者MP4来实现的。

效果图：
![](https://github.com/qqcc1388/LoginWithVideoDemo/blob/master/Resource/ezgif.com-video-to-gif.gif)

这里提供3种方式实现登录界面动画,有需要的同学可以参考一下

1.video篇，使用avplayer加载video来实现效果
    实现步骤基本上是初始化播放器，然后加载video，有几个注意点：1.导入头文件#import <AVFoundation/AVFoundation.h> 2.app进入后台后，video播放就停止了，这里采用通知的方式在app从后台进入前台时通知控制开启播放video 代码如下：
```
- (void)setupForAVplayerView
{
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:playerLayer];
}

/**
 *  初始化播放器
 */
- (AVPlayer *)player
{
    if (!_player) {
        AVPlayerItem *playerItem = [self getPlayItem];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        //设置重复播放
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone; // set this
        //视频播放完发通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(__playerItemDidPlayToEndTimeNotification:)
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
        
    }
    return _player;
}

- (AVPlayerItem *)getPlayItem
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"BridgeLoop-640p" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    return playerItem;
}

- (void)__playerItemDidPlayToEndTimeNotification:(NSNotification *)sender
{
    [_player seekToTime:kCMTimeZero]; // 设置从头继续播放
}

//视频进入后台到前台视频暂停的处理方法
appDelegate.m中
- (void)applicationDidBecomeActive:(UIApplication *)application {

    [[NSNotificationCenter defaultCenter]postNotificationName:@"appBecomeActive" object:nil];
}
viewController.m
- (void)viewWillAppear:(BOOL)animated
{
    //视频播放
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playVideos) name:@"appBecomeActive" object:nil];
}
```
2.gif篇 利用webView加载gif的方法来实现gif的播放
    需要注意的是html中加载的gif路径不要搞错了，要不然gif无法加载出来 代码如下：
    html:
```
<!DOCTYPE html>
<html>
    
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1, user-scalable=no">
        <title>loadgif</title>
        <style type="text/css">
            *{
                margin:0px;
                padding:0px;
            }
        .loadGif {
            width: 100%;
            height: 100%;
            /*设置背景*/
            background: url(loadgif.gif) no-repeat center center;
            /*让背景全屏*/
            background-size: cover;
            /*让div全屏*/
            position:absolute; 
        }
        </style>
    </head>
    
    <body>
        <div class="loadGif"> </div>
    </body>
    
</html>

```
oc中
```
-(void)setupWebView{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"loadGif.html" ofType:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
    [webView loadRequest:request];
    webView.userInteractionEnabled = NO;
    
}
```
3.gif篇 这里仍然使用gif,如果你觉得使用html过于麻烦，自己对html又不是很熟悉，这里提供另外一种加载gif的方法，使用[YYImge](https://github.com/ibireme/YYImage)加载gif
    需要注意的是[YYImge](https://github.com/ibireme/YYImage)需要添加一个静态库 libz.tbd 依赖 代码如下：
```
-(void)setupYYImageView{
   NSString *path = [[NSBundle mainBundle] pathForResource:@"loadgif.gif" ofType:nil];
    YYImage *image = [YYImage imageWithContentsOfFile:path];
    YYAnimatedImageView *imgView = [[YYAnimatedImageView alloc] initWithFrame:self.view.bounds];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.image = image;
    [self.view addSubview:imgView];
}
```
