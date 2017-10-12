//  CzyPlayerView.m
//  CzyPlayer
//  Created by macOfEthan on 17/10/10.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//  Github:https://github.com/ITIosEthan
//  简书：http://www.jianshu.com/u/1d52648daace
/**
 *   █████▒█    ██  ▄████▄   ██ ▄█▀   ██████╗ ██╗   ██╗ ██████╗
 * ▓██   ▒ ██  ▓██▒▒██▀ ▀█   ██▄█▒    ██╔══██╗██║   ██║██╔════╝
 * ▒████ ░▓██  ▒██░▒▓█    ▄ ▓███▄░    ██████╔╝██║   ██║██║  ███╗
 * ░▓█▒  ░▓▓█  ░██░▒▓▓▄ ▄██▒▓██ █▄    ██╔══██╗██║   ██║██║   ██║
 * ░▒█░   ▒▒█████▓ ▒ ▓███▀ ░▒██▒ █▄   ██████╔╝╚██████╔╝╚██████╔╝
 *  ▒ ░   ░▒▓▒ ▒ ▒ ░ ░▒ ▒  ░▒ ▒▒ ▓▒   ╚═════╝  ╚═════╝  ╚═════╝
 */

#define BOTTOM_HTIGHT 40

#import "CzyPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "ASValueTrackingSlider.h"

@interface CzyPlayerView ()<ASValueTrackingSliderDataSource>

/**唯一窗口*/
@property (nonatomic, strong) UIWindow *keyWindow;

/**播放器上的视图*/
@property (nonatomic, strong) UIView *bottomPlayerView;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, strong) ASValueTrackingSlider *slider;
@property (nonatomic, strong) UIButton *playPauseBtn;
@property (nonatomic, strong) UIView *topPlayerView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIProgressView *progressCacheView;


/**播放器*/
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;

/**播放进度*/
@property (nonatomic, assign) CGFloat totalDuration;
@property (nonatomic, assign) CGFloat currentDuration;

/**关于全屏*/
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, assign) BOOL isOriginalFrame; //是否旋转过 默认没有


@end

@implementation CzyPlayerView

#pragma mark - Setter
- (void)setPlayUrl:(NSString *)playUrl
{
    _playUrl = playUrl;
    
    [self.activityIndicatorView startAnimating];
}

- (void)setCacheProgressColor:(UIColor *)cacheProgressColor
{
    _cacheProgressColor = cacheProgressColor;
    
    self.progressCacheView.tintColor = _cacheProgressColor;
}

- (void)setTapTimePopViewColor:(UIColor *)tapTimePopViewColor
{
    _tapTimePopViewColor = tapTimePopViewColor;
    
    self.slider.textColor = _tapTimePopViewColor;
}

- (void)setLoadedProgreeViewColor:(UIColor *)loadedProgreeViewColor
{
    _loadedProgreeViewColor = loadedProgreeViewColor;
    
    self.slider.popUpViewColor = _loadedProgreeViewColor;
}

- (void)setLoadedProgreeViewColors:(NSArray *)loadedProgreeViewColors
{
    _loadedProgreeViewColors = loadedProgreeViewColors;
    
    self.slider.popUpViewAnimatedColors = _loadedProgreeViewColors;
}

#pragma mark - playerItem player playerLayer
- (AVPlayerLayer *)playerLayer
{
    if (!_playerLayer) {
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.playerLayer = playerLayer;
        [self.layer addSublayer:self.playerLayer];
    }
    return _playerLayer;
}

- (AVPlayer *)player
{
    if (!_player) {
        
        AVPlayerItem *playerItem = [self getPlayItemWithUrl:self.playUrl];
        self.playerItem = playerItem;
        
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        self.player = player;
        
        /**观察播放状态和加载进度*/
        [self observeLoadingProgressAndStatusWithPlayerItem:playerItem];

        /**观察播放进度*/
        [self observePlayProgressWithPlayer:player];
        
        // 解决8.1系统播放无声音问题，
        AVAudioSession * session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
    }
    return _player;
}

#pragma mark - 缓冲加载视图
- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        
        self.activityIndicatorView = activityIndicatorView;
    }
    return _activityIndicatorView;
}

