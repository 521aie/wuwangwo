//
//  AddItem.h
//  retailapp
//
//  Created by hm on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddItemDelegate <NSObject>
@required
- (void)showAddItemEvent;

@end

@interface AddItem : UIView

@property (nonatomic,weak) IBOutlet UILabel* lblName;

@property (nonatomic,weak) IBOutlet UIView* line;

@property (nonatomic,weak) id<AddItemDelegate>delegate;

- (IBAction)addBtnClick:(id)sender;

- (void)initDelegate:(id<AddItemDelegate>)addItemDelegate titleName:(NSString*)titleName;

+ (AddItem*)loadFromNib;

-(void) visibal:(BOOL)show;

@end
