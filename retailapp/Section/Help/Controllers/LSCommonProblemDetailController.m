//
//  LSCommonProblemDetailController.m
//  retailapp
//
//  Created by guozhi on 2017/3/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#define kTagDescriptionIsNotClear 0 //描述不清晰
#define kTagMethodIsNotFeasible 1 //方法不可行
#define kTagFunctionNotAvailable 2 //功能不可用
#define kTagResolved 3 //已解决
#define kTagUnresolved 4 //未解决


#import "LSCommonProblemDetailController.h"
#import "LSCommonProblemListVo.h"
#import "TDFCustomerServiceButtonController.h"

@interface LSCommonProblemDetailController ()
/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 白色面板 */
@property (nonatomic, strong) UIView *viewBg;
/** 原因View */
@property (nonatomic, strong) UIView *reasonBg;
/** 原因按钮 */
@property (nonatomic, strong) NSMutableArray *reasonsList;
/** 解决按钮 */
@property (nonatomic, strong) NSMutableArray *resolvedList;
/** <#注释#> */
@property (nonatomic, copy) NSString *typeId;
/** <#注释#> */
@property (nonatomic, strong) LSCommonProblemListVo *obj;
/**
 *  云客服
 */
@property (nonatomic, strong) TDFCustomerServiceButtonController *customerServiceController;


@end

@implementation LSCommonProblemDetailController

- (instancetype)initWithTypeId:(NSString *)typeId{
    if (self = [super init]) {
        self.typeId = typeId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTitle:@"常见问题" leftPath:Head_ICON_BACK rightPath:nil];
    [self configViews];
    [self loadData];
}
- (void)configViews {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavH, self.view.ls_width, self.view.ls_height - kNavH)];
    self.scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.scrollView];
    [self.customerServiceController addCustomerServiceButtonToView:self.view];
}

- (TDFCustomerServiceButtonController *)customerServiceController {
    if (!_customerServiceController) {
        _customerServiceController = [[TDFCustomerServiceButtonController alloc] init];
    }
    return _customerServiceController;
}

