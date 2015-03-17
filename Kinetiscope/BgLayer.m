//
//  BgLayer.m
//  Kinetiscope
//
//  Created by Cass Pangell on 2/11/15.
//  Copyright (c) 2015 mondolabs. All rights reserved.
//

#import "BgLayer.h"
#import <AVFoundation/AVFoundation.h>

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
    
    // find movie file
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"Chasing_Mavericks" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    // load movie
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    _moviePlayer.view.frame = self.frame;
    _moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    [self addSubview:self.moviePlayer.view];
    [self sendSubviewToBack:self.moviePlayer.view];
    [_moviePlayer play];
    
    // loop movie
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(replayMovie:)
                                                 name: MPMoviePlayerPlaybackDidFinishNotification
                                               object: self.moviePlayer];
}

-(void)replayMovie:(NSNotification *)notification
{
    [self.moviePlayer play];
}

@end