#pragma mark - 播放暂停按钮
- (UIButton *)playPauseBtn
{
    
    if (!_playPauseBtn) {
        
        UIButton *playPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [playPauseBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [playPauseBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        playPauseBtn.contentMode = UIViewContentModeCenter;
        [playPauseBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playPauseBtn];
        
        self.playPauseBtn = playPauseBtn;
    }
    return _playPauseBtn;
}

#pragma mark - 播放器底部
- (UIView *)bottomPlayerView
{
    if (!_bottomPlayerView) {
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.bottomPlayerView = bottomView;
        
        UILabel *label1 = [[UILabel alloc] init];
        /**
         除了AutoLayout，AutoresizingMask也是一种布局方式。默认情况下，translatesAutoresizingMaskIntoConstraints ＝ true ,
         此时视图的AutoresizingMask会被转换成对应效果的约束。这样很可能就会和我们手动添加的其它约束有冲突。此属性设置成false时，AutoresizingMask就不会变成约束。也就是说 当前 视图的 AutoresizingMask失效了。
         */
        label1.translatesAutoresizingMaskIntoConstraints = NO;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = @"00:00:00";
        label1.font = [UIFont systemFontOfSize:12.0f];
        label1.textColor = [UIColor whiteColor];
        [bottomView addSubview:label1];
        self.currentTimeLabel = label1;
        
        NSLayoutConstraint *label1Left = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
        NSLayoutConstraint *label1Top = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        NSLayoutConstraint *label1Bottom = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        NSLayoutConstraint *label1Width = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:65.0f];
        [bottomView addConstraints:@[label1Left, label1Top, label1Bottom, label1Width]];
        
        UIButton *fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fullScreenBtn.translatesAutoresizingMaskIntoConstraints = NO;
        fullScreenBtn.contentMode = UIViewContentModeCenter;
        [fullScreenBtn setImage:[UIImage imageNamed:@"btn_zoom_out"] forState:UIControlStateNormal];
        [fullScreenBtn setImage:[UIImage imageNamed:@"btn_zoom_in"] forState:UIControlStateSelected];
        [fullScreenBtn addTarget:self action:@selector(fullScreenExchange:) forControlEvents:UIControlEventTouchDown];
        [bottomView addSubview:fullScreenBtn];
        self.fullScreenBtn = fullScreenBtn;
        
        NSLayoutConstraint *btnRight = [NSLayoutConstraint constraintWithItem:fullScreenBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *btnW = [NSLayoutConstraint constraintWithItem:fullScreenBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:BOTTOM_HTIGHT];
        NSLayoutConstraint *btnH = [NSLayoutConstraint constraintWithItem:fullScreenBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:BOTTOM_HTIGHT];
        NSLayoutConstraint *btnCenterY = [NSLayoutConstraint constraintWithItem:fullScreenBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [bottomView addConstraints:@[btnH, btnW, btnRight, btnCenterY]];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.translatesAutoresizingMaskIntoConstraints = NO;
        label2.textAlignment = NSTextAlignmentCenter;
        label2.text = @"00:00:00";
        label2.font = [UIFont systemFontOfSize:12.0f];
        label2.textColor = [UIColor whiteColor];
        [bottomView addSubview:label2];
        self.totalTimeLabel = label2;
        
        NSLayoutConstraint *label2Right = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:fullScreenBtn attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *label2Top = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *label2Bottom = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *label2W = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:65];
        [bottomView addConstraints:@[label2Right, label2W, label2Top, label2Bottom]];
        
        ASValueTrackingSlider *slider = [[ASValueTrackingSlider alloc] init];
        slider.dataSource = self;
        slider.translatesAutoresizingMaskIntoConstraints = NO;
        slider.value = 0;
        slider.userInteractionEnabled = YES;
        slider.maximumTrackTintColor = [UIColor clearColor];
        slider.font = [UIFont systemFontOfSize:14];
        slider.popUpViewArrowLength = 6;
        slider.popUpViewCornerRadius = 2;
        slider.popUpViewHeightPaddingFactor = 0.6;
        slider.popUpViewAnimatedColors = @[[UIColor clearColor]];
        [slider setThumbImage:[UIImage imageNamed:@"CZYPlayer_slider"] forState:UIControlStateNormal];
        [bottomView addSubview:slider];
        
        /**点击进度条*/
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTap:)];
        [slider addGestureRecognizer:sliderTap];
        
        /**拖动进度条*/
        [slider addTarget:self action:@selector(sliderPan:) forControlEvents:UIControlEventValueChanged];
        
        self.slider = slider;
        
        NSLayoutConstraint *sliderLeft = [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *sliderTop = [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *sliderBottom = [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *sliderRight = [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [bottomView addConstraints:@[sliderTop, sliderBottom, sliderLeft, sliderRight]];
        
        UIProgressView *progressCacheView = [UIProgressView new];
        progressCacheView.tintColor = [UIColor lightGrayColor];
        progressCacheView.translatesAutoresizingMaskIntoConstraints = NO;
        [bottomView addSubview:progressCacheView];
        self.progressCacheView = progressCacheView;
        
        NSLayoutConstraint *progressCacheViewLeft = [NSLayoutConstraint constraintWithItem:progressCacheView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:slider attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5];
        NSLayoutConstraint *progressCacheViewCenterY = [NSLayoutConstraint constraintWithItem:progressCacheView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:slider attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:1];
        NSLayoutConstraint *progressCacheViewHeight = [NSLayoutConstraint constraintWithItem:progressCacheView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:2];
        NSLayoutConstraint *progressCacheViewRight = [NSLayoutConstraint constraintWithItem:progressCacheView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:slider attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        [bottomView addConstraints:@[progressCacheViewCenterY, progressCacheViewHeight, progressCacheViewLeft, progressCacheViewRight]];
        
        [bottomView bringSubviewToFront:slider];
        
        [self updateConstraintsIfNeeded];
    }
    return _bottomPlayerView;
}

#pragma mark - 根据本地或者网络url选择playItem
- (AVPlayerItem *)getPlayItemWithUrl:(NSString *)url
{
    if ([self.playUrl rangeOfString:@"http"].location == NSNotFound) {
        
        //本地
        AVAsset *localAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:url] options:nil];
        return [AVPlayerItem playerItemWithAsset:localAsset];
    }else{
    
        return [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}

#pragma mark - 播放进度
- (void)observePlayProgressWithPlayer:(AVPlayer *)player
{
    [player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        self.currentDuration = CMTimeGetSeconds(time);
        self.totalDuration = CMTimeGetSeconds([self.player.currentItem duration]);
        
        self.currentTimeLabel.text = [self getTimeWithSecond:self.currentDuration];
        
        /**播放时改变进度条*/
        [self.slider setValue:self.currentDuration / self.totalDuration animated:NO];
        
        /**播放进度大于缓冲进度时*/
        if (self.slider.value >= self.progressCacheView.progress-0.1) {
            
            [self activityViewStartRunning];
        }else{
            
            [self activityViewStopRunning];
        }
    }];
}

#pragma mark - 播放状态与进度
- (void)observeLoadingProgressAndStatusWithPlayerItem:(AVPlayerItem *)playerItem
{
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 观察回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *playItem = object;
    
    if ([keyPath isEqualToString:@"status"]) {
        
        AVPlayerStatus status = [[change valueForKey:@"new"] integerValue];
        
        if (status == AVPlayerStatusReadyToPlay) {
            
            self.totalDuration = CMTimeGetSeconds(playItem.duration);
            self.totalTimeLabel.text = [self getTimeWithSecond:self.totalDuration];
            
            [self play];
            self.playPauseBtn.selected = YES;
        }
        
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){

        [self activityViewStartRunning];
        
        CGFloat loadedTime = [self availableDuration];
        CGFloat totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
        self.progressCacheView.progress = loadedTime/totalTime;

        if (self.progressCacheView.progress >= 1) {
            
            [self activityViewStopRunning];
        }
        
        /**缓冲完成移除*/
        //[self removeCacheProgressView];
    }
}

#pragma mark - 手动切换横竖屏
- (void)fullScreenExchange:(UIButton *)sender
{
    sender.selected = !sender.selected;

    if (sender.selected) {
        
        [self rightOritationFullScreen];
    }else{
        [self normalScreen];
    }
    
}

#pragma mark - 屏幕旋转
- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    if (orientation == UIDeviceOrientationLandscapeLeft) {
        
        [self rightOritationFullScreen];
    }else if(orientation == UIDeviceOrientationLandscapeRight){
        
        [self leftOritationFullScreen];
    }else{
        
        [self normalScreen];
    }
    
}

#pragma mark - 向右选择全屏 UIDeviceOrientationLandscapeLeft
- (void)rightOritationFullScreen
{
    self.fullScreenBtn.selected = YES;
    [self.keyWindow addSubview:self];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        /**旋转*/
        self.transform = CGAffineTransformMakeRotation(M_PI/2);
        /**改变frame*/
        self.frame = self.keyWindow.bounds;
        self.bottomPlayerView.frame = CGRectMake(0, self.keyWindow.frame.size.width-BOTTOM_HTIGHT, self.keyWindow.frame.size.height, BOTTOM_HTIGHT);
        self.activityIndicatorView.center = CGPointMake(self.keyWindow.frame.size.height/2, self.keyWindow.frame.size.width/2);
        self.playPauseBtn.frame = CGRectMake((self.keyWindow.frame.size.height-BOTTOM_HTIGHT)/2, (self.keyWindow.frame.size.width-BOTTOM_HTIGHT)/2,BOTTOM_HTIGHT, BOTTOM_HTIGHT);
    }];
    
    [self setStatusBarHidden:YES];
}

#pragma mark - 向左选择全屏
- (void)leftOritationFullScreen
{
    self.fullScreenBtn.selected = YES;
    [self.keyWindow addSubview:self];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.transform = CGAffineTransformMakeRotation(-M_PI/2);
        
        self.frame = self.keyWindow.bounds;
        
        self.bottomPlayerView.frame = CGRectMake(0, self.keyWindow.frame.size.width-BOTTOM_HTIGHT, self.keyWindow.frame.size.height, BOTTOM_HTIGHT);
        self.activityIndicatorView.center = CGPointMake(self.keyWindow.frame.size.height/2, self.keyWindow.frame.size.width/2);
        self.playPauseBtn.frame = CGRectMake((self.keyWindow.frame.size.height-BOTTOM_HTIGHT)/2, (self.keyWindow.frame.size.width-BOTTOM_HTIGHT)/2,BOTTOM_HTIGHT, BOTTOM_HTIGHT);
    }];
    
    [self setStatusBarHidden:YES];
}

