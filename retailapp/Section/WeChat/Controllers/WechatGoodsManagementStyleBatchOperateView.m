//
//  WechatGoodsManagementStyleBatchOperateView.m
//  retailapp
//
//  Created by zhangzt on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatGoodsManagementStyleBatchOperateView.h"
#import "AlertBox.h"
#import "ServiceFactory.h"
//#import "ListStyleVo.h"
#import "WechatGoodsManagementStyleBatchSelectView.h"
#import "Wechat_StyleVo.h"
#import "WeChatWeShopPriceSet.h"
#import "XHAnimalUtil.h"


@interface WechatGoodsManagementStyleBatchOperateView ()

@property (nonatomic, strong) WechatService* wechatService;

@property (nonatomic) short type;

@property (nonatomic, strong) NSMutableArray* styleIdList;

@property (nonatomic,strong) NSString *shopId;

@property (nonatomic, strong) NSMutableArray* styleList;

@property (nonatomic, strong)WeChatWeShopPriceSet *weChatWeShopPriceSet;

@end

@implementation WechatGoodsManagementStyleBatchOperateView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnTitle.layer setCornerRadius:4];
    [self.btnNotWechatSell.layer setCornerRadius:4];
    [self.btnCancel.layer setCornerRadius:4];
    _wechatService = [ServiceFactory shareInstance].wechatService;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(WechatModule *)parentTemp {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        isExpanded = NO;
    }
    return self;
}

-(void) loadDatas:(NSMutableArray *)styleList shopId:(NSString *)shopId  controller:(UIView *) controller
{
    _shopId = shopId;
    _styleList = styleList;
    _styleIdList = [[NSMutableArray alloc] init];
    _controllerView=controller;
    
    for (Wechat_StyleVo* vo in _styleList) {
        [_styleIdList addObject:vo.styleId];
    }
}


//module中调用
- (void)oper{
    
    [self showMoveIn];
    
}

//视图动画效果
- (void)showMoveIn
{
    self.view.hidden = NO;
    [UIView beginAnimations:@"viewIn" context:nil];
    [UIView setAnimationDuration:0.2];
    //    CGRect mainContainerFrame = self.mainContainer.frame;
    //    self.mainContainer.frame = CGRectMake(mainContainerFrame.origin.x, 0-(64+mainContainerFrame.size.height), mainContainerFrame.size.width, mainContainerFrame.size.height);
    //    self.mainContainer.frame = CGRectMake(mainContainerFrame.origin.x, 64, mainContainerFrame.size.width, mainContainerFrame.size.height);
    [UIView commitAnimations];
}

- (void)hideMoveOut
{
    [UIView beginAnimations:@"viewOut" context:nil];
    [UIView setAnimationDuration:0.2];
    //    CGRect mainContainerFrame = self.mainContainer.frame;
    //    self.mainContainer.frame = CGRectMake(mainContainerFrame.origin.x, 64, mainContainerFrame.size.width, mainContainerFrame.size.height);
    //    self.mainContainer.frame = CGRectMake(mainContainerFrame.origin.x, 0-(64+mainContainerFrame.size.height), mainContainerFrame.size.width, mainContainerFrame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(afterMoveOut:finished:context:)];
    [UIView commitAnimations];
}

- (void)afterMoveOut:(NSString *)paramAnimationID finished:(NSNumber *)paramFinished context:(void *)paramContext
{
    self.view.hidden = YES;
    [self.view removeFromSuperview];
}

- (IBAction)btnTopclick:(UIButton *)sender {
     [self hideMoveOut];
}


- (IBAction)btnNotWechatSellclick:(UIButton *)sender {
    static UIAlertView *alertView;
    if (alertView != nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        alertView = nil;
    }
    alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认不在微店销售吗?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
    _type = 1;
    [alertView show];
}


- (IBAction)btnAddedclick:(UIButton *)sender {
    static UIAlertView *alertView;
    if (alertView != nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        alertView = nil;
    }
    alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认商品批量上架吗?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
    _type = 2;
    [alertView show];
}


- (IBAction)btnOutOfStock:(UIButton *)sender {
    static UIAlertView *alertView;
    if (alertView != nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        alertView = nil;
    }
    alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认商品批量下架吗?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];
    _type = 3;
    [alertView show];
}

-(IBAction)btnBatchAddPriceclick:(UIButton *)sender{
    [self hideMoveOut];

    self.weChatWeShopPriceSet = [[WeChatWeShopPriceSet alloc]initWithNibName:[SystemUtil getXibName:@"WeChatWeShopPriceSet"]   bundle:nil];
    [_controllerView addSubview:self.weChatWeShopPriceSet.view];
    [XHAnimalUtil animal:self.weChatWeShopPriceSet type:kCATransitionPush direction:kCATransitionFromRight];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        __weak WechatGoodsManagementStyleBatchOperateView* weakSelf = self;
        switch (_type) {
            case 1:
            {
                //不在微店销售
                
                [_wechatService setNotSaleMicroStyle:_styleIdList shopId:_shopId completionHandler:^(id json) {
                    if (!(weakSelf)) {
                        return ;
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh" object:nil];
                    [AlertBox show:@"批量删除款式成功!"];
                    [weakSelf hideMoveOut];
//                    [parent showView:GOODS_STYLE_BATCH_SELECT_VIEW];
//                    [parent.goodsStyleBatchSelectView loadDatasFromOperateView:ACTION_CONSTANTS_DEL];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
                
                break;
            }
            case 2:
            {
                //上架
                [_wechatService setMicroStyleUpDownStatus:_styleIdList shopId:_shopId status:@"1" completionHandler:^(id json) {
                    if (!(weakSelf)) {
                        return ;
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh" object:nil];
                    [AlertBox show:@"批量款式上架成功!"];
                     [weakSelf hideMoveOut];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
                break;
            }
            case 3:
            {
                //下架
                [_wechatService setMicroStyleUpDownStatus:_styleIdList shopId:_shopId status:@"2" completionHandler:^(id json) {
                    if (!(weakSelf)) {
                        return ;
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh" object:nil];
                    [AlertBox show:@"批量款式下架成功!"];
                     [weakSelf hideMoveOut];
                } errorHandler:^(id json) {
                    [AlertBox show:json];
                }];
                break;
            }
            default:
                break;
        }
    }
    
}


@end
