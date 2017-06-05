//
//  CategoryVo.h
//  retailapp
//
//  Created by zhangzhiliang on 15/7/27.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "Jastor.h"
#import "INameItem.h"
@interface CategoryVo : Jastor<INameItem>
/**
 * <code>主键</code>.
 */
@property (nonatomic, strong) NSString *categoryId;

/**
 * <code>分类编码</code>.
 */
@property (nonatomic, strong) NSString *code;

/**
 * <code></code>.
 */
@property (nonatomic) int sortCode;

/**
 * <code>分类名称</code>.
 */
@property (nonatomic, strong) NSString *name;

/**
 * <code>类目名称</code>.
 */
@property (nonatomic, strong) NSString *microname;

/**
 * <code>分类拼音</code>.
 */
@property (nonatomic, strong) NSString *spell;

/**
 * <code>父类ID</code>.
 */
@property (nonatomic, strong) NSString *parentId;

/**
 * <code>父类名称</code>.
 */
@property (nonatomic, strong) NSString *parentName;

/**
 * <code>备注</code>.
 */
@property (nonatomic, strong) NSString *memo;

/**
 * <code>该分类下是否存在商品信息：0 false；1 true</code>.
 */
@property (nonatomic, strong) NSString *hasGoods;

/**
 * <code>版本号</code>.
 */
@property (nonatomic) NSInteger lastVer;

/**
 * <code>商品数量</code>.
 */
@property (nonatomic) NSInteger goodsSum;

/**
 * <code>级数</code>.
 */
@property (nonatomic) short step;

/**
 * <code>子分类List</code>.
 */
@property (nonatomic, strong) NSMutableArray* categoryVoList;

@property (nonatomic, assign) BOOL isSelect;

+(id) categoryVoList_class;

+(CategoryVo*)convertToCategoryVo:(NSDictionary*)dic;

+ (NSMutableArray *)converToArr:(NSArray*)sourceList;

@end
