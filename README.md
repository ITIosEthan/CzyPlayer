# CzyPlayer
一个支持全屏切换 状态栏切换 进度条拖动点击等的播放器 支持自定义界面

#### How to use
```
    CzyPlayerView *playView = [[CzyPlayerView alloc] init];
    
    playView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    
    playView.playUrl = @"http://flv3.bn.netease.com/videolib3/1710/11/YcDjZ7703/HD/YcDjZ7703-mobile.mp4";
    
    playView.cacheProgressColor = [UIColor redColor];
    playView.loadedProgreeViewColor = [UIColor greenColor];
    playView.loadedProgreeViewColors = @[[UIColor lightGrayColor],[UIColor blueColor], [UIColor greenColor]];
    
    [self.view addSubview:playView];
```

#### 效果图
![效果图](https://github.com/ITIosEthan/CzyPlayer/blob/master/czyplayer.gif)
