//
//  WechatGoodsManagementStyleAddChooseView.m
//  retailapp
//
//  Created by zhangzt on 15/10/20.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "WechatGoodsManagementStyleAddChooseView.h"

@interface WechatGoodsManagementStyleAddChooseView ()<UIActionSheetDelegate>

@end

@implementation WechatGoodsManagementStyleAddChooseView

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle:nil
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                           otherButtonTitles: @"自选款式", @"主题推荐款式", nil];
    [menu showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        self.callBack(@"自选款式进入款式选择共通页面");
    }else if (buttonIndex ==1){
       self.callBack(@"主题推荐款式进入选择主题销售包");
    }else{
        [self.view removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
