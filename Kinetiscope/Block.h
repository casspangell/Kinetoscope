//
//  Block.h
//  Kinetiscope
//
//  Created by Cass Pangell on 7/1/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Block : UIButton <UIImagePickerControllerDelegate>{
    double blockNumber;
    UIView *blockStringView;
    NSString *blockMoviePath;
}

@property(nonatomic) NSString *blockLabel;

-(CGFloat)getWidth;
-(CGFloat)getHeight;

-(void)setBlockNumber:(int)blockNum;
-(int)getBlockNumber;

-(void)setBlockMoviePath:(NSString*)mPath;
-(NSString*)getBlockMoviePath;
@end
