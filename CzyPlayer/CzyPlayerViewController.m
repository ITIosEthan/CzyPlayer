//  CzyPlayerViewController.m
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

#import "CzyPlayerViewController.h"
#import "CzyPlayItems.h"

@interface CzyPlayerViewController ()
@property (nonatomic, strong) NSMutableArray *playItems;
@property (nonatomic, strong) CzyPlayView *playView;

@end

@implementation CzyPlayerViewController

- (NSMutableArray *)playItems
{
    if (!_playItems) {
        self.playItems = [NSMutableArray array];

        for (NSInteger i=0; i<2; i++) {
            
            CzyPlayItems *item = [[CzyPlayItems alloc] init];
            
            NSURL *url;
            NSString *name;
            if (i == 1) {
                url = [[NSBundle mainBundle] URLForResource:@"file2" withExtension:@"mp4"];
                name = @"offline film";
            }else{
                url = [NSURL URLWithString:ONLINE];
                name = @"online film";
            }
            
            item.url = url;
            item.name = name;
            
            [self.playItems addObject:item];
        }
    }
    return _playItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self listeningRotating];
    [self czyInitPlayerLayerWithFrame:CGRectMake(0, 0, CZY_FULL_WIDTH, 200)];

}

/**
 *  监听设备旋转通知
 */
- (void)listeningRotating {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)onDeviceOrientationChange
{
    [self.playView removeFromSuperview];
    self.playView = nil;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationPortrait) {
        
        [self czyInitPlayerLayerWithFrame:CGRectMake(0, 0, CZY_FULL_WIDTH, 300)];
    }else{
        
        [self czyInitPlayerLayerWithFrame:CGRectMake(0, 0, CZY_FULL_HEIGHT, CZY_FULL_WIDTH)];
    }
}

#pragma mark - czyInitPlayerLayer
- (void)czyInitPlayerLayerWithFrame:(CGRect)frame
{
    self.playView = [[CzyPlayView alloc] czyInitPlayerLayerWithPlayerItem:self.playItems.firstObject andFrame:frame];
    [self.view addSubview:self.playView];

}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)dealloc
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

#pragma mark - StatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
