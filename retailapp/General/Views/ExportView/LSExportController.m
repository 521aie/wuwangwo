//
//  LSExportController.m
//  retailapp
//
//  Created by taihangju on 2016/12/5.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSExportController.h"
#import "NavigateTitle2.h"

@interface LSExportController ()<INavigateEvent>

@property (nonatomic ,strong) NavigateTitle2 *titleBox;/*<导航栏>*/
@end

@implementation LSExportController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
