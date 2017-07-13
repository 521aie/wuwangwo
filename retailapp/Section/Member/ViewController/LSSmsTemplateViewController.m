//
//  LSSmsTemplateViewController.m
//  retailapp
//
//  Created by guozhi on 16/9/7.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#define TAG_ITEM_TEXT 1
#define TAG_ITEM_MEMO 2
#define TAG_LST_TEMPLATE 3
#import "LSSmsTemplateViewController.h"
#import "NavigateTitle2.h"
#import "XHAnimalUtil.h"
#import "UIView+Sizes.h"
#import "AlertBox.h"
#import "SmsTemplateVo.h"
#import "MJExtension.h"
#import "ObjectUtil.h"
#import "EditItemList.h"
#import "OptionPickerBox.h"
#import "NameItemVO.h"
#import "ColorHelper.h"
#import "EditItemText.h"
#import "EditItemMemo.h"
#import "UIHelper.h"
#import "MemoInputView.h"
#import "UIHelper.h"
#import "EditItemView.h"
@interface LSSmsTemplateViewController ()<INavigateEvent, IEditItemListEvent, OptionPickerClient, IEditItemMemoEvent, MemoInputClient, UIAlertViewDelegate>
/**
 *  标题栏
 */
@property (nonatomic, strong) NavigateTitle2 *navigateTitle;
/**
 *  短信模板列表
 */
@property (nonatomic, strong) NSMutableArray *smsTemplateList;
/**
 *  短信魔板
 */
@property (nonatomic, strong) EditItemList *lstTemplate;
/**
 *  可滚动
 */
@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  短信模板名称列表
 */
@property (nonatomic, strong) NSMutableArray *smsTemplateNameList;

/**
 *  短信内容
 */
@property (nonatomic, strong) UITextView *textViewSms;
/**
 *  根据模板编辑
 */
@property (nonatomic, strong) EditItemView *vewSms;
@property (nonatomic, strong) UIView *viewItems;
/**
 *  提示文字
 */
@property (nonatomic, strong) UILabel *lblTip;
/**
 *  短信模板内容
 */

@property (nonatomic, assign) BOOL isChange;

/**
 *  当前操作的模板对象
 */
@property (nonatomic, strong) SmsTemplateVo *smsTemplateVo;
@end

