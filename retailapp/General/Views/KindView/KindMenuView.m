//
//  KindMenuView.m
//  retailapp
//
//  Created by hm on 15/7/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindMenuView.h"
#import "ViewFactory.h"
#import "UIImage+Resize.h"
#import "KindMenuCell.h"
#import "TreeNode.h"
#import "TreeNodeUtils.h"
#import "UIView+Sizes.h"
#import "UIHelper.h"
#import "ColorHelper.h"

@interface KindMenuView ()
// 分类list
@property (nonatomic, retain) NSMutableArray *kindList;

// 分类map
@property (nonatomic, retain) NSMutableDictionary *kindMap;

//
@property (nonatomic, retain) NSMutableArray *treeNodes;

//
@property (nonatomic, retain) NSMutableArray *endNodes;

@end

@implementation KindMenuView

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *pic=[UIImage imageNamed:@"ico_manage.png"];
    [self.managerBtn setImage:[pic transformWidth:22 height:22] forState:UIControlStateNormal];
    [self borderLine:self.managerBtn];
    [self.managerBtn setTitleColor:[ColorHelper getBlueColor] forState:UIControlStateNormal];
    self.managerBtn.layer.cornerRadius = 3;
}


-(void) borderLine:(UIView*)view
{
    CALayer *layer=[view layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
    [layer setCornerRadius:5.0]; //设置矩圆角半径
    UIColor* color=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    [layer setBorderColor:[color CGColor]];
}

- (void)initGird
{
    self.mainGrid.opaque = YES;
    UIView* view = [ViewFactory generateFooter:30];
    view.backgroundColor = [UIColor clearColor];
    [self.mainGrid setTableFooterView:view];
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


- (IBAction)bgBtnClick:(id)sender
{
    [self hideMoveOut];
}

- (IBAction)managerBtnClick:(id)sender
{
    [self hideMoveOut];
    [self.singleCheckDelegate closeSingleView:self.event];
   
}

-(void)initDelegate:(id<SingleCheckHandle>)delegate event:(int)event isShowManagerBtn:(BOOL)isShow
{
    self.singleCheckDelegate=delegate;
    self.event=event;
    _isShowManagerBtn = isShow;
    [self isShowManagerBtn:_isShowManagerBtn];
}

- (void) loadData:(NSMutableArray *)kindList nodes:(NSMutableArray *)nodes endNodes:(NSMutableArray *)endNodes
{
    self.kindList = kindList;
    self.endNodes = endNodes;
    [self showMoveIn];
    [self.mainGrid reloadData];
}

- (void)isShowManagerBtn:(BOOL)isShow{
    if (!isShow) {
        self.managerBtn.hidden = YES;
        self.managerBtn.enabled = NO;
    }else{
        self.managerBtn.hidden = NO;
        self.managerBtn.enabled = YES;
    }
}


#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.endNodes.count == 0 ? 0 :self.endNodes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* kindMenuCellId = @"KindMenuCell";
    KindMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:kindMenuCellId];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KindMenuCell" bundle:nil] forCellReuseIdentifier:kindMenuCellId];
        cell = [tableView dequeueReusableCellWithIdentifier:kindMenuCellId];
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell setNeedsDisplay];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    KindMenuCell* kindCell = (KindMenuCell*)cell;
    if (self.endNodes.count>0&&indexPath.row<self.endNodes.count) {
        TreeNode* item  = (TreeNode*)[self.endNodes objectAtIndex:indexPath.row];
        kindCell.lblName.text = [item obtainItemName];
        kindCell.lblParent.text = [TreeNodeUtils getParentName:item dic:self.kindMap isSelf:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row<self.endNodes.count) {
        TreeNode* item=(TreeNode*)[self.endNodes objectAtIndex: indexPath.row];
        if (!self.isAnimated) {
             [self hideMoveOut];
        }
        if (self.singleCheckDelegate&&[self.singleCheckDelegate respondsToSelector:@selector(singleCheck:item:)]) {
            [self.singleCheckDelegate singleCheck:0 item:item];
        }
    }
}


- (void)showMoveIn
{
    self.view.hidden = NO;
    self.bgView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(self.view.ls_width, 0, self.view.ls_width, self.view.ls_height);
        self.view.frame = CGRectMake(0, 0, self.view.ls_width, self.view.ls_height);
    } completion:^(BOOL finished) {
        self.bgView.hidden = NO;
    }];
}

- (void)hideMoveOut
{
    self.bgView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.ls_width, self.view.ls_height);
        self.view.frame = CGRectMake(self.view.ls_width, 0, self.view.ls_width, self.view.ls_height);
    } completion:^(BOOL finished) {
        self.view.hidden = YES;
    }];
}

@end
