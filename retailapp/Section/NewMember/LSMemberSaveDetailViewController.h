//
//  LSMemberSaveDetailViewController.h
//  retailapp
//
//  Created by taihangju on 16/10/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//
// "储值明细" 或者 "积分明细"

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger ,MBDetailType) {
    MBDetailSavingType, // 储值明细
    MBDetailIntegralType, // 积分明细
};

// 积分明细 ， 储值明细
@interface LSMemberSaveDetailViewController : BaseViewController

- (instancetype)init:(MBDetailType)type cards:(NSArray *)cardVoList selectCard:(id)cardVo;
@end
