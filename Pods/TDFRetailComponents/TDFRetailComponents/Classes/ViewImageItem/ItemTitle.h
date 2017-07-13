//
//  ItemTitle.h
//  RestApp
//
//  Created by zxh on 14-4-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemBase.h"
#import "IItemTitleEvent.h"

@interface ItemTitle : UIView<ItemBase>
{
    UIView *view;
}
@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UIView *line;

@property (nonatomic, strong) IBOutlet UIImageView *imgAdd;
@property (nonatomic, strong) IBOutlet UIButton *btnAdd;

@property (nonatomic, strong) IBOutlet UIImageView *imgSort;
@property (nonatomic, strong) IBOutlet UIButton *btnSort;

@property (nonatomic, weak) id<IItemTitleEvent> delegate;
@property (nonatomic) NSInteger event;

//仅支持Add,Sort 按钮.
- (void)initDelegate:(id<IItemTitleEvent>)delegate event:(NSInteger)event btnArrs:(NSArray*)arr;

- (IBAction)btnAddClick:(id)sender;

- (IBAction)btnSortClick:(id)sender;

- (void)visibal:(BOOL)show;

+ (ItemTitle *)itemTitle:(NSString *)text;
@end
