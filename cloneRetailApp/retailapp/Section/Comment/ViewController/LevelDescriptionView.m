//
//  LevelDescriptionView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/11/12.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LevelDescriptionView.h"

@interface LevelDescriptionView ()

@end

@implementation LevelDescriptionView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.scrollView.contentSize = CGSizeMake(320, 450);
    [self createNav];
    [self configHelpButton:HELP_COMMENT];
}

-(void)createNav
{
    [self configTitle:@"等级说明" leftPath:Head_ICON_BACK rightPath:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