#pragma mark - 取消全屏播放
- (void)normalScreen
{
    [self removeFromSuperview];
    
    [self.playSuperView addSubview:self];
    
    self.fullScreenBtn.selected = NO;
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInt:UIDeviceOrientationPortrait] forKey:@"orientation"];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = self.originalFrame;
        self.bottomPlayerView.frame = CGRectMake(0, self.originalFrame.size.height-BOTTOM_HTIGHT, self.originalFrame.size.width, BOTTOM_HTIGHT);
        self.activityIndicatorView.center = CGPointMake(self.originalFrame.size.width/2, self.originalFrame.size.height/2);
        self.playPauseBtn.frame = CGRectMake(self.originalFrame.size.width/2-BOTTOM_HTIGHT/2, self.originalFrame.size.height/2-BOTTOM_HTIGHT/2, BOTTOM_HTIGHT, BOTTOM_HTIGHT);
        
        [self updateConstraintsIfNeeded];
    }];
    
    [self setStatusBarHidden:NO];
}

#pragma mark - 播放与暂停的相互切换
- (void)playOrPause:(UIButton *)sender
{
    if (self.player.status != AVPlayerStatusReadyToPlay) {
        return;
    }
    
    sender.selected = !sender.selected;

    if (!sender.selected) {
        
        [self.player pause];
    }else{
    
        [self.player play];
        
        [self hiddenSubViews];
    }
}

