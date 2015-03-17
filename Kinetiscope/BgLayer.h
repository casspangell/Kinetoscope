//
//  BgLayer.h
//  Kinetiscope
//
//  Created by Cass Pangell on 2/11/15.
//  Copyright (c) 2015 mondolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface BgLayer : UIView

@property(nonatomic) MPMoviePlayerController *moviePlayer;
@property(nonatomic) AVPlayer *avPlayer;
@end
