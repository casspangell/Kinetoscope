//
//  BlockObj.m
//  Kinetiscope
//
//  Created by Cass Pangell on 7/3/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import "BlockObj.h"

@implementation BlockObj

- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"entityId" : KCSEntityKeyId, //the required _id field
             @"userId" : @"userId",
             @"fileId" : @"fileId",
             @"block" : @"block",
             @"name" : @"name",
             @"date" : @"date"
            // @"metadata" : KCSEntityKeyMetadata //optional _metadata field
             };
}

@end