#pragma mark - 隐藏状态栏
- (void)setStatusBarHidden:(BOOL)hidden
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.hidden = hidden;
}


#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.keyWindow = [UIApplication sharedApplication].keyWindow;
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        /**单击手势*/
        [self showOrHiddenSubViews];
        
        /**双击手势*/
        [self doubleTapToExchangeFullScreen];
        
        /**默认隐藏子视图*/
        [self hiddenSubViews];
        
        
    }
    return self;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    self.playerLayer.frame = self.bounds;
    
    /**多次调用 保证一次性操作 保证是最起始的frame*/
    if (!self.isOriginalFrame) {
        self.originalFrame = self.frame;
        self.bottomPlayerView.frame = CGRectMake(0, self.originalFrame.size.height-BOTTOM_HTIGHT, self.originalFrame.size.width, BOTTOM_HTIGHT);
        self.playPauseBtn.frame = CGRectMake((self.originalFrame.size.width-BOTTOM_HTIGHT)/2, (self.originalFrame.size.height-BOTTOM_HTIGHT)/2, BOTTOM_HTIGHT, BOTTOM_HTIGHT);
        self.activityIndicatorView.center = CGPointMake(self.originalFrame.size.width/2, self.originalFrame.size.height/2);
        self.isOriginalFrame = YES;

        [self addSubview:self.bottomPlayerView];
        [self bringSubviewToFront:self.bottomPlayerView];
        [self bringSubviewToFront:self.playPauseBtn];
        [self insertSubview:self.activityIndicatorView aboveSubview:self.playPauseBtn];
        self.activityIndicatorView.tintColor = [UIColor brownColor];
    }
}

#pragma mark - 双击全屏切换
- (void)doubleTapToExchangeFullScreen
{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapToExchangeFullScreen:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
}

