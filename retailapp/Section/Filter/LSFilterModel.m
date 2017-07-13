//
//  LSFilterModel.m
//  retailapp
//
//  Created by guozhi on 2016/10/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSFilterModel.h"
#import "LSFilterCell.h"

@implementation LSFilterModel
+ (instancetype)filterModel:(LSFilterModelType)type items:(NSArray<LSFilterItem *> *)items selectItem:(LSFilterItem *)selectItem title:(NSString *)title {
    LSFilterModel *model = [[LSFilterModel alloc] init];
    model.type = type;
    model.items = items;
    model.selectItem = selectItem;
    model.oldSelectItem = selectItem;
    model.title = title;
    return model;
}
- (void)setSelectItem:(LSFilterItem *)selectItem {
    _selectItem = selectItem;
    [self.cell setModel:self];
}

- (NSString *)getSelectItemName {
    return self.selectItem.itemName;
}

- (NSString *)getSelectItemId {
    return self.selectItem.itemId;
}

- (void)initData:(NSString *)itemName withVal:(NSString *)itemId {
    self.selectItem = [LSFilterItem filterItem:itemName itemId:itemId];
}
@end