- (void)loadData {
    NSString *url = @"problem/v1/problem_item";
    NSDictionary *param = @{@"id" : self.typeId};
    __weak typeof(self) wself = self;
    [BaseService crossDomanRequestWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.obj = [LSCommonProblemListVo ls_objectWithKeyValues:json[@"data"]];
        [wself setupSubViews];
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
}

- (void)setupSubViews {
    __weak typeof(self) wself = self;
    
    //白色背景
    self.viewBg = [[UIView alloc] init];
    self.viewBg.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    self.viewBg.layer.cornerRadius = 4;
    [self.scrollView addSubview:self.viewBg];
    [self.viewBg makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(wself.scrollView).offset(10);
        make.bottom.equalTo(wself.scrollView).offset(-44);
        make.right.equalTo(wself.scrollView).offset(-10);
        make.width.equalTo(wself.scrollView).offset(-20);
    }];
    
    //问号图片
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"ico_wenhao"];
    [self.viewBg addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.viewBg).offset(10);
        make.top.equalTo(wself.viewBg).offset(12);
        make.size.equalTo(22);
    }];
    //标题
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.font = [UIFont boldSystemFontOfSize:17];
    lblTitle.textColor = [ColorHelper getTipColor3];
    lblTitle.numberOfLines = 0;
    [self.viewBg addSubview:lblTitle];
    lblTitle.text = self.obj.titleName;
    [lblTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.right).offset(5);
        make.right.equalTo(wself.viewBg.right).offset(-10);
        make.top.equalTo(wself.viewBg).offset(14);
    }];
    
    //分割线
    UIView *lineTop = [[UIView alloc] init];
    lineTop.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.viewBg addSubview:lineTop];
    [lineTop makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.viewBg).offset(10);
        make.right.equalTo(wself.viewBg).offset(-10);
        make.top.equalTo(lblTitle.bottom).offset(14);
        make.height.equalTo(1);
    }];
    
    //内容
    UILabel *lblContext = [[UILabel alloc] init];
    lblContext.font = [UIFont systemFontOfSize:15];
    lblContext.textColor = [ColorHelper getTipColor9];
    lblContext.numberOfLines = 0;
    [self.viewBg addSubview:lblContext];
    NSString *htmlString = self.obj.solution;
    NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    lblContext.attributedText = attr;
    [lblContext makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.viewBg).offset(10);
        make.right.equalTo(wself.viewBg).offset(-10);
        make.top.equalTo(lineTop.bottom).offset(15);
    }];
    
    //分割线
    UIView *lineBottom = [[UIView alloc] init];
    lineBottom.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.viewBg addSubview:lineBottom];
    [lineBottom makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.viewBg).offset(10);
        make.right.equalTo(wself.viewBg).offset(-10);
        make.top.equalTo(lblContext.bottom).offset(20);
        make.height.equalTo(1);
    }];
    //按钮背景
    UIView *btnBg = [[UIView alloc] init];
    [self.viewBg addSubview:btnBg];
    [btnBg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.viewBg);
        make.top.equalTo(lineBottom.bottom);
        make.height.equalTo(56);
    }];
    
    //已解决 未解决按钮 按钮的size(90,28) 2个按钮的间距 70
    [self.view layoutIfNeeded];
    self.resolvedList = [NSMutableArray array];
    CGFloat w = 90;
    CGFloat h = 28;
    CGFloat margin = (self.viewBg.ls_width - 70 - w * 2)/2;
    UIButton *btnResolved = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnResolved setImage:[UIImage imageNamed:@"ico_resolved_normal"] forState:UIControlStateNormal];
    [btnResolved setImage:[UIImage imageNamed:@"ico_resolved_select"] forState:UIControlStateSelected];
    btnResolved.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnResolved setTitleColor:[ColorHelper getTipColor9] forState:UIControlStateNormal];
    btnResolved.tag = kTagResolved;
    [btnResolved addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnResolved setTitle:@"已解决" forState:UIControlStateNormal];
    [btnResolved setTitleColor:[ColorHelper getRedColor] forState:UIControlStateSelected];
    btnResolved.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    btnResolved.layer.cornerRadius = 14;
    btnResolved.layer.borderColor = [ColorHelper getTipColor9].CGColor;
    btnResolved.layer.borderWidth = 1;
    [btnBg addSubview:btnResolved];
    [self.resolvedList addObject:btnResolved];
    
    UIButton *btnUnresolved = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnUnresolved setImage:[UIImage imageNamed:@"ico_unresolved_normal"] forState:UIControlStateNormal];
    [btnUnresolved setImage:[UIImage imageNamed:@"ico_unresolved_select"] forState:UIControlStateSelected];
    btnUnresolved.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnUnresolved setTitleColor:[ColorHelper getTipColor9] forState:UIControlStateNormal];
    btnUnresolved.tag = kTagUnresolved;
    [btnUnresolved addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnUnresolved setTitle:@"未解决" forState:UIControlStateNormal];
    [btnUnresolved setTitleColor:[ColorHelper getRedColor] forState:UIControlStateSelected];
    btnUnresolved.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    btnUnresolved.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
    btnUnresolved.layer.cornerRadius = 14;
    btnUnresolved.layer.borderColor = [ColorHelper getTipColor9].CGColor;
    btnUnresolved.layer.borderWidth = 1;
    
    [btnBg addSubview:btnUnresolved];
    [self.resolvedList addObject:btnUnresolved];
    
    [btnResolved makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnBg).offset(margin);
        make.size.equalTo(CGSizeMake(w, h));
        make.centerY.equalTo(btnBg);
        make.right.equalTo(btnUnresolved.left).offset(-70);
    }];
    
    [btnUnresolved makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnBg).offset(-margin);
        make.size.equalTo(CGSizeMake(w, h));
        make.centerY.equalTo(btnBg);
    }];
    
    
    //原因背景
    UIView *reasonBg = [[UIView alloc] init];
    [self.viewBg addSubview:reasonBg];
    [reasonBg makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.viewBg);
        make.top.equalTo(btnBg.bottom);
        make.height.equalTo(100);
    }];
    self.reasonBg = reasonBg;
    //未解决的原因
    UILabel *lblReason = [[UILabel alloc] init];
    lblReason.textAlignment = NSTextAlignmentCenter;
    lblReason.font = [UIFont systemFontOfSize:15];
    lblReason.textColor = [ColorHelper getTipColor9];
    lblReason.text = @"未解决的原因";
    [reasonBg addSubview:lblReason];
    [lblReason makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(reasonBg);
        make.centerX.equalTo(reasonBg);
    }];
    //左边横线
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [reasonBg addSubview:leftLine];
    [leftLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(reasonBg).offset(30);
        make.right.equalTo(lblReason.left).offset(-10);
        make.centerY.equalTo(lblReason);
        make.height.equalTo(1);
    }];
    //右边横线
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [reasonBg addSubview:rightLine];
    [rightLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(reasonBg).offset(-30);
        make.left.equalTo(lblReason.right).offset(10);
        make.centerY.equalTo(lblReason);
        make.height.equalTo(1);
    }];
    [self.view layoutIfNeeded];
    //原因按钮
    NSArray *reasons = @[@"描述不清晰", @"方法不可行", @"功能不好用"];
    //按钮距离边框距离
    __block CGFloat marginBtnSup = 10;
    //按钮之间的间距
    __block CGFloat marginBtnBtn = 10;
    //按钮的高度
    __block CGFloat btnH = 30;
    //按钮的宽度
    __block CGFloat btnW = (reasonBg.ls_width - 2 * marginBtnSup - marginBtnBtn * (reasons.count - 1))/reasons.count;
    self.reasonsList = [NSMutableArray array];
    [reasons enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnX = marginBtnSup + (btnW + marginBtnBtn) *idx;
        CGFloat btnY = 40;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        NSInteger tag = 0;
        if (idx == 0) {
            tag = kTagDescriptionIsNotClear;
        } else if (idx == 1) {
            tag = kTagMethodIsNotFeasible;
        } else if (idx == 2) {
            tag = kTagFunctionNotAvailable;
        }
        btn.tag = tag;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[ColorHelper getTipColor9] forState:UIControlStateNormal];
        [btn setTitleColor:[ColorHelper getRedColor] forState:UIControlStateSelected];
        btn.layer.cornerRadius = 4;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [ColorHelper getTipColor9].CGColor;
        [reasonBg addSubview:btn];
        [self.reasonsList addObject:btn];
        
    }];
    [self showReasonView:NO];
    [self.viewBg makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(reasonBg);
    }];

}