@implementation LSSmsTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self initNotification];
    [self getSmsTemplateList];
    
}
#pragma mark - 初始化通知
- (void)initNotification {
    NSString *event = @"Notification_UI_SMS_TEMPLATE_VIEW_Change";
    [UIHelper initNotification:self.scrollView event:event];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:event object:nil];
}
#pragma mark - 页面里面的值改变时调用
- (void)dataChange:(NSNotification *)notification {
    self.isChange = [UIHelper currChange:self.scrollView] || [UIHelper currChange:self.viewItems];
}
#pragma mark - 网络请求
#pragma mark - 获得短信模板
- (void)getSmsTemplateList {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@(self.type) forKey:@"type"];//1:营销短信    3:生日提醒
    NSString *url = @"sms/v2/templateList";
    __weak typeof(self) wself = self;
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        NSMutableArray *smsTemplateList = json[@"smsTemplateListVos"];
        if ([ObjectUtil isNotNull:smsTemplateList]) {
            wself.smsTemplateList = [SmsTemplateVo mj_objectArrayWithKeyValuesArray:smsTemplateList];
            wself.smsTemplateNameList = [NSMutableArray array];
            if ([NSString isBlank:wself.smsCode]) {//如果上个页面选择了某一个模板进到选择模板页面要默认选中
                 wself.smsTemplateVo = wself.smsTemplateList[0];
            } else {
                for (SmsTemplateVo *smsTemplateVo in wself.smsTemplateList) {
                    if ([smsTemplateVo.code isEqualToString:wself.smsCode]) {
                        wself.smsTemplateVo = smsTemplateVo;
                        break;
                    }
                }
            }
            [self refreshUI:NO];
            NameItemVO *item = nil;
            for (SmsTemplateVo *smsTemplateVo in wself.smsTemplateList) {
                item = [[NameItemVO alloc] initWithVal:smsTemplateVo.title andId:smsTemplateVo.code];
                [wself.smsTemplateNameList addObject:item];
            }
            item = [[NameItemVO alloc] initWithVal:wself.smsTemplateVo.title andId:wself.smsTemplateVo.code];
            //短信模板赋值
            [wself.lstTemplate initData:[item obtainItemName] withVal:[item obtainItemId]];
        }
    } errorHandler:^(id json) {
        [AlertBox show:json];
    }];
}
#pragma mark - 选择短信模板后UI更改
- (void)refreshUI:(BOOL)isChange {
    //模板显示时前面加【二维火】发送后台时需要去掉只是为了展示
    if (![self.smsTemplateVo.content hasPrefix:@"【二维火】"]) {
         self.smsTemplateVo.content = [NSString stringWithFormat:@"【二维火】%@", self.smsTemplateVo.content];
    }
    __block NSString *templateContent = self.smsTemplateVo.content;
    templateContent = [templateContent stringByReplacingOccurrencesOfString:@"$" withString:@""];
     templateContent = [templateContent stringByReplacingOccurrencesOfString:@"{shopname}" withString:@"shopname"];
    [self.smsTemplateVo.fieldsMapList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
             templateContent = [templateContent stringByReplacingOccurrencesOfString:key withString:obj];
        }];
        
    }];
    NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor redColor]};
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:templateContent attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]}];
    NSMutableArray *array = [self regexStrings:[content string]];
    self.textViewSms.text = templateContent;
    for (int i = 0 ; i < array.count; i++) {
        [content addAttributes:dict range:NSRangeFromString((NSString *)array[i])];
        self.textViewSms.attributedText = content;
    }
    NSString *shortSms = nil;
    NSString *longSms = nil;
    if (self.smsTemplateVo.fieldsMapList.count == 2) {//最多有3个如果有2个一定是长模板 3个一个是长模板一个是短模板
        longSms = [self.smsTemplateVo.fieldsMapList[0] allValues][0];
    } else if (self.smsTemplateVo.fieldsMapList.count == 3) {
        shortSms = [self.smsTemplateVo.fieldsMapList[0] allValues][0];
        longSms = [self.smsTemplateVo.fieldsMapList[1] allValues][0];
    }
    [self.viewItems.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if ([NSString isNotBlank:shortSms]) {
        EditItemText *itemText = [[EditItemText alloc]initWithFrame:CGRectMake(0, 0, self.view.ls_width, 48)];
        [itemText initLabel:[NSString stringWithFormat:@"▪︎ %@", shortSms] withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
        itemText.tag = TAG_ITEM_TEXT;
        [itemText initMaxNum:20];
        if (isChange) {
            [itemText changeData:self.strText];
        } else {
            [itemText initData:self.strText];
        }
        
        [self.viewItems addSubview:itemText];
        [self limitShortText];
    }
    if ([NSString isNotBlank:longSms]) {
        EditItemMemo *itemMemo = [[EditItemMemo alloc] initWithFrame:CGRectMake(0, 0, self.view.ls_width, 48)];
        [itemMemo initLabel:[NSString stringWithFormat:@"▪︎ %@", longSms] isrequest:YES delegate:self];
        itemMemo.tag = TAG_ITEM_MEMO;
        if (isChange) {
            [itemMemo changeData:self.strMemo];
        } else {
            [itemMemo initData:self.strMemo];
        }
        
        [self.viewItems addSubview:itemMemo];
    }
    NSString *event = @"Notification_UI_SMS_TEMPLATE_VIEW_Change";
    [UIHelper initNotification:self.viewItems event:event];
    [UIHelper refreshUI:self.viewItems];
    [self setup];
}

- (NSMutableArray *)regexStrings:(NSString *)string{
    NSString *regex = @"\\{.*?\\}";
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
    // 对str字符串进行匹配
    NSArray *matches = [regular matchesInString:string
                                        options:0
                                          range:NSMakeRange(0, string.length)];
    NSMutableArray *array = [NSMutableArray array];
    // 遍历匹配后的每一条记录
    for (NSTextCheckingResult *match in matches) {
        NSRange range = [match range];
        NSString *rangeStr = NSStringFromRange(range);
        [array addObject:rangeStr];
    }
    return array;
}
- (void)getSelectInfo:(CallBackBlock)callBack {
    self.callBack = callBack;
}
#pragma mark 点击保存事件
- (void)save {
    EditItemText *itemText = (EditItemText *)[self.viewItems viewWithTag:TAG_ITEM_TEXT];
    if (itemText) {
        self.strText = [itemText getStrVal];
        if ([NSString isBlank:[itemText getStrVal]]) {
            [AlertBox show:[NSString stringWithFormat:@"请填写%@", [itemText.lblName.text substringFromIndex:3]]];
            return;
        }
        if (![NSString validateSmsContent:[itemText getStrVal]]) {
            [AlertBox show:[NSString stringWithFormat:@"%@不允许包含下面的特殊符号   []【】", itemText.lblName.text]];
            return;
        }
    }
    EditItemMemo *itemMemo = (EditItemMemo *)[self.viewItems viewWithTag:TAG_ITEM_MEMO];
    if (itemMemo) {
        self.strMemo = [itemMemo getStrVal];
        if ([NSString isBlank:[itemMemo getStrVal]]) {
            [AlertBox show:[NSString stringWithFormat:@"请填写%@", [itemMemo.lblName.text substringFromIndex:3]]];
            return;
        }
        
        // 不允许包含下面的特殊符号   []【】, . # / : - ，。！
        if (![NSString validateSmsContent:[itemMemo getStrVal]]) {
            [AlertBox show:[NSString stringWithFormat:@"%@不允许包含下面的特殊符号   []【】", itemMemo.lblName.text]];
            return;
        }
    }
    [self getSmsContext];
    if(self.templateContent.length > 134){
        [AlertBox show:@"您的短信字数过多无法发送，请修改!"];
        return ;
    }
    
    if (self.templateContent.length > 67) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的短信字数超过67字，将分成两条为顾客发送，同时扣除相应的短信条数。确定继续发送短信?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
        return;
    }
      self.callBack(self.templateContent, self.smsTemplateVo, self.strText, self.strMemo);
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];

    
}

