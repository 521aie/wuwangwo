//
//  MarketModelEvent.h
//  retailapp
//
//  Created by zhangzhiliang on 15/8/21.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#ifndef retailapp_MarketModelEvent_h
#define retailapp_MarketModelEvent_h

//特价管理一览页面
#define SPECIAL_OFFER_LIST_LSSHOP 1         //门店下拉选项

//特价管理编辑页面
#define SPECIAL_OFFER_MANAGE_EDIT_SHOP_EVENT @"SPECIAL_OFFER_MANAGE_EDIT_SHOP_EVENT" //促销门店设置


#define SPECIAL_OFFER_MANAGE_EDIT_SALESCHEME 2              //特价方案
#define SPECIAL_OFFER_MANAGE_EDIT_SHOPPRICESCHEME 3         //价格方案
#define SPECIAL_OFFER_MANAGE_EDIT_DISCOUNTRATE 4            //折扣率
#define SPECIAL_OFFER_MANAGE_EDIT_SALEPRICE 5               //特价
#define SPECIAL_OFFER_MANAGE_EDIT_STARTTIME 6               //开始时间
#define SPECIAL_OFFER_MANAGE_EDIT_ENDTIME 7                 //结束时间
#define SPECIAL_OFFER_MANAGE_EDIT_ISMEMBER 8                //会员专享
#define SPECIAL_OFFER_MANAGE_EDIT_ISSHOP 9                //指定门店设置
#define SPECIAL_OFFER_MANAGE_EDIT_RDOSHOP 71                //指定门店设置


//会员生日促销页面
#define BIRTHDAY_SALES_SHOPPRICESCHEME  10            //价格方案
#define BIRTHDAY_SALES_DISCOUNTRATE  11            //折扣率
#define BIRTHDAY_SALES_GOODSCOUNT  12            //限购数量
#define BIRTHDAY_SALES_PURCHASENUMBER  13            //限购次数
#define BIRTHDAY_SALES_ISMEMBERMONTH  14            //在会员生日月有效
#define BIRTHDAY_SALES_ISAPPOINTDATE  15            //在指定时间有效
#define BIRTHDAY_SALES_BEFOREBIR  16            //会员生日前
#define BIRTHDAY_SALES_AFTERBIR  17            //会员生日后
#define BIRTHDAY_SALES_ISUSED  18            //价开启会员生日打折促销

//N件打折编辑页面
#define PIECES_DISCOUNT_EDIT_GROUPTYPE  19            //购买组合方式
#define PIECES_DISCOUNT_EDIT_ISGOODSAREA  20            //指定商品范围
#define PIECES_DISCOUNT_EDIT_STYLEAREA  21            //款式范围
#define PIECES_DISCOUNT_EDIT_GOODSAREA  22            //商品范围
#define PIECES_DISCOUNT_EDIT_EXCEEDRATE  23            //超出最大数量的商品折扣率
#define PIECES_DISCOUNT_EDIT_RATEMAX  74            //折扣封顶

//促销规则添加
#define SALES_REGULATION_ADD_GOODSCOUNT  24            //购买数量
#define SALES_REGULATION_ADD_DISCOUNTRATE  25            //折扣率

//满送/换购规则编辑
#define SALES_SEND_OR_SWAP_EDIT_GOODSCOUNT  26              //购买数量
#define SALES_SEND_OR_SWAP_EDIT_GROUPTYPE   27              //购买组合方式
#define SALES_SEND_OR_SWAP_EDIT_ISGOODSAREA    28           //指定商品范围
#define SALES_SEND_OR_SWAP_EDIT_STYLEAREA      29           //款式范围
#define SALES_SEND_OR_SWAP_EDIT_GOODSAREA      30           //商品范围
#define SALES_SEND_OR_SWAP_EDIT_APPENDMONEY    31           //附加金额
#define SALES_SEND_OR_SWAP_EDIT_PRESENTCOUNT   32           //赠送数量
#define SALES_SEND_OR_SWAP_EDIT_MAXPRESENTCOUNT  33         //最多赠送数量
#define SALES_SEND_OR_SWAP_EDIT_PRESENTSTYLE     34         //赠送款式
#define SALES_SEND_OR_SWAP_EDIT_PRESENTGOODS     35         //赠送商品
#define SALES_SEND_OR_SWAP_EDIT_MONEY            68         //购买金额


