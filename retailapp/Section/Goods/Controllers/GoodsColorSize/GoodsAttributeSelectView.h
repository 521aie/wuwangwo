//
//  GoodsAttributeSelectView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/6.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "INameValueItem.h"
#import "HeadCheckHandle.h"
#import "OptionPickerBox.h"
#import "LSFooterView.h"
#import "GridColHead.h"

typedef void(^styleGoodsAttributeSelectBack) (NSString* type, NSMutableArray* attributeValList);
@class LSFooterView, AttributeVo;
@interface GoodsAttributeSelectView : LSRootViewController<LSFooterViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, HeadCheckHandle, OptionPickerClient>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LSFooterView *footView;



@property (nonatomic,retain) NSMutableArray *headList;    //商品.
@property (nonatomic,retain) NSMutableDictionary *detailMap;
//@property (nonatomic,retain) NSMutableArray *idList;    //商品.

@property (nonatomic, strong) NSMutableArray *nodeList;    //节点.
@property (nonatomic, strong) NSMutableArray *selectIdSet;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, copy) styleGoodsAttributeSelectBack styleGoodsAttributeSelectBack;

-(void) loaddatas:(int)viewTag attributeVo:(AttributeVo*) attributeVo attributeValDic:(NSMutableDictionary*) attributeValDic callBack:(styleGoodsAttributeSelectBack) callBack;

-(void) initHeadData:(NSMutableArray *) headList;

-(void) loaddatasFromLibView;

@end
