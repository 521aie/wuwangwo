//
//  SendTimeListView.h
//  retailapp
//
//  Created by Jianyong Duan on 15/10/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NavigateTitle2;
@class WechatModule;

typedef void(^CallBack)(NSArray *sendTimeList);

@interface SendTimeListView : BaseViewController {
    WechatModule *parent;
}

@property (nonatomic, strong) CallBack callBack;

@property (nonatomic) NavigateTitle2 *titleBox;
@property (weak, nonatomic) IBOutlet UIView *titleDiv;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, strong) NSString *sendTime;

//headView
@property (strong, nonatomic) IBOutlet UIView *viewHead;
@property (weak, nonatomic) IBOutlet UIView *headMarkView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(WechatModule *)_parent;

@end
