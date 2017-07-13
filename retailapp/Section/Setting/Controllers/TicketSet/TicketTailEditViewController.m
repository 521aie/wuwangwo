//
//  TicketTailEditViewController.m
//  retailapp
//
//  Created by taihangju on 16/8/31.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TicketTailEditViewController.h"
#import "UIView+Sizes.h"
#import "LSEditItemList.h"
#import "NameItemVO.h"
#import "LSEditItemText.h"
#import "OptionPickerBox.h"
#import "AlertBox.h"
#import "ServiceFactory.h"

@interface TicketTailEditViewController ()<IEditItemListEvent  ,OptionPickerClient>

@property (nonatomic ,strong) LSEditItemText *tailEditItem;/*<尾注 编辑>*/
@property (nonatomic ,strong) LSEditItemList *tailTypeItem;/*<尾注 类型选择>*/
@property (nonatomic ,copy) NewTailBlock tailBlock;/*<block>*/
@property (nonatomic ,strong) TailModel *tailModel;/*<尾注对象>*/
@property (nonatomic ,strong) NSDictionary *shopInfoDic;/*<店家地址、联系电话、微信等>*/
@end

@implementation TicketTailEditViewController

- (instancetype)init:(TailModel *)model callBack:(NewTailBlock)tailBlock {
    
    self = [super init];
    if (self) {
       
        self.tailModel = model;
        self.tailBlock = tailBlock;
        self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getShopInfo];
    [self configSubViews];
}



- (void)configSubViews {
    
    NSString *text = nil;
    // 设置 导航栏
    
    if (self.tailModel.tailType == TailAdd) {
        [self configTitle:@"添加" leftPath:Head_ICON_CANCEL rightPath:Head_ICON_CONFIRM];
    }else {
        [self configTitle:self.tailModel.rawTailString leftPath:Head_ICON_BACK  rightPath:nil];
        
    }
  

    // 尾注类型选择
    CGFloat topY = kNavH;
    LSEditItemList *tailType = [LSEditItemList editItemList];
    tailType.ls_top = topY;
    [tailType initLabel:@"尾注" withHit:nil delegate:self];
    [tailType initData:@"自定义" withVal:@"1"];
    [self.view addSubview:tailType];
    topY += tailType.ls_height;
    self.tailTypeItem = tailType;
 
    // 尾注内容 编辑
    text = self.tailModel.tailType == TailAdd ? @"" : self.tailModel.rawTailString;
    LSEditItemText *editItem = [LSEditItemText editItemText];
    [editItem initLabel:nil withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [editItem initMaxNum:50];
    editItem.delegate = self;
    editItem.txtVal.textAlignment = NSTextAlignmentLeft;
    CGFloat margin = editItem.lblName.ls_left;
    [editItem.txtVal updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(editItem.left).offset(10);
    }];
    editItem.ls_top = topY;
    [editItem initData:text];
    [self.view addSubview:editItem];
    self.tailEditItem = editItem;
    topY += editItem.ls_height;
    
    // 编辑模式， 删除按钮
    if (self.tailModel.tailType == TailEdit) {
         UIButton *delBtn = [LSViewFactor addRedButton:self.view title:@"删除" y:topY];
        [delBtn addTarget:self action:@selector(deleteCurrentTail) forControlEvents:UIControlEventTouchUpInside];
        topY = delBtn.superview.ls_bottom;
    }
    
    // 提示文案
    UILabel *notice = [[UILabel alloc] initWithFrame:CGRectMake(10, topY, SCREEN_W - 20, 100)];
    notice.font = [UIFont systemFontOfSize:13.0];
    notice.textColor = [ColorHelper getTipColor6];
    notice.numberOfLines = 0;
    [self.view addSubview:notice];
    notice.text = @"提示:\n1.尾注内容可以选择店家地址、联系电话、微信，选择后仍可以进行修改。\n2.店家地址、联系电话、微信是店家信息中填写的内容，请在设置尾注前先完善店家信息。";
}


// 删除当前尾注内容
- (void)deleteCurrentTail {
    
    [AlertBox showBox:[NSString stringWithFormat:@"确认删除[%@]吗?" ,self.tailModel.rawTailString] client:self];
}

// 确认删除 指定尾注内容
#pragma mark - AlertBoxClient
- (void)confirm {
    
    self.tailModel.tailType = TailDel;
    if (self.tailBlock) {
        self.tailBlock(self.tailModel);
    }
    [self popToLatestViewController:kCATransitionFromLeft];
}


