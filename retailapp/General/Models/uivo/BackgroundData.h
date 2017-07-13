//
//  BackgroundData.h
//  CardApp
//
//  Created by 邵建青 on 14-2-27.
//  Copyright (c) 2014年 ZMSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundData : NSObject

@property(nonatomic, retain) NSString *smallImgName;
@property(nonatomic, retain) NSString *normalBgName;
@property(nonatomic, retain) NSString *blackBgName;

- (id)init:(NSString *)smallImgNameP normalBgName:(NSString *)normalBgNameP blackBgName:(NSString *)blackBgNameP;

@end
