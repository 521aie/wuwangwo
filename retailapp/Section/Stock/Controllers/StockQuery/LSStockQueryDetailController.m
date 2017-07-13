//
//  LSStockQueryDetailController.m
//  retailapp
//
//  Created by guozhi on 2017/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSStockQueryDetailController.h"
#import "ServiceFactory.h"
#import "AlertBox.h"
#import "UIView+Sizes.h"
#import "XHAnimalUtil.h"
#import "StyleItem.h"
#import "SkcStyleVo.h"
#import "SkcListVo.h"
#import "SizeListVo.h"
#import "LSStyleInfoView.h"
@interface LSStockQueryDetailController ()
/**款式vo*/
@property (nonatomic, strong) SkcStyleVo *skcStyleVo;
/**款色列表*/
@property (nonatomic, strong) NSArray *skcList;
/**尺码名称列表*/
@property (nonatomic, strong) NSArray *sizeNameList;
/**款式尺码列表*/
@property (nonatomic, strong) NSArray *skcSizeList;
@property (nonatomic, strong) UIScrollView *scrollView;
/** 是否显示成本价 */
@property (nonatomic, assign) BOOL isShowCostPrice;
@end

@implementation LSStockQueryDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //有权限显示成本价 没有权限 商超显示零售价 服鞋显示吊牌价
    self.isShowCostPrice = ![[Platform Instance] lockAct:ACTION_COST_PRICE_SEARCH];
    [self configViews];
    [self configConstraints];
    [self loadData];
}
- (void)configViews {
    //标题
    [self configTitle:@"商品详情" leftPath:Head_ICON_BACK rightPath:nil];
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
}

- (void)configConstraints {
    //配置约束
    __weak typeof(self) wself = self;
    [wself.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.view);
        make.top.equalTo(wself.view.top).offset(kNavH);
        make.bottom.equalTo(wself.view.bottom);
    }];
}



#pragma mark - 加载详情数据
- (void)loadData {
    __weak typeof(self) wself = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:2];
    [param setValue:self.shopId forKey:@"shopId"];
    [param setValue:self.styleId forKey:@"styleId"];
    NSString *url = @"stockInfo/styleStockDetail";
    [BaseService getRemoteLSDataWithUrl:url param:param withMessage:nil show:YES CompletionHandler:^(id json) {
        wself.skcStyleVo = [SkcStyleVo converToVo:[json objectForKey:@"skcGoodsStyleVo"]];
        wself.skcList = wself.skcStyleVo.skcList;
        wself.sizeNameList = wself.skcStyleVo.sizeNameList;
        [wself layoutScrollView];
    } errorHandler:^(id json) {
         [AlertBox show:json];
    }];
}

