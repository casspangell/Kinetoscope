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

        self.backgroundColor = [UIColor redColor];
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

-(void)setBlockNumber:(int)blockNum {
    blockNumber = blockNum;
}

-(int)getBlockNumber {
    return blockNumber;
}

-(void)setBlockMoviePath:(NSString*)mPath{
    blockMoviePath = mPath;
}

-(NSString*)getBlockMoviePath{
    return blockMoviePath;
}


@end
