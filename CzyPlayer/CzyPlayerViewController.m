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

    [self czyInitPlayerLayer];
    
    [self observerPlayer];
}

#pragma mark - czyInitPlayerLayer
- (void)czyInitPlayerLayer
{
    self.playView = [[CzyPlayView alloc] czyInitPlayerLayerWithPlayerItem:self.playItems.firstObject andFrame:CGRectMake(0, 0, CZY_FULL_WIDTH, 300)];
    [self.view addSubview:self.playView];
}

#pragma mark - observerPlayer
- (void)observerPlayer
{
    [self.playView.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playView.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - observeValueForKeyPath
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            
            [self.playView.player play];
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    [self.playView.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playView.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

#pragma mark - StatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
