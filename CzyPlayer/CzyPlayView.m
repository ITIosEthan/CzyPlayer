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
#define CZY_PLAYER_GBR [[UIColor lightGrayColor] colorWithAlphaComponent:0.3]
#endif

#import "CzyPlayView.h"

@interface CzyPlayView ()

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
@property (nonatomic, strong) UILabel *timeLabel;


@end

@implementation CzyPlayView

#pragma mark - 实例化播放层
- (instancetype)czyInitPlayerLayerWithPlayerItem:(CzyPlayItems *)playItem andFrame:(CGRect)frame
{   
    if (self == [super initWithFrame:frame]) {
        self.playerItem = [AVPlayerItem playerItemWithURL:playItem.url];
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = frame;
        [self.layer addSublayer:self.playerLayer];
        
        //铺满
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.playerLayer.contentsScale = [UIScreen mainScreen].scale;
        
        [self headerAndBottomUI];
    }
    return self;
}

#pragma mark - title, progress and timeLabel
- (void)headerAndBottomUI
{
    //顶部
    _topView = [CzyTools viewWithBackGroundColor:CZY_PLAYER_GBR];
    [self addSubview:_topView];
    
    _titleLab = [CzyTools labelWithTextTitle:@"标题" andColor:[UIColor brownColor] andFont:[UIFont systemFontOfSize:15] andTextAlignment:NSTextAlignmentLeft];
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
    [_bottomView addSubview:_slider];
    
    _timeLabel = [CzyTools labelWithTextTitle:@"显示时间" andColor:[UIColor brownColor] andFont:[UIFont systemFontOfSize:15] andTextAlignment:NSTextAlignmentRight];
    [_bottomView addSubview:_timeLabel];
    
    //布局
    [self masonryFrame];
    
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
        
        NSLog(@"暂停");
    }];
    
    #pragma mark - 进度条拖动
    _slider.slideGes = ^(CGFloat progress){
    
        NSLog(@"当前进度:%f", progress);
    };
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
        
        make.width.equalTo(self);
        make.left.right.equalTo(self);
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
        
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(_topView);
    }];

    [_pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_bottomView).offset(5);
        make.centerY.equalTo(_bottomView);
        make.width.height.mas_equalTo(25);
    }];

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_bottomView).offset(-5);
        make.centerY.equalTo(_bottomView);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(100);
    }];

    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_pauseBtn.mas_right).offset(10);
        make.right.equalTo(_timeLabel.mas_left).offset(-5);
        make.centerY.equalTo(_bottomView);
        make.height.mas_equalTo(2);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
