//
//  Block.h
//  Kinetiscope
//
//  Created by Cass Pangell on 7/1/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Block : UIButton <UIImagePickerControllerDelegate>{
    NSString* blockNumber;
    UIView *blockStringView;
    NSString *blockMoviePath;
    UIImage *photo;
}

@property(nonatomic) NSString *blockLabel;

-(CGFloat)getWidth;
-(CGFloat)getHeight;

-(void)setBlockNumber:(NSString*)blockNum;
-(NSString*)getBlockNumber;

-(void)setBlockMoviePath:(NSString*)mPath;
-(NSString*)getBlockMoviePath;

-(UIImage*)getPhoto;
-(void)setPhoto:(UIImage*)p;
@end