//满减规则编辑
#define SALES_MINUS_EDIT_GOODSCOUNT  36              //购买数量
#define SALES_MINUS_EDIT_GROUPTYPE   37              //购买组合方式
#define SALES_MINUS_EDIT_ISGOODSAREA    38           //指定商品范围
#define SALES_MINUS_EDIT_STYLEAREA      39           //款式范围
#define SALES_MINUS_EDIT_GOODSAREA      40           //商品范围
#define SALES_MINUS_EDIT_MINUSMONEY     41           //扣减金额
#define SALES_MINUS_EDIT_MAXMINUSMONEY  42           //最多扣减数量
#define SALES_MINUS_EDIT_MONEY  67                   //购买金额

//优惠券详情
#define SALE_COUPON_EDIT_COUPONWORTH    43              //优惠券面额
#define SALE_COUPON_EDIT_COUNT          44              //数量
#define SALE_COUPON_EDIT_COUPONCREATENUM    45          //出券条件(购买数量)
#define SALE_COUPON_EDIT_COUPONCREATEFEE    46          //出券条件(购买金额)
#define SALE_COUPON_EDIT_GROUPTYPE     47               //购买组合方式
#define SALE_COUPON_EDIT_ISCREATEGOODSAREA  48          //出券指定商品范围
#define SALE_COUPON_EDIT_CREATESTYLEAREA    49          //出券款式范围
#define SALE_COUPON_EDIT_CREATEGOODSAREA    50          //出券商品范围
#define SALE_COUPON_EDIT_COUPONUSENUM   51              //使用条件(购买数量)
#define SALE_COUPON_EDIT_COUPONUSEFEE   52              //使用条件(购买金额)
#define SALE_COUPON_EDIT_ISUSEGOODSAREA 53              //使用指定商品范围
#define SALE_COUPON_EDIT_USESTYLEAREA   54              //使用款式范围
#define SALE_COUPON_EDIT_USEGOODSAREA   55              //使用商品范围
#define SALE_COUPON_EDIT_STARTTIME   69                 //使用商品范围
#define SALE_COUPON_EDIT_ENDTIME   70                   //使用商品范围
#define SALE_COUPON_EDIT_REMARK   72                    //优惠券说明

//促销活动编辑页面
#define MARKET_SALES_EDIT_SHOP_EVENT @"MARKET_SALES_EDIT_SHOP_EVENT" //促销门店设置
#define MARKET_SALES_EDIT_ISSHOP_SHOPPRICESCHEME  56            //适用实体门店价格方案
#define MARKET_SALES_EDIT_ISWEIXIN_SHOPPRICESCHEME  57            //适用微店价格方案
#define MARKET_SALES_EDIT_STARTDATE 58                          //开始日期
#define MARKET_SALES_EDIT_ENDDATE 59                          //结束日期
#define MARKET_SALES_EDIT_SHOPAREA 60                          //适用门店范围
#define MARKET_SALES_EDIT_ISSHOP 61                            //适用实体门店
#define MARKET_SALES_EDIT_ISWEIXIN 62                            //适用微店
#define MARKET_SALES_EDIT_ISSTATUS 73                            //活动状态

//捆绑打折编辑页面
#define BINDING_DISCOUNT_EDIT_GROUPTYPE  63            //购买组合方式
#define BINDING_DISCOUNT_EDIT_ISGOODSAREA  64            //指定商品范围
#define BINDING_DISCOUNT_EDIT_STYLEAREA  65            //款式范围
#define BINDING_DISCOUNT_EDIT_GOODSAREA  66            //商品范围

#endif
