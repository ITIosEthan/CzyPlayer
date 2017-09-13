//  CzyPlayView.m
//  CzyPlayer
//  Created by macOfEthan on 17/9/12.
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

#ifndef CZY_PLAYER_GBR 
#define CZY_PLAYER_GBR [[UIColor lightGrayColor] colorWithAlphaComponent:0.9]
#endif

#import "CzyPlayView.h"

@interface CzyPlayView ()
{
    /**播放模型*/
    CzyPlayItems *_playItem;
}

/**播放背景视图*/
@property (nonatomic, strong) UIView *playBgView;


/**顶部*/
@property (nonatomic, strong) UIView *topView;
/**播放标题*/
@property (nonatomic, strong) UILabel *titleLab;
/**静音*/
@property (nonatomic, strong) UIButton *muteBtn;
/**分享*/
@property (nonatomic, strong) UIButton *shareBtn;


/**底部*/
@property (nonatomic, strong) UIView *bottomView;
/**暂停*/
@property (nonatomic, strong) UIButton *pauseBtn;
/**进度条*/
@property (nonatomic, strong) HRBrightnessSlider *slider;
/**进度标签*/
@property (nonatomic, strong) UILabel *currentTimeLabel;
/**总时间长*/
@property (nonatomic, strong) UILabel *totalTimeLabel;
/**缓冲进度条*/
@property (nonatomic, strong) UIView *loadedBufferView;
/**全屏*/
@property (nonatomic, strong) UIButton *fullScreenBtn;
/**是否全屏*/
@property (nonatomic, assign) BOOL isFullScreen;
/**点击隐藏*/
@property (nonatomic, strong) UITapGestureRecognizer *tapGr;


@end

@implementation CzyPlayView

#pragma mark - 实例化播放层
- (instancetype)czyInitPlayerLayerWithPlayerItem:(CzyPlayItems *)playItem andFrame:(CGRect)frame
{   
    if (self == [super initWithFrame:frame]) {
        
        _playItem = playItem;
        
        self.playerItem = [AVPlayerItem playerItemWithURL:playItem.url];
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        [self.layer addSublayer:self.playerLayer];
        
        //铺满
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.playerLayer.contentsScale = [UIScreen mainScreen].scale;
        
        //初始化
        [self playerUI];

        
        //布局
        [self masonryFrame];
        
        //观察播放状态 加载进度
        [self observerPlayer];
        
        //播放完成
        [self addNotifications];
        
        //播放器事件
        [self playerActions];
    }
    return self;
}

#pragma mark - title, progress and timeLabel
- (void)playerUI
{
    //顶部
    _topView = [CzyTools viewWithBackGroundColor:CZY_PLAYER_GBR];
    [self addSubview:_topView];
    
    _titleLab = [CzyTools labelWithTextTitle:_playItem.name andColor:[UIColor brownColor] andFont:[UIFont systemFontOfSize:15] andTextAlignment:NSTextAlignmentLeft];
    [_topView addSubview:_titleLab];
    
    _muteBtn = [CzyTools buttonWithTextTitle:@"静音" andColor:[UIColor brownColor] andFont:[UIFont systemFontOfSize:15]];
    [_topView addSubview:_muteBtn];
    
    _shareBtn = [CzyTools buttonWithTextTitle:@"分享" andColor:[UIColor brownColor] andFont:[UIFont systemFontOfSize:15]];
    [_topView addSubview:_shareBtn];
    
    //底部
    _bottomView = [CzyTools viewWithBackGroundColor:CZY_PLAYER_GBR];
    [self addSubview:_bottomView];
    
    _pauseBtn = [CzyTools buttonWithNormalImage:[UIImage imageNamed:@"pauseBtn"] andSeletedImage:[UIImage imageNamed:@"playBtn"]];
    [_bottomView addSubview:_pauseBtn];
    
    _slider = [HRBrightnessSlider new];
    _slider.color = [UIColor brownColor];
    _slider.brightnessLowerLimit = @(0);
    [_slider updateCursor:0];
    [_slider updateCursorToProgress:0];
    [_bottomView addSubview:_slider];
    
    _currentTimeLabel = [CzyTools labelWithTextTitle:@"00:00" andColor:[UIColor brownColor] andFont:[UIFont systemFontOfSize:10] andTextAlignment:NSTextAlignmentLeft];
    [_bottomView addSubview:_currentTimeLabel];
    
    _totalTimeLabel = [CzyTools labelWithTextTitle:@"00:00" andColor:[UIColor brownColor] andFont:[UIFont systemFontOfSize:10] andTextAlignment:NSTextAlignmentRight];
    [_bottomView addSubview:_totalTimeLabel];
    
    _fullScreenBtn = [CzyTools buttonWithNormalImage:[UIImage imageNamed:@"ZFPlayer_fullscreen"] andSeletedImage:[UIImage imageNamed:@"ZFPlayer_fullscreen"]];
    [_bottomView addSubview:_fullScreenBtn];
    
    _loadedBufferView = [CzyTools viewWithBackGroundColor:[UIColor brownColor]];
    [_bottomView addSubview:_loadedBufferView];
    
    //打开交互
    [self userInteractionEnable];
}

