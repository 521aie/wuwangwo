//
//  AddItem.m
//  retailapp
//
//  Created by hm on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "AddItem.h"
#import "UIView+Sizes.h"

@implementation AddItem

+ (AddItem*)loadFromNib
{
    AddItem* addItem = [[[NSBundle mainBundle] loadNibNamed:@"AddItem" owner:self options:nil] lastObject];
    addItem.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 48);
    return addItem;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)addBtnClick:(id)sender
{
    if (_delegate&&[_delegate respondsToSelector:@selector(showAddItemEvent)]) {
        [_delegate showAddItemEvent];
    }
}

- (void)initDelegate:(id<AddItemDelegate>)addItemDelegate titleName:(NSString*)titleName
{
    self.lblName.text = titleName;
    self.delegate = addItemDelegate;
}

- (float) getHeight{
    return self.line.ls_top+self.line.ls_height;
}

-(void) visibal:(BOOL)show
{
    [self setLs_height:show?[self getHeight]:0];
    self.hidden = !show;
}

@end
