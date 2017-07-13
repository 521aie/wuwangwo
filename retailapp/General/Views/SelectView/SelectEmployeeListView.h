//
//  SelectEmployeeListView.h
//  retailapp
//
//  Created by qingmei on 15/10/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

typedef void(^SelectEmployeeHandler)(NSDictionary* selectUser);

#import <UIKit/UIKit.h>
@class NavigateTitle2,SearchBar2,EditItemList,SelectOrgShopListView,KindMenuView;

@interface SelectEmployeeListView : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView       *titleDiv;              //导航栏容器
@property (strong, nonatomic) NavigateTitle2        *titleBox;              //导航栏
@property (strong, nonatomic) IBOutlet UITableView  *mainGrid;              //tableView
@property (strong, nonatomic) IBOutlet SearchBar2   *seachBar;              //搜索栏
@property (strong, nonatomic) IBOutlet EditItemList *itemListShopSelect;    //选择门店
/**权限一览右侧弹出页面*/
@property (nonatomic, strong) KindMenuView *selectKindMenuView;
@property (nonatomic, assign) NSInteger shopMode; //1 单店 2门店 3组织机构

@property (nonatomic, strong) NSString              *selectedUerId;         //选中员工的ID

/*
 *是不是查询自己店的员工
 * YES 查询机构或门店自己的员工 不包括下属机构和门店
 * NO  查询机构或门店自己的员工 包括下属机构和门店
 */
@property (nonatomic, assign) BOOL isSelfShop;

/**页面初始化*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
/**进入共同页面调用,SelectEmployeeHandler返回员工数据*/
- (void)loadDataWithCallBack:(SelectEmployeeHandler)handler;

@end
