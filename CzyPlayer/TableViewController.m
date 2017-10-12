//  TableViewController.m
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

#import "TableViewController.h"
#import "CzyPlayerView.h"

@interface TableViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) CzyPlayerView *playView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *urls;

@end

@implementation TableViewController

- (NSArray<NSString *> *)urls
{
    if (!_urls) {
        
        self.urls = [[NSArray alloc] initWithObjects:@"http://flv3.bn.netease.com/videolib3/1710/11/YcDjZ7703/HD/YcDjZ7703-mobile.mp4",@"http://flv3.bn.netease.com/videolib3/1710/12/aNQlS1522/SD/aNQlS1522-mobile.mp4", nil];
        
    }
    return _urls;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];

    CzyPlayerView *playView = [[CzyPlayerView alloc] init];
    
    playView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    playView.cacheProgressColor = [UIColor redColor];
    
    self.playView = playView;
    self.playView.playSuperView = self.view;

    self.playView.playUrl = self.urls.firstObject;
    
    _tableView.tableHeaderView = self.playView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reusedId = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = @[@"url1", @"url2"][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:

            [self.playView replaceCurrentPlayItemWithUrl:self.urls.firstObject];
            break;
            
        default:

            [self.playView replaceCurrentPlayItemWithUrl:self.urls.lastObject];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (void)dealloc
{
    
    [_playView removeFromSuperview];
    _playView = nil;
    
    [_tableView removeFromSuperview];
    _tableView = nil;
    
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

@end
