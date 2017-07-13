//
//  MemberTypeListView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/3.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleListView.h"
#import "MemberTypeVo.h"
@class MemberModule, SettingService, KindCardVo;
@interface MemberTypeListView : SampleListView<ISampleListEvent>

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

-(void) loadDatas;

// 从编辑页面返回
-(void) loadDatasFromEdit:(KindCardVo*) kindCardVo action:(int) action;
@end
