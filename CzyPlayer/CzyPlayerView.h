//  CzyPlayerView.h
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

#import <UIKit/UIKit.h>

typedef void(^ScreenDidRotate)(UIDeviceOrientation);

@interface CzyPlayerView : UIView

/**播放url 可以是本地或者网络url*/
@property (nonatomic, copy) NSString *playUrl;
/**播放地址*/
@property (nonatomic, strong) NSArray *playUrls;

/**播放层的父视图*/
@property (nonatomic, weak) UIView *playSuperView;

/**播放器屏幕方向旋转回调*/
@property (nonatomic, copy) ScreenDidRotate screenDidRotate;


/**缓冲条颜色 默认是棕色*/
@property (nonatomic, strong) UIColor *cacheProgressColor;

/**滑动时进度条顶部显示时间的颜色 默认是白色*/
@property (nonatomic, strong) UIColor *tapTimePopViewColor;

/**进度条已缓存进度颜色*/
@property (nonatomic, strong) UIColor *loadedProgreeViewColor;
/**进度条已缓存进度颜色数组 设置该数组则顶部时间显示条也会带颜色*/
@property (nonatomic, strong) NSArray *loadedProgreeViewColors;




/**开始播放*/
- (void)play;

/**未播放完成是 手动切换播放新地址*/
- (void)playWithNewUrl:(NSString *)url;
@end
