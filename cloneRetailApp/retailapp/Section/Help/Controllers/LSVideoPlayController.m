//
//  LSVideoPlayController.m
//  retailapp
//
//  Created by guozhi on 2017/3/2.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSVideoPlayController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LSVideoPlayController ()
/** 播放属性 */
@property (nonatomic, strong) AVPlayer *player;
/** 播放属性 */
@property (nonatomic, strong) AVPlayerItem *playerItem;
/** 进度条 */
@property (nonatomic, strong) UISlider *slider;
/** 当前播放时间 */
@property (nonatomic, strong) UILabel *currentTimeLabel;
/** 系统时间 */
@property (nonatomic, strong) UILabel *systemTimeLabel;
/** <#注释#> */
@property (nonatomic, assign) CGPoint startPoint;
/** <#注释#> */
@property (nonatomic, assign) CGFloat systemVolume;
/** <#注释#> */
@property (nonatomic, strong) UISlider *volumeViewSlider;
/** 系统菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;
/** 缓冲条 */
@property (nonatomic, strong) UIProgressView *progress;
/** <#注释#> */
@property (nonatomic, strong) UIView *topView;
/** <#注释#> */
@property (nonatomic, assign) CGFloat width;
/** <#注释#> */
@property (nonatomic, assign) CGFloat height;
/** 上面一层Viewd */
@property (nonatomic, strong) UIView *backView;
/** <#注释#> */
@property (nonatomic, strong) NSTimer *timer;
/** 是否正在播放 */
@property (nonatomic, assign) BOOL isPlay;
@end

@implementation LSVideoPlayController

- (void)viewDidLoad {
    //默认播放
    self.isPlay = YES;
//    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    _width = [[UIScreen mainScreen] bounds].size.width;
    _height = [[UIScreen mainScreen] bounds].size.height;
    // 创建AVPlayer
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.url]];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = CGRectMake(0, 0, _width, _height);
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    [self.view.layer addSublayer:playerLayer];
    [_player play];
    //AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    
    
    
    __weak typeof(self) wself = self;
    
    //背景View
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backView];
    [self.backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(wself.view);
    }];
    
    //导航条
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor blackColor];
    self.topView.alpha = 0.9;
    [self.backView addSubview:self.topView];
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(wself.backView);
        make.height.equalTo(52);
    }];
    
    //进度条
    self.progress = [[UIProgressView alloc] init];
    [self.backView addSubview:self.progress];
    //进度条距离屏幕左右的距离
    CGFloat margin = 90;
    [self.progress makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.backView).offset(margin);
        make.right.equalTo(wself.backView).offset(-margin);
         make.centerY.equalTo(wself.backView.bottom).offset(-20);
    }];
    
    self.slider = [[UISlider alloc] init];
    [self.backView addSubview:self.slider];
    [self.slider makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.backView).offset(margin);
        make.right.equalTo(wself.backView).offset(-margin);
        make.centerY.equalTo(wself.backView.bottom).offset(-20);
    }];
    
    [self.slider setThumbImage:[UIImage imageNamed:@"iconfont-yuan"] forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(progressSlider:) forControlEvents:UIControlEventValueChanged];
    self.slider.minimumTrackTintColor = [UIColor colorWithRed:30 / 255.0 green:80 / 255.0 blue:100 / 255.0 alpha:1];
    
    //播放时间
    self.currentTimeLabel = [[UILabel alloc] init];
    [self.backView addSubview:self.currentTimeLabel];
    [self.currentTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.slider.right).offset(10);
        make.right.equalTo(wself.backView);
        make.centerY.equalTo(wself.slider);
    }];
    
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    //    _currentTimeLabel.backgroundColor = [UIColor blueColor];
    self.currentTimeLabel.font = [UIFont systemFontOfSize:12];
    self.currentTimeLabel.text = @"00:00/00:00";
    
    //播放和下一个按钮
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backView addSubview:startButton];
    [startButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.backView).offset(15);
        make.centerY.equalTo(wself.slider);
        make.size.equalTo(30);
    }];
    
    if (_player.rate == 1.0) {
        [startButton setImage:[UIImage imageNamed:@"pauseBtn"] forState:UIControlStateNormal];
    } else {
        [startButton setImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
        
    }
    [startButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backView addSubview:nextButton];
    [nextButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.backView).offset(60);
        make.centerY.equalTo(wself.slider);
        make.size.equalTo(25);
    }];
    [nextButton setImage:[UIImage imageNamed:@"nextPlayer"] forState:UIControlStateNormal];
    
    //返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topView addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(wself.topView);
        make.top.equalTo(wself.topView).offset(10);
        make.width.equalTo(50);
    }];
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    //创建手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    
    //获取系统音量
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    _systemVolume = _volumeViewSlider.value;
    
    
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    [self.slider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
    
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:_activity];
    [_activity startAnimating];
    [self.activity makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(wself.view);
    }];
    
    //    //延迟线程
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _backView.alpha = 0;
        }];
        
    });
    
    //计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(Stack) userInfo:nil repeats:YES];
    
    //    self.modalPresentationCapturesStatusBarAppearance = YES;


    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
   
}

