//
//  MainPageShowView.h
//  retailapp
//
//  Created by qingmei on 15/9/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"

@interface MainPageShowView : LSRootViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray        *headList;  //tableview header数据
@property (nonatomic, strong) NSMutableDictionary   *detailMap; //tableview cell数据

//数据加载
- (void)reload;
@end