- (void)tryChageNavigationStatus {
    
    if (self.tailTypeItem.baseChangeStatus || self.tailEditItem.baseChangeStatus) {
        
        [self editTitle:YES act:ACTION_CONSTANTS_EDIT];
    }else {
        
        [self editTitle:NO act:ACTION_CONSTANTS_ADD];
    }
    [self configNavigationBar:LSNavigationBarButtonDirectRight title:@"确认" filePath:Head_ICON_OK];
}

#pragma mark - 网络

- (void)getShopInfo {
    
    [[ServiceFactory shareInstance].settingService getShopInfo:self.tailModel.shopId completeHandler:^(id json) {
        
        self.shopInfoDic = json[@"receiptShopVo"];
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}

#pragma mark - 协议方法

// INavigateEvent
- (void)onNavigateEvent:(LSNavigationBarButtonDirect)event {
    
    if (event == LSNavigationBarButtonDirectRight)
    {
        
        if (self.tailEditItem.txtVal.text.length == 0) {
            [AlertBox show:@"尾注内容不能为空，请输入！"];
            return;
        }
        
        if ([self.tailEditItem.txtVal.text containsString:@"$%"]) {
            
            [AlertBox show:@"尾注内容不能输入\"$%\"字符"];
            return;
        }
        
        self.tailModel.editTailString = self.tailEditItem.txtVal.text;
        
//        if ([self.currentTailArray containsObject:self.tailModel.editTailString]) {
//            [AlertBox show:@"已存在相同的尾注了哟！"];
//            return;
//        }
        
        if (self.tailBlock) {
            self.tailBlock(self.tailModel);
        }
    }
    [self popToLatestViewController:kCATransitionFromLeft];
}

// IEditItemDynamicEvent
// 结束编辑时，回调
- (void)editItemTextEndEditing:(LSEditItemText *)editItem currentVal:(NSString *)val {
    if ([editItem  isEqual:self.tailEditItem]) {
        
        [self tryChageNavigationStatus];
    }
}


// OptionPickerClient
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    
    NameItemVO *vo = (NameItemVO *)selectObj;
    NSInteger itemId = vo.itemId.integerValue;
    if (itemId == 1)
    {
        // 自定义
        [self.tailEditItem changeData:@""];
    }
    else if (itemId == 2)
    {
        // 店家地址
        NSString *rawStr = [ObjectUtil getStringValue:self.shopInfoDic key:@"shopAddress"];
        NSString *address = [NSString stringWithFormat:@"地址: %@" ,(rawStr ? : @"")];
        [self.tailEditItem changeData:address];
    }
    else if (itemId == 3)
    {
       // 联系电话
        NSString *rawStr = [ObjectUtil getStringValue:self.shopInfoDic key:@"shopTelephone"];
        NSString *phone = [NSString stringWithFormat:@"服务热线: %@" ,(rawStr ? : @"")];
        [self.tailEditItem changeData:phone];
    }
    else if (itemId == 4)
    {
        // 微信
        NSString *rawStr = [ObjectUtil getStringValue:self.shopInfoDic key:@"shopWeiXin"];
        NSString *weChat = [NSString stringWithFormat:@"微信: %@" ,(rawStr ? : @"")];
        [self.tailEditItem changeData:weChat];
    }
    
    [self.tailTypeItem changeData:[vo itemName] withVal:vo.itemId];
    [self tryChageNavigationStatus];
    return YES;
}

// IEditItemListEvent
- (void)onItemListClick:(LSEditItemList *)obj {
    
    NSArray *datas = @[[[NameItemVO alloc] initWithVal:@"自定义" andId:@"1"],
                       [[NameItemVO alloc] initWithVal:@"店家地址" andId:@"2"],
                       [[NameItemVO alloc] initWithVal:@"联系电话" andId:@"3"],
                       [[NameItemVO alloc] initWithVal:@"微信" andId:@"4"]];
    [OptionPickerBox initData:datas itemId:[obj getStrVal]];
    [OptionPickerBox show:@"尾注打印位置" client:self event:11];
}

@end

@implementation TailModel

- (instancetype)init:(NSString *)tailStr index:(NSInteger)index type:(TailType)type shopId:(NSString *)shopId {
    
    self = [super init];
    if (self) {
        
        self.tailType = type;
        self.index = index;
        self.shopId = shopId;
        self.rawTailString = tailStr;
    }
    return self;
}
@end