#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        //        NSLog(@"Time Interval:%f",timeInterval);
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.progress setProgress:timeInterval / totalDuration animated:NO];
    }
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - 滑动调整音量大小
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    if(event.allTouches.count == 1){
//        //保存当前触摸的位置
//        CGPoint point = [[touches anyObject] locationInView:self.view];
//        _startPoint = point;
//    }
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    
//    if(event.allTouches.count == 1){
//        //计算位移
//        CGPoint point = [[touches anyObject] locationInView:self.view];
//        //        float dx = point.x - startPoint.x;
//        float dy = point.y - _startPoint.y;
//        int index = (int)dy;
//        if(index>0){
//            if(index%5==0){//每10个像素声音减一格
//                NSLog(@"%.2f",_systemVolume);
//                if(_systemVolume>0.1){
//                    _systemVolume = _systemVolume-0.05;
//                    [_volumeViewSlider setValue:_systemVolume animated:YES];
//                    [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
//                }
//            }
//        }else{
//            if(index%5==0){//每10个像素声音增加一格
//                NSLog(@"+x ==%d",index);
//                NSLog(@"%.2f",_systemVolume);
//                if(_systemVolume>=0 && _systemVolume<1){
//                    _systemVolume = _systemVolume+0.05;
//                    [_volumeViewSlider setValue:_systemVolume animated:YES];
//                    [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
//                }
//            }
//        }
//        //亮度调节
//        //        [UIScreen mainScreen].brightness = (float) dx/self.view.bounds.size.width;
//    }
//}
- (void)moviePlayDidEnd:(id)sender
{
    //    [_player pause];
     [self.timer invalidate];
    self.timer = nil;
     [self popViewController];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//        
//    }];
    
}


#pragma mark - 计时器事件
- (void)Stack
{
    if (_playerItem.duration.timescale != 0) {
        
        _slider.maximumValue = 1;//音乐总共时长
        _slider.value = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale);//当前进度
        
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分钟
        //    NSLog(@"%d",_playerItem.duration.timescale);
        //    NSLog(@"%lld",_playerItem.duration.value/1000 / 60);
        
        //duration 总时长
        
        NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总分钟
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld", proMin, proSec, durMin, durSec];
    }
    if (_player.status == AVPlayerStatusReadyToPlay) {
        [_activity stopAnimating];
    } else {
        [_activity startAnimating];
    }
    NSLog(@"123");
    
}


//- (BOOL)prefersStatusBarHidden
//{
//    return NO; // 返回NO表示要显示，返回YES将hiden
//}
#pragma mark - 轻拍方法
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (_backView.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            
            _backView.alpha = 0;
        }];
    } else if (_backView.alpha == 0){
        [UIView animateWithDuration:0.5 animations:^{
            
            _backView.alpha = 1;
        }];
    }
    if (_backView.alpha == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.5 animations:^{
                
                _backView.alpha = 0;
            }];
            
        });
        
    }
}
#pragma mark - 播放暂停按钮方法
- (void)startAction:(UIButton *)button
{
    if (button.selected) {
        [_player play];
        [button setImage:[UIImage imageNamed:@"pauseBtn.png"] forState:UIControlStateNormal];
        
    } else {
        [_player pause];
        [button setImage:[UIImage imageNamed:@"playBtn.png"] forState:UIControlStateNormal];
        
    }
    button.selected =!button.selected;
    self.isPlay = !self.isPlay;
    
}

#pragma mark - slider滑动事件
- (void)progressSlider:(UISlider *)slider
{
    //拖动改变视频播放进度
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        
        //    //计算出拖动的当前秒数
        CGFloat total = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale;
        
        //    NSLog(@"%f", total);
        
        NSInteger dragedSeconds = floorf(total * slider.value);
        
        //    NSLog(@"dragedSeconds:%ld",dragedSeconds);
        
        //转换成CMTime才能给player来控制播放进度
        
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        
        [self.player pause];
        
        [self.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            if (self.isPlay) {
                [self.player play];
            } else {
                [self.player pause];
            }
        }];
        
    }
}
#pragma mark - 返回事件
- (void)backButtonAction
{
    [_player pause];
     [self.timer invalidate];
    self.timer = nil;
    [self popViewController];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//        
//    }];
}
//- (BOOL)shouldAutorotate {
//    return YES;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}




@end