- (void)doubleTapToExchangeFullScreen:(UITapGestureRecognizer *)tap
{
    self.fullScreenBtn.selected = !self.fullScreenBtn.selected;
    
    if (self.fullScreenBtn.selected) {
        
        [self rightOritationFullScreen];
    }else{
        [self normalScreen];
    }
}

#pragma mark - 单击影藏显示切换
- (void)showOrHiddenSubViews
{
    UITapGestureRecognizer *showAndHiddenSubViewsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAndHiddenSubViewsTap:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:showAndHiddenSubViewsTap];
}

- (void)showAndHiddenSubViewsTap:(UITapGestureRecognizer *)tap
{
    if (self.bottomPlayerView.hidden == YES) {
        [self showSubViews];
    }else{
        [self hiddenSubViews];
    }
}

#pragma mark - 逐渐隐藏子视图
- (void)hiddenSubViews
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.playPauseBtn.alpha = 0.1;
        self.bottomPlayerView.alpha = 0.1;

    } completion:^(BOOL finished) {
        
        self.playPauseBtn.hidden = YES;
        self.bottomPlayerView.hidden = YES;
    }];
}

#pragma mark - 显示子视图
- (void)showSubViews
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.playPauseBtn.alpha = 1.0;
        self.bottomPlayerView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        self.playPauseBtn.hidden = NO;
        self.bottomPlayerView.hidden = NO;
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self hiddenSubViews];
//    });
}

#pragma mark - 进度条点击事件
- (void)sliderTap:(UITapGestureRecognizer *)tap
{
    if (self.player.status != AVPlayerStatusReadyToPlay) {
        return;
    }
    

    ASValueTrackingSlider *slider = (ASValueTrackingSlider *)tap.view;
    
    CGPoint touchPoint = [tap locationInView:slider];
    
    CGFloat value = (slider.maximumValue - slider.minimumValue) * (touchPoint.x / slider.frame.size.width );

    [slider setValue:value animated:NO];
    
    CMTime currentTime = CMTimeMake(value * self.totalDuration, 1.0);
    
    [self.player seekToTime:currentTime completionHandler:^(BOOL finished) {
        
        [self.player play];
        self.playPauseBtn.selected = YES;
        [self activityViewStopRunning];
        self.currentTimeLabel.text = [self getTimeWithSecond:CMTimeGetSeconds(currentTime)];
    }];
}

#pragma mark - 进度条拖动手势
- (void)sliderPan:(ASValueTrackingSlider *)slider
{
    if (self.player.status != AVPlayerStatusReadyToPlay) {
        return;
    }
        
    [self.player seekToTime:CMTimeMake(slider.value * self.totalDuration, 1.0) completionHandler:^(BOOL finished) {
        
        [self.player play];
        self.playPauseBtn.selected = YES;
        
        [self activityViewStopRunning];
    }];
}

#pragma mark - 秒钟转时分秒
- (NSString *)getTimeWithSecond:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

#pragma mark - 计算缓冲进度
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

#pragma mark - 开始暂停加载视图
- (void)activityViewStartRunning
{
    [self.activityIndicatorView startAnimating];
}

- (void)activityViewStopRunning
{
    [self.activityIndicatorView stopAnimating];
    [self.activityIndicatorView removeFromSuperview];
}

#pragma mark - 移除缓冲进度条
- (void)removeCacheProgressView
{
    if (self.progressCacheView == nil) {
        return;
    }
    
    if (self.progressCacheView.progress == 1) {
        [self.progressCacheView removeFromSuperview];
        self.progressCacheView = nil;
    }
}

#pragma mark - 切换新的播放地址
- (void)replaceCurrentPlayItemWithUrl:(NSString *)newUrl
{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [self hiddenSubViews];

    AVPlayerItem *newPlayItem = [self getPlayItemWithUrl:newUrl];
    
    [self.player replaceCurrentItemWithPlayerItem:newPlayItem];
    
    [self observeLoadingProgressAndStatusWithPlayerItem:newPlayItem];
    [self observePlayProgressWithPlayer:self.player];
    
    [self play];
}

#pragma mark - 开始播放
- (void)play
{
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        
        [self.player play];
    }
}

#pragma mark - 暂停播放
- (void)pause
{
    [self.player pause];
}

#pragma mark - <ASValueTrackingSliderDelegate, ASValueTrackingSliderDataSource>
- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value
{
    return [self getTimeWithSecond:slider.value * self.totalDuration];
}

#pragma mark - dealloc
- (void)dealloc
{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    self.player = nil;
    self.playerItem = nil;
    self.playerLayer = nil;
    self.bottomPlayerView = nil;
    self.playPauseBtn = nil;
    self.activityIndicatorView = nil;
}

@end







