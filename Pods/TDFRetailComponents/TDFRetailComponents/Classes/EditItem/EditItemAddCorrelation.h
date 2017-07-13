//
//  EditItemAddCorrelation.h
//  retailapp
//
//  Created by diwangxie on 16/4/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditItemBase.h"
#import "EditItemAddCorrelation.h"

@class EditItemAddCorrelation;
@protocol EditItemAddCorrelationDelegate <NSObject>
- (void)addClick:(EditItemAddCorrelation *)item;
@end

@interface EditItemAddCorrelation : EditItemBase
@property (nonatomic, strong) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *btnAddCorrelation;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) id<EditItemAddCorrelationDelegate> delegate;

-(void)initView:(NSString *) title delegate:(id<EditItemAddCorrelationDelegate>)delegate;

- (IBAction)btnAddClick:(UIButton *)sender;

@end
