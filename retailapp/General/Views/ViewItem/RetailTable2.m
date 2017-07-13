//
//  RetailTable2.m
//  retailapp
//
//  Created by zhangzhiliang on 15/8/24.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "RetailTable2.h"
#import "UIHelper.h"
#import "RetailTableCell2.h"
#import "UIView+Sizes.h"
#import "INameValueItem.h"

@implementation RetailTable2

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"RetailTable2" owner:self options:nil];
    [self addSubview:self.view];
    [self initGrid];
}

-(void)initGrid
{
    self.mainGrid.opaque=NO;
    self.mainGrid.scrollEnabled=NO;
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void) initDelegate:(id<ISampleListEvent>)delegate event:(NSString*)event kindName:(NSString*)kindName addName:(NSString*)addName
{
    self.delegate=delegate;
    self.event=event;
    self.kindName=kindName;
    self.addName=addName;
    self.lblName.text=addName;
}

-(void) loadData:(NSMutableArray*)dataList detailCount:(NSUInteger)detailCount
{
    if ([self.isCanDeal isEqualToString:@"0"]) {
        self.dataList=dataList;
        self.detailCount=detailCount;
        NSUInteger height=(dataList==nil || dataList.count==0)?0:(dataList.count*88);
        [self.mainGrid setLs_height:height];
        [self.view setLs_height:height+88];
        [self.footView setHidden:YES];
        
        [self setLs_height:height];
        [self.mainGrid reloadData];
    } else {
        self.dataList=dataList;
        self.detailCount=detailCount;
        NSUInteger height=(dataList==nil || dataList.count==0)?0:(dataList.count*88);
        [self.mainGrid setLs_height:height];
        [self.view setLs_height:height+88];
        [self.footView setLs_top:height];
        
        [self setLs_height:height+88];
        [self.mainGrid reloadData];
    }
}

#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.viewTag == SPECIAL_OFFER_EDIT_VIEW || self.viewTag == MARKET_SALES_EDIT_VIEW) {
        RetailTableCell2 *detailItem = (RetailTableCell2 *)[tableView dequeueReusableCellWithIdentifier:RetailTableCell2Indentifier];
        
        if (!detailItem) {
            detailItem = [[NSBundle mainBundle] loadNibNamed:@"RetailTableCell2" owner:self options:nil].lastObject;
        }
        
        if ([self.isCanDeal isEqualToString:@"0"]) {
            [detailItem.btnDel setHidden:YES];
            [detailItem.btnDel setEnabled:NO];
        }
        
        if (self.dataList.count > 0 && indexPath.row < self.dataList.count) {
            id<INameValueItem> item=[self.dataList objectAtIndex:indexPath.row];
            [detailItem initDelegate:self obj:item event:self.event];
            detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return detailItem;
    }
    
    abort();
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count == 0 ? 0 :self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> item=[self.dataList objectAtIndex:indexPath.row];
    [self.delegate showEditNVItemEvent:self.event withObj:item];
}

#pragma btnAdd ...
-(IBAction)btnAddClick:(id)sender
{
    [self.delegate showAddEvent:self.event];
}

#pragma del确认包装.
-(void) delObjEvent:(NSString*)event obj:(id) obj
{
    self.currObj=(id<INameValueItem>)obj;
    [UIHelper alert:self andDelegate:self andTitle:[NSString stringWithFormat:@"确认要删除[%@]吗？",[self.currObj obtainItemName]]];
}

-(void) showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    [self.delegate showEditNVItemEvent:self.event withObj:obj];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.delegate delObjEvent:self.event obj:self.currObj];
    }
}

-(void) visibal:(BOOL)show
{
    [self setLs_height:show?60:0];
    self.alpha=show?1:0;
}

@end
