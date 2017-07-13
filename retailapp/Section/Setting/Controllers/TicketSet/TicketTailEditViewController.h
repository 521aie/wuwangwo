//
//  TicketTailEditViewController.h
//  retailapp
//
//  Created by taihangju on 16/8/31.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"


@class TailModel;

typedef void(^NewTailBlock)(TailModel *tailModel);
typedef NS_ENUM(NSInteger ,TailType) {
    TailEdit = 0, // 编辑尾注
    TailAdd, // 添加尾注
    TailDel, // 删除尾注
};
@interface TicketTailEditViewController : LSRootViewController

@property (nonatomic ,strong) NSArray *currentTailArray;/*<当前已有尾注>*/

- (instancetype)init:(TailModel *)model callBack:(NewTailBlock)tailBlock;
@end


@interface TailModel : NSObject

@property (nonatomic ,strong) NSString *rawTailString;/*<raw 尾注>*/
@property (nonatomic ,strong) NSString *editTailString;/*<编辑后的 尾注>*/
@property (nonatomic ,assign) TailType tailType;/*<尾注操作类型>*/
@property (nonatomic ,assign) NSInteger index;/*<尾注的index>*/
@property (nonatomic ,strong) NSString *shopId;/*<当前选择的机构/门店的shopID>*/

- (instancetype)init:(NSString *)tailStr index:(NSInteger)index type:(TailType)type shopId:(NSString *)shopId;
@end
