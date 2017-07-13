//
//  SelectStaffListView.h
//  retailapp
//
//  Created by hm on 16/3/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "SelectSampleListView.h"

@class EmlpoyeeUserIntroVo;
typedef void(^CallBack)(EmlpoyeeUserIntroVo *employeeVo);
@interface SelectStaffListView : SelectSampleListView

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

/**
 *  页面入口
 *
 *  @param shopId   门店或机构id
 *  @param selectId 选择员工id
 *  @param roleType 角色类型|1 门店|2 机构|
 *  @param callBack 回调
 */
- (void)loadDataById:(NSString *)shopId
            selectId:(NSString *)selectId
            roleType:(NSInteger)roleType
            callBack:(CallBack)callBack;

@end
