//
//  LSDealRecordController.m
//  retailapp
//
//  Created by guozhi on 2017/3/24.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSDealRecordController.h"
#import "LSEditItemTitle.h"
#import "LSEditItemView.h"
#import "LSDealRecordVo.h"
@interface LSDealRecordController ()
/** <#注释#> */
@property (nonatomic, strong) UIScrollView *scrollView;
/** <#注释#> */
@property (nonatomic, strong) UIView *container;
/** 处理记录 */
@property (nonatomic, strong) NSArray *dealRecords;



@end

@implementation LSDealRecordController
- (instancetype)initWithDealRecords:(NSArray *)dealRecords {
    if (self = [super init]) {
        self.dealRecords = dealRecords;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle];
    [self configViews];
   
}

- (void)configTitle {
    [self configTitle:@"处理记录" leftPath:Head_ICON_BACK rightPath:nil];
}



- (void)configViews {
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, SCREEN_W, SCREEN_H - kNavH)];
    [self.view addSubview:self.scrollView];
    
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, self.scrollView.ls_height)];
    [self.scrollView addSubview:self.container];
    __weak typeof(self) wself = self;
    [self.dealRecords enumerateObjectsUsingBlock:^(LSDealRecordVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSEditItemTitle *title = [LSEditItemTitle editItemTitle];
        [wself.container addSubview:title];
        [title configTitle:obj.name];
        
        LSEditItemView *view = [LSEditItemView editItemView];
        [view initLabel:@"操作时间" withHit:nil];
        [view initData:obj.opTime];
        [wself.container addSubview:view];
        
        view = [LSEditItemView editItemView];
        [view initLabel:@"操作人" withHit:nil];
        [view initData:obj.opUser];
        [wself.container addSubview:view];
        
        view = [LSEditItemView editItemView];
        [view initLabel:@"操作类型" withHit:nil];
        [view initData:obj.opType];
        [wself.container addSubview:view];
        
    }];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

@end
