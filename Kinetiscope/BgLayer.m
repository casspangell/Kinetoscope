//
//  BgLayer.m
//  Kinetiscope
//
//  Created by Cass Pangell on 2/11/15.
//  Copyright (c) 2015 mondolabs. All rights reserved.
//

#import "BgLayer.h"


@implementation BgLayer

-(id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame])
    {
        [self setUpView];
    }
    return self;
}

#pragma mark - Set Up Background
-(void)setUpView {

    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"Chasing_Mavericks" ofType:@"mp4"];
    AVAsset *avAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:moviePath]];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    _avPlayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replayMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:avPlayerItem];
    
    [avPlayerLayer setVideoGravity:@"AVLayerVideoGravityResizeAspectFill"];
    [avPlayerLayer setFrame:self.frame];
    [self.layer addSublayer:avPlayerLayer];
    [_avPlayer setMuted:YES];

    [_avPlayer seekToTime:kCMTimeZero];
    [_avPlayer play];
}

-(void)replayMovie:(NSNotification *)notification
{
   [_avPlayer seekToTime:kCMTimeZero];
    [_avPlayer play];
}

@end