#pragma mark - 绘制页面视图
- (void)layoutScrollView {
    
    UIView *detailView = [[UIView alloc] init];
    CGFloat height = 0;
    CGFloat width = self.scrollView.ls_width;
    //款式信息
    LSStyleInfoView *view = [LSStyleInfoView styleInfoView];
    UIView *styleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.ls_width, 88)];
    [styleView addSubview:view];
    styleView.backgroundColor = [UIColor whiteColor];
    NSString *goodsName = self.skcStyleVo.styleName;
    NSString *goodsCode =  [NSString stringWithFormat:@"款号：%@",self.skcStyleVo.styleCode?:@""];
    NSString *filePath = self.skcStyleVo.filePath;
    [view setStyleInfo:filePath goodsName:goodsName styleCode:goodsCode upDownStatus:0 goodsPrice:nil showPrice:NO];
    styleView.ls_height = view.ls_height;
    
    [detailView addSubview:styleView];
    height = height + styleView.ls_height + 15;
    CGFloat h = 44;//每一行的高度
    CGFloat sizeH = 64;//尺码行的高度
    CGFloat leftW = 75; //左边一列的宽度
    
    UIColor *bgColor = [UIColor whiteColor];
    
    if (self.skcList.count <= 3) {
        //款色数小于等于3，显示一个列表
        CGFloat w = (width - leftW)/ self.skcList.count;
        NSInteger row = self.sizeNameList.count + 3;
        UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 3 * h + self.sizeNameList.count * sizeH)];
        goodsView.backgroundColor = RGB(221, 221, 221);
        //左边栏目 尺码
        // 浅灰色底
        UIView *sizeBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftW, goodsView.ls_height)];
        sizeBackView.backgroundColor = [UIColor whiteColor];
        [goodsView addSubview:sizeBackView];
        for (int i=0; i<row; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = RGB(51, 51, 51);
            label.backgroundColor = RGB(221, 221, 221);
            [goodsView addSubview:label];
            if (i == 0) {
                label.frame = CGRectMake(0, h * i, leftW, h - 1);
                label.text = @"颜色";
            }else if (i == (row-2)) {
                label.text = @"总数量";
                label.frame = CGRectMake(0, h + sizeH * self.sizeNameList.count, leftW, h - 1);
            } else if (i == (row-1)) {
                label.text = @"总金额";
                label.frame = CGRectMake(0, h * 2 + sizeH * self.sizeNameList.count, leftW, h - 1);
            } else {
                label.frame = CGRectMake(0, h + (sizeH * (i - 1)), leftW, sizeH - 1);
                label.text = [self.sizeNameList objectAtIndex:i - 1];
            }
        }
        
        //款色
        for (int i=0; i< self.skcList.count; i++) {
            SkcListVo *skcVo = [self.skcList objectAtIndex:i];
            
            //颜色 款式
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftW + w * i, 1, w - 1, 22)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = RGB(51, 51, 51);
            label.backgroundColor = bgColor;
            label.text = skcVo.colorVal;
            [goodsView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(leftW + w * i, 1+22, w - 1, 21)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = bgColor;
            label.text = [NSString stringWithFormat:@"(%@)",skcVo.colorNumber];
            [goodsView addSubview:label];
            for (int j=0; j<skcVo.sizeList.count; j++) {
                SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:j];
                UITextField *tfDh = [[UITextField alloc] initWithFrame:CGRectMake(leftW + w * i, 1 + h + sizeH *j, w - 1, sizeH - 1)];
                tfDh.borderStyle = UITextBorderStyleNone;
                tfDh.font = [UIFont systemFontOfSize:14];
                tfDh.textColor = RGB(102, 102, 102);
                tfDh.textAlignment = NSTextAlignmentCenter;
                tfDh.keyboardType = UIKeyboardTypeNumberPad;
                tfDh.backgroundColor = bgColor;
                tfDh.enabled = NO;
                tfDh.tag = i;
                [self createLable:sizeVo tfDh:tfDh w:w];
                [goodsView addSubview:tfDh];
            }
            
            //总数量
            label = [[UILabel alloc] initWithFrame:CGRectMake(leftW + w * i, 1 + h + sizeH * (skcVo.sizeList.count), w - 1, h - 1)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = bgColor;
            label.tag = i;
            label.text = [NSString stringWithFormat:@"%.0f",[skcVo.totalCount doubleValue]];
            [goodsView addSubview:label];
            
            //总金额
            label = [[UILabel alloc] initWithFrame:CGRectMake(leftW + w * i, 1 + h * 2 + (skcVo.sizeList.count) * sizeH, w - 1, h - 1)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = bgColor;
            label.tag = i;
            label.text= [NSString stringWithFormat:@"%.2f",[self.isShowCostPrice ? skcVo.powerTotalMoney : skcVo.totalMoney doubleValue]];
            [goodsView addSubview:label];
        }
        
        height += goodsView.ls_height;
        [detailView addSubview:goodsView];
        
    }else{
        //款色数超过3个，每个款色单独显示
        CGFloat w = (width-5)/4;
        int row = (int)(self.sizeNameList.count+1)/2;
        
        for (int i=0; i<self.skcList.count; i++) {
            SkcListVo *skcVo = [self.skcList objectAtIndex:i];
            UIView *goodsView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 1+h*2 + row * sizeH)];
            goodsView.backgroundColor = RGB(221, 221, 221);
            //颜色 款式
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, width, 22)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = RGB(51, 51, 51);
            label.backgroundColor = RGB(221, 221, 221);
            label.text = skcVo.colorVal;
            [goodsView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1+22, width, 21)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = RGB(221, 221, 221);
            label.text = [NSString stringWithFormat:@"(%@)",skcVo.colorNumber];
            [goodsView addSubview:label];
            
            //总数量
            label = [[UILabel alloc] initWithFrame:CGRectMake(1, 1 + 44, w, 43)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = RGB(51, 51, 51);
            label.backgroundColor = bgColor;
            label.text = @"总数量";
            [goodsView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(2 + w, 1 + 44, w, 43)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = bgColor;
            label.tag = i;
            label.text= [NSString stringWithFormat:@"%.0f",[skcVo.totalCount doubleValue]];
            [goodsView addSubview:label];
            
            //总金额
            label = [[UILabel alloc] initWithFrame:CGRectMake(3 + w * 2, 1 + 44, w, 43)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = RGB(51, 51, 51);
            label.backgroundColor = bgColor;
            label.text = @"总金额";
            [goodsView addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(4 + w*3, 1 + 44, w, 43)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = RGB(102, 102, 102);
            label.backgroundColor = bgColor;
            label.tag = i;
            label.text= [NSString stringWithFormat:@"%.2f",[self.isShowCostPrice ? skcVo.powerTotalMoney : skcVo.totalMoney doubleValue]];
            [goodsView addSubview:label];
            
            //绘制表格内容
            for (int j=0; j<self.sizeNameList.count; j++) {
                int row = j/2;
                int col = j%2;
                SizeListVo *sizeVo = [skcVo.sizeList objectAtIndex:j];
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(1 + (w+1) * 2 * col, 1 + 44 *2 +  row *sizeH, w, sizeH - 1)];
                view.backgroundColor = bgColor;
                UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = RGB(51, 51, 51);
                label.text = [self.sizeNameList objectAtIndex:j];
                [view addSubview:label];
                [goodsView addSubview:view];
                
                UITextField *tfDh = [[UITextField alloc] initWithFrame:CGRectMake(1 + (w+1) * 2 * col + (w+1), 1 + 44 * 2 +  row * sizeH, w, sizeH - 1)];
                tfDh.borderStyle = UITextBorderStyleNone;
                tfDh.font = [UIFont systemFontOfSize:14];
                tfDh.textColor = RGB(102, 102, 102);
                tfDh.textAlignment = NSTextAlignmentCenter;
                tfDh.keyboardType = UIKeyboardTypeNumberPad;
                tfDh.backgroundColor = bgColor;
                tfDh.enabled = NO;
                tfDh.tag = i;
                [self createLable:sizeVo tfDh:tfDh w:w];
                [goodsView addSubview:tfDh];
            }
            
            [detailView addSubview:goodsView];
            height += goodsView.ls_height+15;
        }
    }
    
    
    if (self.skcList.count <= 3) {
        height = height + 15;
    }
    
    UIView *noteView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 15)];
    [detailView addSubview:noteView];
    //吊牌价
    UIImageView *imgPrice = [[UIImageView alloc] init];
    imgPrice.image = [UIImage imageNamed:@"status_price"];
    [noteView addSubview:imgPrice];
    [imgPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noteView.left).offset(10);
        make.centerY.equalTo(noteView);
        make.size.equalTo(15);
    }];
    UILabel *labPrice = [[UILabel alloc] init];
    labPrice.text = self.isShowCostPrice ? @"表示商品成本价" : @"表示商品吊牌价";
    labPrice.font = [UIFont systemFontOfSize:11];
    labPrice.textColor = [ColorHelper getWhiteColor];
    [noteView addSubview:labPrice];
    [labPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPrice.right).offset(5);
        make.centerY.equalTo(imgPrice);
    }];
    [noteView layoutIfNeeded];
    
    //商品库存数
    UIImageView *imgStock = [[UIImageView alloc] init];
    imgStock.image = [UIImage imageNamed:@"status_num"];
    [noteView addSubview:imgStock ];
    [imgStock  makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labPrice.right).offset(5);
        make.centerY.equalTo(noteView);
        make.size.equalTo(15);
    }];
    UILabel *labStock = [[UILabel alloc] init];
    labStock.text = @"表示商品库存数";
    labStock.font = [UIFont systemFontOfSize:11];
    labStock.textColor = [ColorHelper getWhiteColor];
    [noteView addSubview:labStock];
    [labStock makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgStock.right).offset(5);
        make.centerY.equalTo(imgStock);
    }];
    [noteView layoutIfNeeded];
    
    // 单店时，不会有库存冻结的提示，及图标： 默认开微店时注销了
