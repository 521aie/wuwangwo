//
//  GoodsSingleAttributeListView.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/10.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSRootViewController.h"
#import "FooterListEvent.h"
#import "INameValueItem.h"
#import "ISampleListEvent.h"
#import "SingleCheckHandle.h"
#import "OptionPickerClient.h"
#import "LSFooterView.h"

#define DH_IMAGE_CELL_ITEM_HEIGHT 88
#define DH_HEAD_HEIGHT 40

typedef void(^goodsSingleAttributeListBack) (BOOL flg);
@class   AttributeVo, KindMenuView;
@interface GoodsSingleAttributeListView : LSRootViewController<LSFooterViewDelegate, SingleCheckHandle, OptionPickerClient, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) LSFooterView *footView;

//分类页面
@property (nonatomic, strong) KindMenuView *kindMenuView;

@property (nonatomic,retain) NSMutableArray *headList;    //商品.
@property (nonatomic,retain) NSMutableDictionary *detailMap;

@property (nonatomic,retain) NSMutableArray* datas;

@property (nonatomic,retain) NSMutableArray* attributeGroupList;

@property (nonatomic,retain) AttributeVo* attributeVo;

@property (nonatomic,retain) NSMutableArray* categoryList;

@property (nonatomic) int fromViewTag;

@property (nonatomic, copy) goodsSingleAttributeListBack goodsSingleAttributeListBack;


-(void) loaddatas:(AttributeVo*) attributeVo fromViewTag:(int)viewTag callBack:(goodsSingleAttributeListBack) callBack;

-(void) initHeadData:(NSMutableArray *) headList;

-(void)showKindMenuView;

@end
