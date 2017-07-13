//
//  WechatGoodsManagementStyleBatchOperateView.h
//  retailapp
//
//  Created by zhangzt on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WechatModule;
@interface WechatGoodsManagementStyleBatchOperateView : UIViewController
{
    WechatModule *parent;
    
    BOOL isExpanded;
}

@property (nonatomic,strong) UIView *controllerView;
- (IBAction)btnTopclick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (weak, nonatomic) IBOutlet UIButton *btnNotWechatSell;
- (IBAction)btnNotWechatSellclick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAdded;
- (IBAction)btnAddedclick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnOutOfStock;
- (IBAction)btnOutOfStock:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnTitle;
- (IBAction)btnBatchAddPriceclick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnBatch;

-(void) loadDatas:(NSMutableArray *)styleList shopId:(NSString *)shopId  controller:(UIView *) controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(WechatModule *)parentTemp;

- (void)oper;
@end