//    if ([[Platform Instance] getShopMode] != 1) {
//        //雪花状图标 表示冻结
//        UIImageView *imgSnow = [[UIImageView alloc] init];
//        imgSnow.image = [UIImage imageNamed:@"ico_snow_white"];
//        [noteView addSubview:imgSnow];
//        [imgSnow makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(labStock.right).offset(5);
//            make.centerY.equalTo(noteView);
//            make.size.equalTo(15);
//        }];
//        UILabel *labSnow = [[UILabel alloc] init];
//        labSnow.text = @"表示冻结库存数";
//        labSnow.font = [UIFont systemFontOfSize:11];
//        labSnow.textColor = [ColorHelper getWhiteColor];
//        [noteView addSubview:labSnow];
//        [labSnow makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(imgSnow.right).offset(5);
//            make.centerY.equalTo(imgSnow);
//        }];
//        [noteView layoutIfNeeded];
//    }
    
    
    height = height + 45;
    detailView.frame = CGRectMake(0, 0, width, height);
    height =(self.scrollView.ls_height<height)?height:self.scrollView.ls_height+30;
    
    detailView.frame = CGRectMake(0, 0, width, height);
    height =(self.scrollView.ls_height<height)?height:self.scrollView.ls_height+30;
    [self.scrollView addSubview:detailView];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, height);
}


