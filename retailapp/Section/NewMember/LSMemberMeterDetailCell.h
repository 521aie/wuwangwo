//
//  LSMemberMeterDetailCell.h
//  retailapp
//
//  Created by wuwangwo on 2017/3/31.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSMemberMeterGoodsVo,LSMemberMeterVo;

@protocol LSMemberMeterDetailCellDelagate <NSObject>
-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag;
@end

@interface LSMemberMeterDetailCell : UITableViewCell
+ (instancetype)meterDetailCellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblCode;
@property (nonatomic ,copy) UIColor *myColor;
@property(strong,nonatomic)UILabel *numCountLab;//购买商品的数量
@property(strong,nonatomic)UIButton *addBtn;//添加商品数量
@property(strong,nonatomic)UIButton *deleteBtn;//删除商品数量
@property(strong,nonatomic)UIButton *isSelectBtn;//是否选中按钮
@property(assign,nonatomic)BOOL selectState;//选中状态
@property (nonatomic, strong) NSMutableArray *meterGoodsList;
@property (nonatomic, strong) LSMemberMeterGoodsVo *obj;
@property (nonatomic ,assign) id<LSMemberMeterDetailCellDelagate> delegate;
- (void)setObj:(LSMemberMeterGoodsVo*)obj;
@end