#pragma mark - 获得短信内容
- (void)getSmsContext {
    EditItemText *itemText = (EditItemText *)[self.viewItems viewWithTag:TAG_ITEM_TEXT];
    EditItemMemo *itemMemo = (EditItemMemo *)[self.viewItems viewWithTag:TAG_ITEM_MEMO];
    NSString *match1 = itemText.txtVal.text;
    NSString *match2 = itemMemo.lblVal.text;
    NSString *key = nil;
    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    if (self.smsTemplateVo.fieldsMapList.count == 2) {//最多有3个如果有2个一定是长模板 3个一个是长模板一个是短模板
        NSDictionary *longDict = self.smsTemplateVo.fieldsMapList[0];
        key = longDict.allKeys[0];
        match2 = [NSString isNotBlank:match2] ? match2 : @"";
        [map setValue:match2 forKey:key];
        NSDictionary *shopDict = self.smsTemplateVo.fieldsMapList[1];
        key = shopDict.allKeys[0];
        [map setValue:shopDict[key] forKey:key];
    } else if (self.smsTemplateVo.fieldsMapList.count == 3) {
        NSDictionary *shortDict = self.smsTemplateVo.fieldsMapList[0];
        key = shortDict.allKeys[0];
        match1 = [NSString isNotBlank:match1] ? match1 : @"";
        [map setValue:match1 forKey:key];
        NSDictionary *longDict = self.smsTemplateVo.fieldsMapList[1];
        key = longDict.allKeys[0];
        match2 = [NSString isNotBlank:match2] ? match2 : @"";
        [map setValue:match2 forKey:key];
        NSDictionary *shopDict = self.smsTemplateVo.fieldsMapList[2];
        key = shopDict.allKeys[0];
        [map setValue:shopDict[key] forKey:key];
    }
    self.smsTemplateVo.fields = map;
    
    __block NSString *templateContent = self.smsTemplateVo.content;
    templateContent = [templateContent stringByReplacingOccurrencesOfString:@"$" withString:@""];
    templateContent = [templateContent stringByReplacingOccurrencesOfString:@"{" withString:@""];
    templateContent = [templateContent stringByReplacingOccurrencesOfString:@"}" withString:@""];
    templateContent = [templateContent stringByReplacingOccurrencesOfString:@"{shopname}" withString:@"shopname"];
    [map enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        templateContent = [templateContent stringByReplacingOccurrencesOfString:key withString:obj];
    }];
    self.templateContent = templateContent;
}
#pragma mark - delegate
#pragma mark INavigateEvent
- (void)onNavigateEvent:(Direct_Flag)event {
    if (event == DIRECT_LEFT) {
        if (self.isChange) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"内容有变更尚未保存，确定要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
                [self.navigationController popViewControllerAnimated:NO];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
            [self.navigationController popViewControllerAnimated:NO];
        }
    } else {
        [self save];
    }
    
}