- (void)createLable:(SizeListVo *)sizeVo tfDh:(UITextField *)tfDh w:(CGFloat)sw {
    
    NSString *hangTagPriceStr = ([sizeVo.hasStore shortValue]==0)?@"-":[NSString stringWithFormat:@"¥%.2f", self.isShowCostPrice ? [sizeVo.goodsPowerPrice doubleValue] : [sizeVo.goodsHangTagPrice doubleValue]];
    NSString *stockStr = ([sizeVo.hasStore shortValue]==0)?@"-":[NSString stringWithFormat:@"%.0f",[sizeVo.nowStore doubleValue]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:@" "];
//    if ([ObjectUtil isNotNull:sizeVo.lockStore] && [sizeVo.lockStore intValue] != 0) {//有冻结库存
//        //3行
//        CGFloat x = 0;
//        CGFloat y = 0;
//        CGFloat w = tfDh.ls_width;
//        CGFloat h = tfDh.ls_height/3;
//        
//        //吊牌价
//        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
//        lbl.textColor = RGB(102, 102, 102);
//        lbl.font = [UIFont systemFontOfSize:13];
//        //表情图片
//        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//        // 表情图片
//        attch.image = [UIImage imageNamed:@"status_price"];
//        attch.bounds = CGRectMake(0, 0, 15, 15);
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attch]];
//        [attr addAttribute:NSBaselineOffsetAttributeName value:@-2 range:NSMakeRange(0, attr.length)];
//        [attr appendAttributedString:space];
//        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:hangTagPriceStr]];
//        [attr addAttribute:NSParagraphStyleAttributeName value:style
//                     range:NSMakeRange(0, attr.length)];
//        lbl.attributedText = attr;
//        [tfDh addSubview:lbl];
//        
//        
//        //商品库存数
//        y = y + lbl.ls_height;
//        lbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
//        lbl.textColor = RGB(102, 102, 102);
//        lbl.font = [UIFont systemFontOfSize:13];
//
//        
//        //表情图片
//        attch = [[NSTextAttachment alloc] init];
//        // 表情图片
//        attch.image = [UIImage imageNamed:@"status_num"];
//        attch.bounds = CGRectMake(0, 0, 15, 15);
//        attr = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attch]];
//        [attr addAttribute:NSBaselineOffsetAttributeName value:@-2 range:NSMakeRange(0, attr.length)];
//         [attr appendAttributedString:space];
//        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:stockStr]];
//        [attr addAttribute:NSParagraphStyleAttributeName value:style
//                     range:NSMakeRange(0, attr.length)];
//        lbl.attributedText = attr;
//        [tfDh addSubview:lbl];
    
        
        //雪花
       // y = y + lbl.ls_height;
       // lbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        //lbl.textColor = [ColorHelper getRedColor];
        //lbl.font = [UIFont systemFontOfSize:13];
//        //表情图片
//        attch = [[NSTextAttachment alloc] init];
//        attch.image = [UIImage imageNamed:@"status_snow_red"];
//        attch.bounds = CGRectMake(0, 0, 15, 15);
//        attr = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attch]];
//        [attr addAttribute:NSBaselineOffsetAttributeName value:@-2 range:NSMakeRange(0, attr.length)];
//         [attr appendAttributedString:space];
       //attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.f",sizeVo.lockStore.doubleValue]];
        //[attr addAttribute:NSParagraphStyleAttributeName value:style
                   //  range:NSMakeRange(0, attr.length)];
        //lbl.attributedText = attr;
        //[tfDh addSubview:lbl];

//    } else {//无冻结库存
        
        //2行
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = tfDh.ls_width;
        CGFloat h = tfDh.ls_height/2;
        
        //吊牌价
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        lbl.textColor = RGB(102, 102, 102);
        lbl.font = [UIFont systemFontOfSize:13];
        //表情图片
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = [UIImage imageNamed:@"status_price"];
        attch.bounds = CGRectMake(0, 0, 15, 15);
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attch]];
        [attr addAttribute:NSBaselineOffsetAttributeName value:@-2 range:NSMakeRange(0, attr.length)];
        [attr appendAttributedString:space];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:hangTagPriceStr]];
        [attr addAttribute:NSParagraphStyleAttributeName value:style
                     range:NSMakeRange(0, attr.length)];
        lbl.attributedText = attr;
        [tfDh addSubview:lbl];
        
        
        //商品库存数
        y = y + lbl.ls_height;
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        lbl.textColor = RGB(102, 102, 102);
        lbl.font = [UIFont systemFontOfSize:13];
        
        
        //表情图片
        attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = [UIImage imageNamed:@"status_num"];
        attch.bounds = CGRectMake(0, 0, 15, 15);
        attr = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attch]];
        [attr addAttribute:NSBaselineOffsetAttributeName value:@-2 range:NSMakeRange(0, attr.length)];
        [attr appendAttributedString:space];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:stockStr]];
        [attr addAttribute:NSParagraphStyleAttributeName value:style
                     range:NSMakeRange(0, attr.length)];
        lbl.attributedText = attr;
        [tfDh addSubview:lbl];
        
//    }
}

@end