- (void)btnClick:(UIButton *)btn {
    if ([self.resolvedList containsObject:btn]) {//已解决未解决按钮只能选择一个
        
        //判断已解决未解决按钮有没有被选中 如果有一个被选中则不能继续选中
        [self.resolvedList enumerateObjectsUsingBlock:^(UIButton *resolvedBtn, NSUInteger idx, BOOL * _Nonnull stop) {
            resolvedBtn.selected = NO;
            resolvedBtn.layer.borderColor = [ColorHelper getTipColor9].CGColor;
            resolvedBtn.userInteractionEnabled = NO;
        }];
    }
    if ([self.reasonsList containsObject:btn]) {//原因按钮只能选择一个
        [self.reasonsList enumerateObjectsUsingBlock:^(UIButton *reasonBtn, NSUInteger idx, BOOL * _Nonnull stop) {
            reasonBtn.selected = NO;
            reasonBtn.layer.borderColor = [ColorHelper getTipColor9].CGColor;
            reasonBtn.userInteractionEnabled = NO;
        }];
    }
    btn.selected = YES;
    btn.layer.borderColor = [ColorHelper getRedColor].CGColor;
    int status = 0;
    if (btn.tag == kTagResolved) {//已解决按钮
        status = 1;
        [self showReasonView:NO];
    } else if (btn.tag == kTagUnresolved) {//未解决按钮
        status = 2;
        [self showReasonView:YES];
    } else if (btn.tag == kTagDescriptionIsNotClear) {//描述不清晰
        status = 3;
    } else if (btn.tag == kTagMethodIsNotFeasible) {//方法不可行
        status = 4;
    } else if (btn.tag == kTagFunctionNotAvailable) {//功能不可用
        status = 5;
    }
    NSString *url = @"problem/v1/answer_problem";
    NSDictionary *param = @{@"problemStatus" : @(status),
                            @"id" : self.typeId};
    [BaseService crossDomanRequestWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        
    } errorHandler:^(id json) {
        [LSAlertHelper showAlert:json];
    }];
    
    
    
}

- (void)showReasonView:(BOOL)show {
    self.reasonBg.hidden = !show;
    [self.reasonBg updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(show ? 100 : 0);
    }];
}






@end