#pragma IEditItemListEvent
- (void)onItemListClick:(EditItemList *)obj {
    EditItemText *itemText = (EditItemText *)[self.viewItems viewWithTag:TAG_ITEM_TEXT];
    if (itemText) {
        self.strText = [itemText getStrVal];
    }
    EditItemMemo *itemMemo = (EditItemMemo *)[self.viewItems viewWithTag:TAG_ITEM_MEMO];
    if (itemMemo) {
        self.strMemo = [itemMemo getStrVal];
    }
    if (obj == self.lstTemplate) {//卡类型
        [OptionPickerBox initData:self.smsTemplateNameList itemId:[obj getStrVal]];
        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
    }
}


- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    id<INameItem> item = (id<INameItem>)selectObj;
    if (eventType == TAG_LST_TEMPLATE) {
        [self.lstTemplate changeData:[item obtainItemName] withVal:[item obtainItemId]];
        //获得当前选中的模板对象
        for (SmsTemplateVo *smsTemplateVo in self.smsTemplateList) {
            if ([[item obtainItemId] isEqualToString:smsTemplateVo.code]) {
                self.smsTemplateVo = smsTemplateVo;
                [self refreshUI:YES];
                break;
            }
        }
    }
    return YES;
}

- (void)onItemMemoListClick:(EditItemMemo *)obj {
    //获得短信内容
    [self getSmsContext];
    int limit = 134 - (int)self.templateContent.length;
    EditItemMemo *itemMemo = (EditItemMemo *)[self.viewItems viewWithTag:TAG_ITEM_MEMO];
    if (itemMemo) {
        limit = limit + (int)itemMemo.lblVal.text.length;
    }
    MemoInputView *vc = [[MemoInputView alloc] init];
    [vc limitShow:0 delegate:self title:[itemMemo.lblName.text substringFromIndex:3] val:[obj getStrVal] limit:limit];
    [self.navigationController pushViewController:vc animated:NO];
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromTop];
}

- (void)finishInput:(int)event content:(NSString*)content {
    EditItemMemo *itemMemo = (EditItemMemo *)[self.viewItems viewWithTag:TAG_ITEM_MEMO];
    [itemMemo changeData:content];
    [UIHelper refreshUI:self.viewItems];
    [self limitShortText];
    [self setup];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        self.callBack(self.templateContent, self.smsTemplateVo, self.strText, self.strMemo);
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];

    }
}

#pragma mark 限制短动态文字
- (void)limitShortText {
    //计算第一个限制长度
    EditItemText *itemText = (EditItemText *)[self.viewItems viewWithTag:TAG_ITEM_TEXT];
    if (itemText) {
        //获得短信内容
        [self getSmsContext];
        int limit = 134 - (int)self.templateContent.length + (int)itemText.txtVal.text.length;
        limit = limit > 20 ? 20 : limit;
        if (limit < 20) {
            itemText.txtTip = @"营销短信最多不超过134字！";
            if (limit == 0) {
                limit = -1;
            }
        } else {
            itemText.txtTip = nil;
        }
        [itemText initMaxNum:limit];
    }
}

