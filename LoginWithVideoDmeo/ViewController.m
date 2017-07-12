//
//  ViewController.m
//  LoginWithVideoDmeo
//
//  Created by Tiny on 2017/7/12.
//  Copyright © 2017年 LOVEGO. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YYImage.h"

@interface ViewController ()

@property (strong, nonatomic) AVPlayer *player;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    //视频播放
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playVideos) name:@"appBecomeActive" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playVideos
{
    [self.player play];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //使用avplayer播放视频
    [self setupForAVplayerView];
    
    //使用webView来播放gif
//    [self setupWebView];
    
    //使用yyImage加载gif
//    [self setupYYImageView];
    
    //设置毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectiView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectiView.alpha = 0.8f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0f];
    effectiView.alpha = 0.3f;
    [UIView commitAnimations];
    effectiView.frame = self.view.bounds;
    [self.view addSubview:effectiView];
    
}

-(void)setupYYImageView{
   NSString *path = [[NSBundle mainBundle] pathForResource:@"loadgif.gif" ofType:nil];
    YYImage *image = [YYImage imageWithContentsOfFile:path];
    YYAnimatedImageView *imgView = [[YYAnimatedImageView alloc] initWithFrame:self.view.bounds];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.image = image;
    [self.view addSubview:imgView];
}

-(void)setupWebView{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"loadGif.html" ofType:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
    [webView loadRequest:request];
    webView.userInteractionEnabled = NO;
    
}
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
