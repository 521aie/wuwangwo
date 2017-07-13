//
//  SendTimeListView.m
//  retailapp
//
//  Created by Jianyong Duan on 15/10/15.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "SendTimeListView.h"
#import "SendTimeCell.h"

#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "ViewFactory.h"
#import "UIHelper.h"
#import "AddTimeListView.h"

@interface SendTimeListView () <INavigateEvent>

@property (nonatomic, strong) NSMutableArray *arrSendTime;
@property (nonatomic, strong) AddTimeListView *addTimeListView;
@property (nonatomic, assign) NSInteger tag;
@end

@implementation SendTimeListView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(WechatModule *)_parent {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent=_parent;
        
        self.arrSendTime = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initGrid];
    
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:self.navTitle backImg:Head_ICON_BACK moreImg:nil];
    [self.titleDiv addSubview:self.titleBox];
    
    self.view.backgroundColor=[UIColor clearColor];
    self.headMarkView.layer.cornerRadius = 4;
}

-(void)initGrid
{
    self.tableView.opaque=YES;
    UIView* view=[ViewFactory generateFooter:60];
    view.backgroundColor=[UIColor clearColor];
    
    [self.tableView setTableFooterView:view];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


- (void)setSendTime:(NSString *)sendTime {
    
    _sendTime = [sendTime stringByReplacingOccurrencesOfString:@"," withString:@"@"];
    NSLog(@"%@",_sendTime);
    
    NSArray *array = [_sendTime componentsSeparatedByString:@"@"];
    
    for (int i = 0; i < array.count; i++) {
        NSString *timeString = [array objectAtIndex:i];
        
        NSArray *times = [timeString componentsSeparatedByString:@"~"];
        if (times.count == 2) {
            [self.arrSendTime addObject:@{@"startTime":times[0], @"endTime":times[1]}];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) onNavigateEvent:(Direct_Flag)event {
    if (event==1) {
        self.callBack(self.arrSendTime);
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrSendTime.count;
}

#pragma table head
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.viewHead;
}

#pragma table部分
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"sendTimeCellIdentifier";
    SendTimeCell *detailItem = (SendTimeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!detailItem) {
        [tableView registerNib:[UINib nibWithNibName:@"SendTimeCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        detailItem = (SendTimeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    NSDictionary *dic = [self.arrSendTime objectAtIndex:indexPath.row];
    
    detailItem.lblStartTime.text = [dic objectForKey:@"startTime"];
    detailItem.lblEndTime.text = [dic objectForKey:@"endTime"];
    
    detailItem.btnDelete.tag = indexPath.row;
    [detailItem.btnDelete addTarget:self action:@selector(deleteSendTime:) forControlEvents:UIControlEventTouchUpInside];
    
    return detailItem;
}

- (void)deleteSendTime:(UIButton *)sender {
    self.tag=sender.tag;
//    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    static UIAlertView *alertView;
    if (alertView != nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        alertView = nil;
    }
    
    NSDictionary *dic =self.arrSendTime[self.tag];
    NSString*sendtime=[NSString stringWithFormat:@"确认删除[%@~%@]配送时间吗？",dic[@"startTime"], dic[@"endTime"]];
    alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:sendtime delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确认", nil];

    [alertView show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.arrSendTime removeObjectAtIndex:self.tag];
        [self.tableView reloadData];
    }
    
}

- (IBAction)addTimeClick:(id)sender {
    
    _addTimeListView = [[AddTimeListView alloc] initWithNibName:[SystemUtil getXibName:@"AddTimeListView"] bundle:nil];
    
    __weak typeof(self) weakSelf = self;
    self.view.hidden=YES;
    [_addTimeListView addTimeCallBack:^(NSString *starttime, NSString *endtime) {
        weakSelf.view.hidden=NO;
        [weakSelf.arrSendTime addObject:@{@"startTime":starttime, @"endTime":endtime}];
        [weakSelf.tableView reloadData];
        
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    } cancelTime:^{
        weakSelf.view.hidden=NO;
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    }];
    _addTimeListView.arrSendTime=self.arrSendTime;
    [self.navigationController pushViewController:_addTimeListView animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromRight];
}

@end
