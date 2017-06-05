//
//  LSRightSelectPanel.m
//  retailapp
//
//  Created by taihangju on 16/10/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRightSelectPanel.h"
#import "KindMenuCell.h"

#define kMainGridWidth 130.0
#define kTitleLabelHeight 40.0
#define kButtonWidth  38.0
#define kButtonHeight 67.0

static NSString *kindMenuCellId = @"KindMenuCell";
@interface LSRightSelectPanel()<UITableViewDataSource ,UITableViewDelegate>

@property (nonatomic ,assign) id<LSRightSelectPanelDelegate> delegate;/*<<#说明#>>*/
@property (nonatomic ,strong) UIButton *cateButton;/*<>*/
@property (nonatomic ,strong) UILabel *titleLabel;/*<标题>*/
@property (nonatomic ,strong) UIView *wrapperView;/*<右侧wrapper View>*/
@property (nonatomic ,strong) UITableView *tableView;/*<>*/
@property (nonatomic ,strong) NSArray *dataArray;/*<数据源>*/
@property (nonatomic ,strong) id selectObj;/*<选择cell对应的obj>*/
@end

@implementation LSRightSelectPanel

+ (instancetype)rightSelectPanel:(NSString *)title delegate:(id<LSRightSelectPanelDelegate>)delegate {
    
    LSRightSelectPanel *panel = [[LSRightSelectPanel alloc] initWithFrame:[UIScreen mainScreen].bounds];
    panel.delegate = delegate;
    // wrapper
    UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(panel.bounds)-kMainGridWidth, 0, kMainGridWidth, CGRectGetHeight(panel.bounds))];
    wrapper.backgroundColor = [UIColor whiteColor];
    [panel addSubview:wrapper];
    panel.wrapperView = wrapper;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:panel action:@selector(hiddenPanel:)];
    [panel addGestureRecognizer:tap];
    
    // 标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainGridWidth, kTitleLabelHeight)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = title;
    [wrapper addSubview:label];
    panel.titleLabel = label;
  
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kTitleLabelHeight, kMainGridWidth, 1.0)];
    line.backgroundColor = [UIColor lightGrayColor];
    [wrapper addSubview:line];
    
    // 列表
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTitleLabelHeight + 1, kMainGridWidth, CGRectGetHeight(wrapper.bounds)-kTitleLabelHeight - 1)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [tableView registerNib:[UINib nibWithNibName:@"KindMenuCell" bundle:nil] forCellReuseIdentifier:kindMenuCellId];
    tableView.rowHeight = 44.0;
    tableView.delegate = panel;
    tableView.dataSource = panel;
    [wrapper addSubview:tableView];
    panel.tableView = tableView;
    
    // 分类button
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(-kButtonWidth+1.0, (CGRectGetHeight(panel.bounds)-kButtonHeight)/2, kButtonWidth, kButtonHeight)];
    [button addTarget:panel action:@selector(changeSelfFrame) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"ico_cardTypeNormal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ico_cardTypeHighLight"] forState:UIControlStateHighlighted];
//    [button setImage:[UIImage imageNamed:@"Ico_Kind_Menu"] forState:0];
//    [button setTitle:@"卡类型" forState:0];
//    button.titleLabel.font = [UIFont systemFontOfSize:10.f];
//    [button setTitleColor:[UIColor blackColor] forState:0];
    [wrapper addSubview:button];
//    button.imageEdgeInsets = UIEdgeInsetsMake(3, 8, 10, -12);
//    button.titleEdgeInsets = UIEdgeInsetsMake(14, -15, -13, 0);
    panel.cateButton = button;
    
    
    return panel;
}

- (void)addToView:(UIView *)view {
    
    if (view) {
        
        self.frame = CGRectMake(kMainGridWidth, 0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
        self.backgroundColor = [UIColor clearColor];
        [view addSubview:self];
    }
}

// 加载显示数据
- (void)loadDataList:(NSArray *)dataArray {
    
    self.dataArray = dataArray;
    if (dataArray) {
        
        [self.tableView reloadData];
    }
}

// 更改frame， 显示或者隐藏
- (void)changeSelfFrame {
    
    if (self.frame.origin.x > 0) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.transform = CGAffineTransformMakeTranslation(-kMainGridWidth, 0);
        } completion:^(BOOL finished) {
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        }];
    }
    else {
        
        self.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (self.selectObj && [self.delegate respondsToSelector:@selector(rightSelectPanel:select:)]) {
                [self.delegate rightSelectPanel:self select:self.selectObj];
                self.selectObj = nil;
            }
        }];
    }
}

// 点击mask view 隐藏自身
- (void)hiddenPanel:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self.wrapperView];
    if (point.x < 0) {
         [self changeSelfFrame];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGRect rect = [self convertRect:self.cateButton.frame fromView:self.wrapperView];
    if (CGRectContainsPoint(rect, point)) {
        
        return self.cateButton;
    }
    else if (self.frame.origin.x == 0) {
        
        CGRect rect = [self convertRect:self.tableView.frame fromView:self.wrapperView];
        BOOL isOk = CGRectContainsPoint(rect, point);
        if (isOk) {
            
            CGPoint newPoint = [self convertPoint:point toView:self.tableView];
            NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:newPoint];
            if (indexPath) {
                [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            }
        }
        return self;
    }
    return nil;
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KindMenuCell *cell = (KindMenuCell *)[tableView dequeueReusableCellWithIdentifier:kindMenuCellId];
    cell.lblName.text = [[self.dataArray objectAtIndex:indexPath.row] obtainItemName];
    cell.lblName.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.line.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0.5, 0)];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0.5, 0)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectObj = self.dataArray[indexPath.row];
    [self changeSelfFrame];
}


@end
