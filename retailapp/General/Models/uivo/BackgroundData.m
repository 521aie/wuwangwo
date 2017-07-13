//
//  BackgroundData.m
//  CardApp
//
//  Created by 邵建青 on 14-2-27.
//  Copyright (c) 2014年 ZMSOFT. All rights reserved.
//

#import "BackgroundData.h"

@implementation BackgroundData
@synthesize smallImgName;
@synthesize normalBgName;
@synthesize blackBgName;

- (id)init:(NSString *)smallImgNameP normalBgName:(NSString *)normalBgNameP blackBgName:(NSString *)blackBgNameP
{
    self = [super init];
    if(self) {
        self.smallImgName = smallImgNameP;
        self.normalBgName = normalBgNameP;
        self.blackBgName = blackBgNameP;
    }
    return self;
}

@end
