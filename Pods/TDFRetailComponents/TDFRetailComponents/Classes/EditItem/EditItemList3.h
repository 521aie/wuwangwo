//
//  EditItemList2.h
//  retailapp
//
//  Created by diwangxie on 16/4/28.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemBase.h"

@class EditItemList3;
@protocol EditItemList3Delegate <NSObject>
- (void)btnDelClick:(EditItemList3 *)item;
@end

@interface EditItemList3 : EditItemBase
@property (nonatomic, strong) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleCode;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleName;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *btnDel;
@property (nonatomic, strong) id<EditItemList3Delegate> delegate;

- (void)initFromNib:(id<EditItemList3Delegate>)delegate;

-(void)initCode:(NSString *) code initName:(NSString*)name;
- (void) changeData:(NSString*)code withVal:(NSString*)name;
-(NSString *)getVal;

@end
