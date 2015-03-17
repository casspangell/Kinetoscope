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
        self.layer.cornerRadius = 7;
        self.layer.masksToBounds = YES;
        
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
        UILongPressGestureRecognizer* longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        [self addGestureRecognizer:longGestureRecognizer];

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
    
    bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [bg setBackgroundColor:[UIColor colorWithWhite:0 alpha:.2]];
    [self addSubview:bg];
}

#pragma mark - Touches
-(void)pressed:(id)sender {
    NSLog(@"touch %@", sender);
}

-(void)longPressed:(UILongPressGestureRecognizer*)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Long press Ended");
    } else if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long press detected.");
        
        
        if (setOn) {
            setOn = NO;
            [bg setBackgroundColor:[UIColor colorWithWhite:0 alpha:.2]];
        }else{
            setOn = YES;
            [bg setBackgroundColor:[UIColor colorWithWhite:0 alpha:.8]];
        }
        
    }

}

@end
