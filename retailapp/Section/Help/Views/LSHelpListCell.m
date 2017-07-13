//
//  LSHelpListCell.m
//  retailapp
//
//  Created by guozhi on 2017/3/8.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSHelpListCell.h"
@interface LSHelpListCell()
/** 标题 */
@property (nonatomic, strong) UILabel *lblContext;
@end
@implementation LSHelpListCell

+ (instancetype)helpListCellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    LSHelpListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[LSHelpListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell configViews];
        [cell configConstraints];
    }
    return cell;
}

- (void)configViews {
  
    //内容
    self.lblContext = [[UILabel alloc] init];
    self.lblContext.textColor = [ColorHelper getTipColor3];
    self.lblContext.numberOfLines = 0;
    self.lblContext.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.lblContext];
}

- (void)configConstraints {
    __weak typeof(self) wself = self;
    CGFloat margin = 10;
    //内容
    [self.lblContext makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.contentView.left).offset(margin);
        make.right.equalTo(wself.contentView.right).offset(-margin);
        make.top.bottom.equalTo(wself.contentView);
    }];
   
    
}

- (void)setObj:(NSArray *)obj {
    _obj = obj;
    //obj 里面放的是字符串数据 title context note example 分别在字符串的开头用来标记相应的字符串显示什么颜色 img图片标志
    NSString *title = @"title>";
    NSString *context = @"context>";
    NSString *note = @"note>";
    NSString *example = @"example>";
    NSString *img = @"img>";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    [obj enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([str hasPrefix:title]) {
            //如果字符串被title标记显示
            str = [str stringByReplacingOccurrencesOfString:title withString:@""];
            
            //设置蓝色的播放图片
            if ([str hasPrefix:@"►"]) {
                str = [str stringByReplacingOccurrencesOfString:@"►" withString:@""];
                NSTextAttachment *attach = [[NSTextAttachment alloc] init];
                attach.image = [UIImage imageNamed:@"icon_play_blue"];
                NSMutableAttributedString *attachString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
                [attr appendAttributedString:attachString];
            }
            //设置标题
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [ColorHelper getBlueColor]}]];
        } else if ([str hasPrefix:context]) {
            //如果字符串被context标记显示 内容有可能会出现图片比如销售订单详情会出现小车图片 图片样式img>icoimg> 图片路径以ico开拓命名
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
            str = [str stringByReplacingOccurrencesOfString:context withString:@""];
            if ([str containsString:img]) {//判断是否包含图片路径
                NSArray *arr = [str componentsSeparatedByString:img];
                for (NSString *str in arr) {//有图片路径涉及到图文混排
                    if ([str hasPrefix:@"ico"]) {//图片路径
                        //创建图片图片附件
                        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
                        attach.image = [UIImage imageNamed:@"ico_logistics"];
//                        attach.bounds = CGRectMake(0, 0, 32, 18);
                        NSMutableAttributedString *attachString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
                         [attachString addAttribute:NSBaselineOffsetAttributeName value:@-3 range:NSMakeRange(0, attachString.length)];
                        [attr appendAttributedString:attachString];
                    } else {
                        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [ColorHelper getTipColor3]}]];
                    }
                }
            } else {
                [attr appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [ColorHelper getTipColor3]}]];
            }
            
            
            
        } else if ([str hasPrefix:note]) {
            //如果字符串被note标记显示
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
            str = [str stringByReplacingOccurrencesOfString:note withString:@""];
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [ColorHelper getRedColor]}]];
        } else if ([str hasPrefix:example]) {
            //如果字符串被example标记显示
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
            str = [str stringByReplacingOccurrencesOfString:example withString:@""];
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [ColorHelper getTipColor6]}]];
        }
        
    }];
    
    self.lblContext.attributedText = attr;
    
}

@end