#pragma mark - 播放器事件
- (void)playerActions
{
#pragma mark - 单击手势
    _tapGr = [[UITapGestureRecognizer alloc] init];
    [_tapGr.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        if (_topView.hidden == YES || _bottomView.hidden == YES) {
            [self showPlayer];
        }else{
            [self hiddenPlayer];
        }
    }];
    [self addGestureRecognizer:_tapGr];
    
    //弱引用
    CZY_WEAK(_player);
    CZY_WEAK(self);
    CZY_WEAK(_pauseBtn);
    CZY_WEAK(_currentTimeLabel);
    
#pragma mark - 静音
    [[_muteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        NSLog(@"静音");
    }];
    
#pragma mark - 分享
    [[_shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        NSLog(@"分享");
    }];
    
#pragma mark - 暂停
    [[_pauseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if (x.isSelected) {
            [self play];
        }else{
            [self pause];
        }
        
        x.selected = !x.selected;
    }];
    
#pragma mark - 进度条点击与拖动
    _slider.slideGes = ^(CGFloat progress){
        
        CMTime time = CMTimeMakeWithSeconds(progress*[self totaolDuration], 1);
        
        //精确定位 拖动位置
        [czyWeak_player seekToTime:time toleranceBefore:CMTimeMake(1, 1) toleranceAfter:CMTimeMake(1, 1) completionHandler:^(BOOL finished) {
            
            //拖动完开始播放
            [czyWeakself play];
            //播放状态
            czyWeak_pauseBtn.selected = NO;
            //更新播放进度标签
            czyWeak_currentTimeLabel.text = [czyWeakself convertTime:[self totaolDuration]*progress];
        }];
    };
    
#pragma mark - 全屏
    [[_fullScreenBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        [self fullScreen];
    }];

}

#pragma mark - 播放完成
- (void)addNotifications
{
    [CZY_NOTIFICATION_CENTER addObserver:self selector:@selector(didPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma mark - 播放完成
- (void)didPlayToEnd:(NSNotification *)noti
{
    [self.player seekToTime:kCMTimeZero];
    
    //重播
    [self play];
}

#pragma mark - 监听播放状态 加载进度等
- (void)observerPlayer
{
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            
            //开始播放
            [self.player play];

            //更新当前播放进度标签
            [self currentPlayProgress];

        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){

        CGFloat progress = [self availableDuration]/[self totaolDuration];
        
        NSLog(@"progress = %f width = %f", progress, CGRectGetWidth(_bottomView.frame));
        
        //更新加载进度条
        [_loadedBufferView mas_updateConstraints:^(MASConstraintMaker *make) {
            
//            make.width.equalTo(_bottomView.mas_width).multipliedBy(progress);
        }];
        
        NSLog(@"width = %f", CGRectGetWidth(_loadedBufferView.frame));
    }
}

#pragma mark - 缓冲进度
- (NSTimeInterval)availableDuration
{
    NSArray *loadedTimeRansges = [self.player.currentItem loadedTimeRanges];
    
    CMTimeRange timeRange = [loadedTimeRansges.firstObject CMTimeRangeValue];
    
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    
    NSTimeInterval availableDuration = startSeconds + durationSeconds;
    
    return availableDuration;
}

#pragma mark - 播放总长
- (NSTimeInterval)totaolDuration
{
    return CMTimeGetSeconds(self.playerItem.duration);
}

#pragma mark - 秒速转换为时间
- (NSString *)convertTime:(NSInteger)second{

    NSInteger seconds = second % 60;
    NSInteger minutes = (second / 60) % 60;
    NSInteger hours = second / 3600;
    
    if (hours == 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
    }
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
}

#pragma mark - 播放进度
- (void)currentPlayProgress
{
    CZY_WEAK(self);
    CZY_WEAK(_slider);
    CZY_WEAK(_currentTimeLabel);
    CZY_WEAK(_totalTimeLabel);
    
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        //当前播放时间秒数
        double currentPlayTime = (double)_playerItem.currentTime.value /(double)_playerItem.currentTime.timescale;
        //当前播放时间进度
        CGFloat currentPlayProgress = currentPlayTime / (double)[self totaolDuration];
        
        //更新进度条
        [czyWeak_slider updateCursorToProgress:currentPlayProgress];
        [czyWeak_slider updateCursor:currentPlayProgress];
        
        //更新标签
        czyWeak_currentTimeLabel.text = [czyWeakself convertTime:currentPlayTime];
        //总进度标签
        czyWeak_totalTimeLabel.text = [czyWeakself convertTime:[czyWeakself totaolDuration]];
    }];
}

