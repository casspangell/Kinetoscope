//
//  Block.m
//  Kinetiscope
//
//  Created by Cass Pangell on 7/1/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import "Block.h"

@implementation Block

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.frame = CGRectMake(0, 0, 100, 100);

    }
    
    return self;
}

#pragma mark - Getters / Setters
-(CGFloat)getWidth {
    return self.frame.size.width;
}

-(CGFloat)getHeight {
    return self.frame.size.height;
}

-(void)setBlockNumber:(NSString*)blockNum {
    blockNumber = blockNum;
}

-(NSString*)getBlockNumber {
    return blockNumber;
}

-(void)setBlockMoviePath:(NSString*)mPath{
    blockMoviePath = mPath;
}

-(NSString*)getBlockMoviePath{
    return blockMoviePath;
}

-(UIImage*)getPhoto {
    return photo;
}

-(void)setPhoto:(UIImage*)p {
    photo = p;
    [self setBackgroundImage:photo forState:UIControlStateNormal];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [bg setBackgroundColor:[UIColor colorWithWhite:0 alpha:.2]];
    [self addSubview:bg];
}


@end
