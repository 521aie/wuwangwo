//
//  IImageDataItem.h
//  RestApp
//
//  Created by zxh on 14-4-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IImageDataItem <NSObject>

@required
-(NSString*) obtainItemId;
-(NSString*) obtainItemName;
-(NSString*) obtainOrignName;

-(NSString*) obtainItemValue;

-(NSString*) obtainImgpath;
-(NSString*) obtainHeadId;
-(NSString*) obtainItemSpell;
@end