#pragma mark - 全屏
- (void)fullScreen
{
    if (_isFullScreen) {
        
        [self setPlayerOrientation:UIInterfaceOrientationPortrait];
    }else{
        
        [self setPlayerOrientation:UIInterfaceOrientationLandscapeRight];
    }
}

#pragma mark - 设置屏幕方向
- (void)setPlayerOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        
        //设置横屏
        [self setPlayerOrientationLandscape];
        
    }else if (orientation == UIInterfaceOrientationPortrait){
    
        //设置竖屏
        [self setPlayerOrientationPortrait];
    }
}

#pragma mark - 设置横屏
- (void)setPlayerOrientationLandscape
{
    _isFullScreen = YES;
    [self changeToOrientation:UIInterfaceOrientationLandscapeRight];
}

#pragma mark - 设置竖屏
- (void)setPlayerOrientationPortrait
{
    _isFullScreen = NO;
    [self changeToOrientation:UIInterfaceOrientationPortrait];
}

#pragma mark - 改变屏幕方向
- (void)changeToOrientation:(UIInterfaceOrientation)orientation
{
    //当前状态栏的方向
    UIInterfaceOrientation statusBarOrientaion = [UIApplication sharedApplication].statusBarOrientation;
    
    if (statusBarOrientaion == orientation) {
        return;
    }
    
    if (orientation != UIInterfaceOrientationPortrait) {
        
        if (statusBarOrientaion == UIInterfaceOrientationPortrait) {
            
            //更改frame
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(CZY_FULL_HEIGHT);
                make.height.mas_equalTo(CZY_FULL_WIDTH);
                make.center.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        
        }
    }else{
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(CZY_FULL_WIDTH);
            make.height.mas_equalTo(CZY_FULL_HEIGHT);
            make.centerY.mas_equalTo(CGPointMake(CZY_FULL_WIDTH/2, CZY_FULL_HEIGHT-150));
        }];
    }
    
    //改变状态栏方向
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    
    //动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    self.transform = CGAffineTransformIdentity;
    self.transform = [self playerRotateAngle];
    
    [UIView commitAnimations];
}

#pragma mark - 获取需要旋转的角度
- (CGAffineTransform)playerRotateAngle
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    }else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    }else if (orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    
    return CGAffineTransformIdentity;
}

#pragma mark - 开始播放
- (void)play
{
    CZY_WEAK(_player);
    if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
        [czyWeak_player play];
    }
}

#pragma mark - 暂停播放
- (void)pause
{
    [self.player pause];
}

#pragma mark - 播放层frame
- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    
    self.playerLayer.bounds = self.layer.bounds;
    self.playerLayer.position = self.layer.position;
}



#pragma mark - masonry布局
- (void)masonryFrame
{
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //慎用width和height约束 避免屏幕旋转出错
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(30);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_topView).with.offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
        make.centerY.equalTo(_topView);
    }];
    
    [_muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.equalTo(_shareBtn);
        make.right.equalTo(_shareBtn.mas_left).offset(-10);
        make.centerY.equalTo(_topView);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_topView).with.offset(10);
        make.right.equalTo(_muteBtn.mas_left).with.offset(-10);
        make.centerY.equalTo(_topView);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(30);
    }];

    [_pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_bottomView).offset(5);
        make.centerY.equalTo(_bottomView);
        make.width.height.mas_equalTo(20);
    }];
    
    [_currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_pauseBtn.mas_right).offset(10);
        make.centerY.equalTo(_bottomView);
        make.width.mas_equalTo(40);
    }];

    [_fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_bottomView).offset(-10);
        make.centerY.equalTo(_bottomView);
        make.width.height.mas_equalTo(20);
    }];
    
    [_totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_fullScreenBtn.mas_left).offset(-5);
        make.centerY.equalTo(_bottomView);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(40);
    }];

    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_currentTimeLabel.mas_right).offset(10);
        make.right.equalTo(_totalTimeLabel.mas_left).offset(-5);
        make.centerY.equalTo(_bottomView);
        make.height.mas_equalTo(2);
    }];
    
    [_loadedBufferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomView.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
        make.left.right.equalTo(_bottomView);
    }];
}

#pragma mark - 打开交互
- (void)userInteractionEnable
{
    self.userInteractionEnabled = YES;
    _topView.userInteractionEnabled = YES;
    _bottomView.userInteractionEnabled = YES;
}

#pragma mark - 显示与隐藏
- (void)showPlayer
{
    _topView.hidden = NO;
    _bottomView.hidden = NO;
}
- (void)hiddenPlayer
{
    _topView.hidden = YES;
    _bottomView.hidden = YES;
}

#pragma mark - dealloc
- (void)dealloc
{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [CZY_NOTIFICATION_CENTER removeObserver:self];
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
