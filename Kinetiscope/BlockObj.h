
//
//  BlockObj.h
//  Kinetiscope
//
//  Created by Cass Pangell on 7/3/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Block.h"
#import <KinveyKit/KinveyKit.h>

@interface BlockObj : NSObject <KCSPersistable>

@property (nonatomic, copy) NSString* entityId; //Kinvey entity _id
@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NSString* fileId;
@property (nonatomic, copy) Block* block;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSDate* date;

//@property (nonatomic, retain) KCSMetadata* metdata; //Kinvey metadata, optional

@end
