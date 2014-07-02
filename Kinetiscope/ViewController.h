//
//  ViewController.h
//  Kinetiscope
//
//  Created by Cass Pangell on 7/1/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController <UIScrollViewDelegate>{
    NSMutableArray *blockArray;
}

-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate;

// Executed after a video is saved to the Asset/Photo Library.
-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo;

@property(nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic) IBOutlet UIView *blockView;
@property(nonatomic) IBOutlet UIButton *recordButton;
@property(nonatomic) IBOutlet UIButton *blockButton;

@end
