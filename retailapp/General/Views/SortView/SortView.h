//
//  SortView.h
//  retailapp
//
//  Created by qingmei on 15/11/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//


@interface SortObject : NSObject
/**ID*/
@property (nonatomic, assign) NSInteger objectId;
/**name*/
@property (nonatomic, strong) NSString  *objectName;
/**sortCode*/
@property (nonatomic, assign) NSInteger sortCode;
@end

@protocol SortViewDelegate <NSObject>
/**取消*/
- (void)SortViewCancel;
/**保存*/
- (void)SortViewSave;
/**排序事件*/
- (void)SortViewMoveRowAtIndexPath:(NSInteger)sourceIndexPath toIndexPath:(NSInteger)destinationIndexPath;
@end


#import "LSRootViewController.h"

@interface SortView : LSRootViewController
@property (strong, nonatomic) UITableView *mainGrid;

/**使用原始数据初始化*/
/**sourceList为排序名称的列表,sourceList里的对象必须为SortObject*/
- (id)initWithSourceList:(NSArray *)sourceList andDelegate:(id<SortViewDelegate>) delegate;


@end
