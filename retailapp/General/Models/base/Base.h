//
//  Base.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

typedef enum
{
    BASE_FALSE=0, //flase值
    BASE_TRUE=1   //true值,
    
}BASE_FLAG;


@interface Base : Jastor

@property (nonatomic,retain) NSString *_id;
@property long long lastVer;
@property short isValid;
@property long long createTime;
@property long long opTime;

@end