#pragma mark - setup
//布局方式
- (void)setup {
    self.navigateTitle.ls_top = 0;
    CGFloat y = 0;
    //短信模板
    self.lstTemplate.ls_top = 0;
    y = y + self.lstTemplate.ls_height;
    
    //短信模板预览
    self.textViewSms.ls_top = y;
    y = y + self.textViewSms.ls_height;
    
    //根据模板编辑
    y = y + 20;
    self.vewSms.ls_top = y;
    y = y + self.vewSms.ls_height;
    
    self.viewItems.ls_top = y;
    y = y + self.viewItems.ls_height;
    //提示文字
    self.lblTip.ls_top = y;
    y = y + self.lblTip.ls_height;
    CGFloat contentSizeH = (self.scrollView.ls_height > y ? self.scrollView.ls_height : y) + 44;
    self.scrollView.contentSize = CGSizeMake(0, contentSizeH);
}
#pragma mark - setters and getters
#pragma mark 标题栏
- (NavigateTitle2 *)navigateTitle {
    if (!_navigateTitle) {
        _navigateTitle = [NavigateTitle2 navigateTitle:self];
        [_navigateTitle initWithName:@"短信模板" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
        [self.view addSubview:_navigateTitle];
    }
    return _navigateTitle;
}

#pragma mark 短信模板
- (EditItemList *)lstTemplate {
    if (!_lstTemplate) {
        _lstTemplate = [EditItemList editItemList];
        [_lstTemplate initLabel:@"短信模板" withHit:nil delegate:self];
        _lstTemplate.tag = TAG_LST_TEMPLATE;
        _lstTemplate.line.hidden = YES;
        [self.scrollView addSubview:_lstTemplate];
    }
    return _lstTemplate;
}

#pragma mark 短信内容预览
- (UITextView *)textViewSms {
    if (!_textViewSms) {
        CGFloat margin = 10;
        CGFloat textViewSmsX = margin;
        CGFloat textViewSmsY = 0;
        CGFloat textViewSmsW = self.view.ls_width - 2*margin;
        CGFloat textViewSmsH = 150;
        _textViewSms = [[UITextView alloc] initWithFrame:CGRectMake(textViewSmsX, textViewSmsY, textViewSmsW, textViewSmsH)];
        _textViewSms.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        _textViewSms.textColor = [UIColor blackColor];
        _textViewSms.font = [UIFont systemFontOfSize:15];
        _textViewSms.editable = NO;
        _textViewSms.layer.cornerRadius = 5.0;
        [self.scrollView addSubview:_textViewSms];
    }
    return _textViewSms;
}

#pragma mark 根据模板编辑标签
- (EditItemView *)vewSms {
    if (!_vewSms) {
        _vewSms = [EditItemView editItemView];
        [_vewSms initLabel:@"根据模板编辑" withHit:nil];
        [self.scrollView addSubview:_vewSms];
        CGFloat margin = 10;
        CGFloat viewLineX = margin;
        CGFloat viewLineY = 0;
        CGFloat viewLineW = _vewSms.ls_width - 2*margin;
        CGFloat viewLineH = 1;
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(viewLineX, viewLineY, viewLineW, viewLineH)];
        viewLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [_vewSms addSubview:viewLine];
    }
    return _vewSms;
}
#pragma mark 滚动区域
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat scrollViewX = 0;
        CGFloat scrollViewY = self.navigateTitle.ls_height;
        CGFloat scrollViewW = self.view.ls_width;
        CGFloat scrollViewH = self.view.ls_height - self.navigateTitle.ls_height;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH)];
        _scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}
- (UIView *)viewItems {
    if (!_viewItems) {
        _viewItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, 100)];
        [self.scrollView addSubview:_viewItems];
    }
    return _viewItems;
}

#pragma mark 提示文字
- (UILabel *)lblTip {
    if (!_lblTip) {
        CGFloat margin = 10;
        CGFloat lblTipX = margin;
        CGFloat lblTipY = 0;
        CGFloat lblTipW = self.scrollView.ls_width - 2*lblTipX;
        CGFloat lblTipH = 48;
        _lblTip = [[UILabel alloc] initWithFrame:CGRectMake(lblTipX, lblTipY, lblTipW, lblTipH)];
        _lblTip.textColor = [ColorHelper getTipColor6];
        _lblTip.font = [UIFont systemFontOfSize:12];
        _lblTip.numberOfLines = 0;
        _lblTip.text = @"提示：超过67字将分成两条短信发送，营销短信最多不超过134字";
        [self.scrollView addSubview:_lblTip];
    }
    return _lblTip;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
