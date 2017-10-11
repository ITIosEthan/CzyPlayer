//  CzyRootViewController.m
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

#import "CzyRootViewController.h"
#import "CzyPlayerView.h"

@interface CzyRootViewController ()

@end

@implementation CzyRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;
    
    CzyPlayerView *playView = [[CzyPlayerView alloc] init];
    
    playView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    
    playView.playUrl = @"http://flv3.bn.netease.com/videolib3/1710/11/YcDjZ7703/HD/YcDjZ7703-mobile.mp4";
    
    [self.view addSubview:playView];
}



@end
