//  NormalViewController.m
//  CzyPlayer
//  Created by macOfEthan on 17/10/12.
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

#import "NormalViewController.h"
#import "CzyPlayerView.h"

@interface NormalViewController ()
@property (nonatomic, weak) CzyPlayerView *playView;

@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    CzyPlayerView *playView = [[CzyPlayerView alloc] init];
    playView.playSuperView = self.view;
    
    playView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    
    playView.playUrl = @"http://flv3.bn.netease.com/videolib3/1710/11/YcDjZ7703/HD/YcDjZ7703-mobile.mp4";
    
    playView.cacheProgressColor = [UIColor redColor];
    playView.loadedProgreeViewColor = [UIColor greenColor];
    
    [self.view addSubview:playView];
    
    self.playView = playView;
}

- (void)dealloc
{
    [self.playView removeFromSuperview];
    self.playView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
