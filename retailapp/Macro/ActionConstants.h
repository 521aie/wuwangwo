//
//  ActionConstants.h
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#ifndef retailapp_ActionConstants_h
#define retailapp_ActionConstants_h

/**
 *  店家信息
 */
#define ACTION_SHOP_INFO @"ACTION_SHOP_INFO"


/**
 * <code>商品</code>.
 */
#define PAD_GOODS @"PAD_GOODS"
/**
 * <code>员工</code>.
 */
#define PAD_EMPLOYEE @"PAD_EMPLOYEE"
/**
 
 * <code>物流管理</code>.
 */
#define MODULE_MATERIAL_FLOW @"MODULE_MATERIAL_FLOW"

/**
* <code>退货类型</code>.
*/
#define MATERIAL_RETURN_TYPE @"MATERIAL_RETURN_TYPE"

/**
 * <code>库存管理</code>.
 */
#define MODULE_STOCK @"MODULE_STOCK"

/**
 * <code>消息中心</code>.
 */
#define ACTION_NOTICE_INFO @"ACTION_NOTICE_INFO"
#define ACTION_OVERDUE @"ACTION_OVERDUE"
#define ACTION_STOCK_WARNING @"ACTION_STOCK_WARNING"
#define ACTION_MESSAGE @"ACTION_MESSAGE"
#define ACTION_SYSTEM_NOTIFICATION @"ACTION_SYSTEM_NOTIFICATION"//系统通知
/**
 * <code>会员管理</code>.
 */
#define PAD_MEMBER @"PAD_MEMBER"
/**
 * <code>营销管理</code>.
 */

#define PAD_MARKET @"PAD_MARKET"
/**
 * <code>微店管理</code>.
 */
#define PAD_WECHAT @"PAD_WECHAT"
/**
 * <code>顾客评价</code>.
 */
#define PAD_COMMENT @"PAD_COMMENT"

/**
 * <code>报表</code>.
 */
#define PAD_REPORT @"PAD_REPORT"

/**
 * <code>会员类型一览/code>.
 */
#define MEMBER_TYPE_LIST @"MEMBER_TYPE_LIST"

/**
 * <code>商品信息管理/code>.
 */
#define GOODS_INFO_MANAGE @"GOODS_INFO_MANAGE"

/**
 * <code>商品款式管理/code>.
 */
#define GOODS_STYLE_MANAGE @"GOODS_STYLE_MANAGE"

/**
 * <code>销售包管理/code>.
 */
#define SALE_PACK_MANAGE @"SALE_PACK_MANAGE"

/**
 * <code>微店管理</code>.
 */
#define MODULE_WECHAT @"MODULE_WECHAT"
/**
 * <code>微分销</code>.
 */
#define PAD_DISTRIBUTE @"PAD_DISTRIBUTE"

/**
 * <code>扫码结账</code>.
 */
#define PAD_SCANCODE @"PAD_SCANCODE"

/**
 * <code>电子收款账户/code>.
 */
#define PAD_PAYMENT @"PAD_PAYMENT"




//----------------------------------新增权限code-------------------------------------------
/**9  会员发卡*/
#define ACTION_CARD_ADD @"ACTION_CARD_ADD"
/**10 会员修改*/
#define ACTION_CARD_EDIT @"ACTION_CARD_EDIT"
/**11 会员一览表*/
#define ACTION_CARD_SEARCH @"ACTION_CARD_SEARCH"
/**12 充值优惠设置*/
#define ACTION_CARD_CHARGE_PROMOTION @"ACTION_CARD_CHARGE_PROMOTION"
/**13 会员充值*/
#define ACTION_CARD_CHARGE @"ACTION_CARD_CHARGE"
/**14 积分兑换*/
#define ACTION_POINT_EXCHANGE @"ACTION_POINT_EXCHANGE"
/**15 挂失与解挂*/
#define ACTION_CARD_REPORT_LOSS @"ACTION_CARD_REPORT_LOSS"
/**16 积分兑换设置*/
#define ACTION_POINT_EXCHANGE_SET @"ACTION_POINT_EXCHANGE_SET"
/**17 会员卡类型*/
#define ACTION_CARD_CATEGORY @"ACTION_CARD_CATEGORY"
/**18 短信模版*/
#define ACTION_SMS_TEMPLATE @"ACTION_SMS_TEMPLATE"
/**19 营销短信*/
#define ACTION_SMS_SEND @"ACTION_SMS_SEND"
/**20 生日提醒*/
#define ACTION_BIRTHDAY_REMIND @"ACTION_BIRTHDAY_REMIND"
/**68 充值红冲*/
#define ACTION_CARD_UNDO_CHARGE @"ACTION_CARD_UNDO_CHARGE"
/**69 会员退卡*/
#define ACTION_CARD_CLOSE @"ACTION_CARD_CLOSE"

/**会员1期新增 会员信息汇总*/
#define ACTION_CARD_INFO_COLLECT @"ACTION_CARD_INFO_COLLECT"
/**会员1期新增 会员换卡*/
#define ACTION_CARD_CHANGE @"ACTION_CARD_CHANGE"
/**会员1期新增 会员赠分*/
#define ACTION_CARD_GIVE_DEGREE @"ACTION_CARD_GIVE_DEGREE"
/**会员1期新增 修改密码*/
#define ACTION_CARD_CHANGE_PASSWORD @"ACTION_CARD_CHANGE_PASSWORD"
/**会员1期新增 赠分红冲*/
#define ACTION_CARD_UNDO_GIVE_DEGREE @"ACTION_CARD_UNDO_GIVE_DEGREE"
/**会员1期新增 消费记录*/
#define ACTION_CARD_CONSUME_RECORD @"ACTION_CARD_CONSUME_RECORD"

/**默认开微店新增 积分商品数量设置*/
#define ACTION_GIFT_GOODS_COUNT_SETTING @"ACTION_GIFT_GOODS_COUNT_SETTING"
/**默认开微店新增 兑换设置大权限:通过小权限判断大权限*/
#define PAD_MEMBER_POINT_SET @"PAD_MEMBER_POINT_SET"

/**“储值充值（原会员充值）”之后  计次服务设置*/
#define ACTION_ACCOUNTCARD_SET @"ACTION_ACCOUNTCARD_SET"
/**“计次服务设置”之后  计次充值*/
#define ACTION_ACCOUNTCARD_CHARGE @"ACTION_ACCOUNTCARD_CHARGE"
/**“计次充值”之后  计次服务退款*/
#define ACTION_ACCOUNTCARD_REFUND @"ACTION_ACCOUNTCARD_REFUND"


/**21 特价管理*/
#define ACTION_SPECIAL_PRICE @"ACTION_SPECIAL_PRICE"
/**22 满送/换购*/
#define ACTION_MATCH_SWAP @"ACTION_MATCH_SWAP"
/**23 满减*/
#define ACTION_MATCH_DECREASE @"ACTION_MATCH_DECREASE"
/**24 捆绑打折*/
#define ACTION_SALES_BINDING @"ACTION_SALES_BINDING"
/**25 第N件打折*/
#define ACTION_SALES_N_DISCOUNT @"ACTION_SALES_N_DISCOUNT"
/**26 优惠券*/
#define ACTION_SALES_COUPON @"ACTION_SALES_COUPON"
/**27 系统参数*/
#define ACTION_SYS_CONFIG_SETTING @"ACTION_SYS_CONFIG_SETTING"
/**28 门店添加*/
#define ACTION_SHOP_ADD @"ACTION_SHOP_ADD"
/**29 门店删除*/
#define ACTION_SHOP_DELETE @"ACTION_SHOP_DELETE"
/**30 小票设置*/
#define ACTION_RECEIPT_SETTING @"ACTION_RECEIPT_SETTING"
/**31 角色权限*/
#define ACTION_EMPLOYEE_ACTION @"ACTION_EMPLOYEE_ACTION"
/**32 员工管理*/
#define ACTION_EMPLOYEE_MANAGE @"ACTION_EMPLOYEE_MANAGE"
/**39 库存汇总查询*/
#define ACTION_STOCK_SUMMARIZE_SEARCH @"ACTION_STOCK_SUMMARIZE_SEARCH"
/**44 消息中心*/
#define ACTION_NOTICE_INFO @"ACTION_NOTICE_INFO"
/**49 销售月报表*/
#define ACTION_REPORT_MONTHLY @"ACTION_REPORT_MONTHLY"
/**51 收银台*/
#define ACTON_CASHIER_DESK @"ACTON_CASHIER_DESK"
/**52 标价签打印设置*/
#define ACTION_TAG_PRINT_SETTING @"ACTION_TAG_PRINT_SETTING"
/**53 交接班*/
#define ACTION_USER_HANDOVER @"ACTION_USER_HANDOVER"
/**54 销售退货*/
#define ACTION_SALES_RETURN @"ACTION_SALES_RETURN"
/**55 消息中心*/
#define ACTION_CASH_NOTICE_INFO @"ACTION_CASH_NOTICE_INFO"
/**56 交易流水*/
#define ACTION_SALES_FLOW @"ACTION_SALES_FLOW"
/**57 门店修改*/
#define ACTION_SHOP_EDIT @"ACTION_SHOP_EDIT"
/**58 整单折扣*/
#define ACTION_WHOLE_DISCOUNT @"ACTION_WHOLE_DISCOUNT"
/**61 短信设置*/
#define ACTION_SMS_SET @"ACTION_SMS_SET"
/**66 单品折扣*/
#define ACTION_PRODUCT_DISCOUNT @"ACTION_PRODUCT_DISCOUNT"
/**67 角色提成设置*/
#define ACTION_ROLE_COMMISSION_SETTING @"ACTION_ROLE_COMMISSION_SETTING"
/**71 款式添加*/
#define ACTION_GOODS_STYLE_ADD @"ACTION_GOODS_STYLE_ADD"
/**72 款式修改*/
#define ACTION_GOODS_STYLE_EDIT @"ACTION_GOODS_STYLE_EDIT"
/**73 款式删除*/
#define ACTION_GOODS_STYLE_DELETE @"ACTION_GOODS_STYLE_DELETE"
/**74 商品属性管理*/
#define ACTION_GOODS_ATTRIBUTE_MANAGE @"ACTION_GOODS_ATTRIBUTE_MANAGE"
/**75 店内码规则设置*/
#define ACTION_INNERCODE_SET @"ACTION_INNERCODE_SET"
/**76 装箱单*/
#define ACTION_STOCK_PACK @"ACTION_STOCK_PACK"
/**77 退货指导*/
#define ACTION_STOCK_RETURN_GUIDE @"ACTION_STOCK_RETURN_GUIDE"
/**89 个人信息*/
#define ACTION_COMPANION_MANAGE @"ACTION_COMPANION_MANAGE"
/**90 账户余额*/
#define ACTION_COMPANION_ACCOUNT_SEARCH @"ACTION_COMPANION_ACCOUNT_SEARCH"
/**92 微店商品信息*/
//#define ACTION_DISTRIBUTION_SHOP_MANAGE @"ACTION_DISTRIBUTION_SHOP_MANAGE"
/**99 门店营业统计*/
#define ACTION_INCOME_SEARCH @"ACTION_INCOME_SEARCH"
/**100 账户信息*/
#define ACTION_ACCOUNT_INFO @"ACTION_ACCOUNT_INFO"
/**101 支付方式*/
#define ACTION_PAYMENT_TYPE @"ACTION_PAYMENT_TYPE"
/**102 数据清理*/
#define ACTION_CLEAN_DATA @"ACTION_CLEAN_DATA"
/**102 店内屏幕广告*/
#define ACTION_SCREEN_ADVERTISING @"ACTION_SCREEN_ADVERTISING"
/**103 业绩目标*/
#define ACTION_PERFORMANCE_TARGET @"ACTION_PERFORMANCE_TARGET"
/**104 主页显示设置*/
#define ACTION_HOMEPAGE_SET @"ACTION_HOMEPAGE_SET"
/**112 生日促销*/
#define ACTION_SALES_BIRTHDAY @"ACTION_SALES_BIRTHDAY"
/**113 商品供货明细表*/
#define ACTION_SUPPLY_GOODS @"ACTION_SUPPLY_GOODS"
/**115 店铺评价(实体)*/
#define ACTION_SHOP_COMMENT @"ACTION_SHOP_COMMENT"
/**116 店铺评价(微店)*/
#define ACTION_WEISHOP_COMMENT @"ACTION_WEISHOP_COMMENT"
/**117 商品评价(实体)*/
#define ACTION_GOODS_COMMENT @"ACTION_GOODS_COMMENT"
/**118 商品评价(微店)*/
#define ACTION_WEISHOP_GOODS_COMMENT @"ACTION_WEISHOP_GOODS_COMMENT"
/**122 商圈卡交易查询*/
#define ACTION_MALL_CARD_CONSUMPTION_SEARCH @"ACTION_MALL_CARD_CONSUMPTION_SEARCH"
/**123 入驻商圈*/
#define ACTION_SETTLED_MALL @"ACTION_SETTLED_MALL"
/**124 扫码结账*/
#define ACTION_SCANNING_RECEIVABLES @"ACTION_SCANNING_RECEIVABLES"
/**122 个人营业统计'*/
#define ACTION_USER_INCOME_SEARCH @"ACTION_USER_INCOME_SEARCH"
/**123 客单备注'*/
#define ACTION_ORDER_MEMO @"ACTION_ORDER_MEMO"
/**评价管理*/
#define ACTION_EVALUATION_MANAGE @"EVALUATION_MANAGE"

//------------------------------商品权限---------------------------
/** 商品添加 */
#define ACTION_GOODS_ADD @"ACTION_GOODS_ADD"
/** 商品修改 */
#define ACTION_GOODS_EDIT @"ACTION_GOODS_EDIT"
/** 商品删除 */
#define ACTION_GOODS_DELETE @"ACTION_GOODS_DELETE"
/** 商品查询 */
#define ACTION_GOODS_SEARCH @"ACTION_GOODS_SEARCH"
/** 销售设置 */
#define ACTION_MARKET_SET @"ACTION_MARKET_SET"
/** 分类管理 */
#define ACTION_CATEGORY_MANAGE @"ACTION_CATEGORY_MANAGE"
/** 商品拆分 */
#define ACTION_GOODS_SPLIT @"ACTION_GOODS_SPLIT"
/** 商品组装 */
#define ACTION_GOODS_PACKAGE @"ACTION_GOODS_PACKAGE"
/** 商品加工 */
#define ACTION_GOODS_PROCESS @"ACTION_GOODS_PROCESS"
/** 参考进货价管理 */
#define ACTION_REF_PURCHASE_PRICE @"ACTION_REF_PURCHASE_PRICE"
/** 初始库存及成本价设置 */
#define ACTION_STORE_COST_PRICE_SET @"ACTION_STORE_COST_PRICE_SET"

//---------------------------------------------------------------------

//------------------------------物流权限---------------------------
/** 供应商管理 */
#define ACTION_SUPPLIER_MANAGE @"ACTION_SUPPLIER_MANAGE"
/** 物流记录查询 */
#define ACTION_MATERIAL_FLOW @"ACTION_MATERIAL_FLOW"
/** 门店调拨单 */
#define ACTION_STOCK_ALLOCATE @"ACTION_STOCK_ALLOCATE"
/** 退货出库单 */
#define ACTION_STOCK_RETURN @"ACTION_STOCK_RETURN"
/** 收货入库单 */
#define ACTION_STOCK_IN @"ACTION_STOCK_IN"
/** 采购单 */
#define ACTION_STOCK_ORDER @"ACTION_STOCK_ORDER"
/** 客户采购单查看 */
#define ACTION_STOCK_ORDER_SEARCH @"ACTION_STOCK_ORDER_SEARCH"
/** 客户退货单查看 */
#define ACTION_STOCK_RETURN_SEARCH @"ACTION_STOCK_RETURN_SEARCH"
/** 客户采购单确认 */
#define ACTION_STOCK_ORDER_CHECK @"ACTION_STOCK_ORDER_CHECK"
/** 客户退货单确认 */
#define ACTION_STOCK_RETURN_CHECK @"ACTION_STOCK_RETURN_CHECK"
/** 门店调拨单确认 */
#define ACTION_STOCK_ALLOCATE_CHECK @"ACTION_STOCK_ALLOCATE_CHECK"
/** 进货价/退货价查看 */
#define ACTION_PURCHASE_RETURN_PRICE_SEARCH @"ACTION_PURCHASE_RETURN_PRICE_SEARCH"
/** 进货价/退货价修改 */
#define ACTION_PURCHASE_RETURN_PRICE_EDIT @"ACTION_PURCHASE_RETURN_PRICE_EDIT"

//----------------------------------------------------------------


//------------------------------库存权限---------------------------
/** 库存查询 */
#define ACTION_STOCK_SEARCH @"ACTION_STOCK_SEARCH"
/** 盘点管理 */
#define ACTION_STOCK_CHECK @"ACTION_STOCK_CHECK"
/** 盘点结果记录查询 */
#define ACTION_STOCK_CHECK_SEARCH @"ACTION_STOCK_CHECK_SEARCH"
/** 提醒设置 */
#define ACTION_REMIND_SETTING @"ACTION_REMIND_SETTING"
/** 库存调整 */
#define ACTION_STOCK_ADJUST @"ACTION_STOCK_ADJUST"
/** 成本价调整 */
#define ACTION_COST_PRICE_BILLS @"ACTION_COST_PRICE_BILLS"
/** 成本价调整确认 */
#define ACTION_COST_PRICE_BILLS_CHECK @"ACTION_COST_PRICE_BILLS_CHECK"
/** 库存变更记录 */
#define ACTION_STOCK_CHANGE_SEARCH @"ACTION_STOCK_CHANGE_SEARCH"
/** 成本价变更记录 */
#define ACTION_COST_PRICE_CHANGELOG @"ACTION_COST_PRICE_CHANGELOG"
/** 仓库管理 */
#define ACTION_WARE_HOUSE_MANAGE @"ACTION_WARE_HOUSE_MANAGE"
/** 库存调整单确认 */
#define ACTION_STOCK_ADJUST_CHECK @"ACTION_STOCK_ADJUST_CHECK"
/** 成本价查看 */
#define ACTION_COST_PRICE_SEARCH @"ACTION_COST_PRICE_SEARCH"

/**默认开微店删除*/
/** 积分商品库存 */
//#define ACTION_GIFT_STOCK_MANAGE @"ACTION_GIFT_STOCK_MANAGE"



//----------------------------------------------------------------



//------------------------------报表权限---------------------------
/** 交接班记录 */
#define ACTION_HANDOVER_SEARCH @"ACTION_HANDOVER_SEARCH"
/** 员工提成报表 */
#define ACTION_PERFORMANCE_SEARCH @"ACTION_PERFORMANCE_SEARCH"
/** 商品交易流水报表 */
#define ACTION_SELL_SEARCH @"ACTION_SELL_SEARCH"
/** 销售收益报表 */
#define ACTION_REPORT_DAILY @"ACTION_REPORT_DAILY"
/** 会员消费记录 */
#define ACTION_MEMBER_CONSUMPTION_SEARCH @"ACTION_MEMBER_CONSUMPTION_SEARCH"
/** 收款统计报表 */
#define ACTION_SHOP_RECEIPT_REPORT @"ACTION_SHOP_RECEIPT_REPORT"
/** 员工业绩报表 */
#define ACTION_ACHIEVEMENT_REPORT @"ACTION_ACHIEVEMENT_REPORT"
/** 商品分类销售报表 */
#define ACTION_GOODS_CATEGORY_SALE @"ACTION_GOODS_CATEGORY_SALE"
/** 商品销售报表 */
#define ACTION_GOODS_SELL_REPORT @"ACTION_GOODS_SELL_REPORT"
/** 会员充值记录 */
#define ACTION_CARD_CHARGE_SEARCH @"ACTION_CARD_CHARGE_SEARCH"
/** 会员积分兑换记录 */
#define ACTION_MEMBER_EXCHANGE_SEARCH @"ACTION_MEMBER_EXCHANGE_SEARCH"
/** 会员卡操作记录 */
#define ACTION_CARD_OPERATE @"ACTION_CARD_OPERATE"
/** 库存结存报表 */
#define ACTION_STOCK_BALANCE_REPORT @"ACTION_STOCK_BALANCE_REPORT"
/** 商品采购报表 */
#define ACTION_STOCK_ORDER_REPORT @"ACTION_STOCK_ORDER_REPORT"
/** 供应商采购报表 */
#define ACTION_SUPPLY_ORDER_REPORT @"ACTION_SUPPLY_ORDER_REPORT"

/**“会员充值记录”之后  计次充值记录*/
#define ACTION_ACCOUNTCARD_CHARGE_SEARCH @"ACTION_ACCOUNTCARD_CHARGE_SEARCH"


//---------------------------------------------------------------------


/*
 * 微店管理权限
 */
/**申请开通微店*/
#define ACTION_OPEN_WEISHOP @"ACTION_OPEN_WEISHOP"
/**微店设置*/
#define ACTION_WEISHOP_SET @"ACTION_WEISHOP_SET"
/**配送管理*/
#define ACTION_WEISHOP_DISTRIBUTION_SET @"ACTION_WEISHOP_DISTRIBUTION_SET"
/**64 订单管理*/
#define ACTION_WEISHOP_ORDER @"ACTION_WEISHOP_ORDER"
/**积分兑换管理*/
#define ACTION_WEISHOP_POINT_EXCHANGE @"ACTION_WEISHOP_POINT_EXCHANGE"
/**退货审核*/
#define ACTION_WEISHOP_RETURN_GOODS @"ACTION_WEISHOP_RETURN_GOODS"
/**退款管理*/
#define ACTION_REFUND_MANAGE @"ACTION_REFUND_MANAGE"
/**微店主页设置*/
#define ACTION_WEISHOP_HOMEPAGE_MANAGE @"ACTION_WEISHOP_HOMEPAGE_MANAGE"
/**微店商品信息*/
#define ACTION_WEISHOP_GOODS @"ACTION_WEISHOP_GOODS"
/**默认开微店 将 虚拟库存管理 修改为 微店可销售数量设置*/
#define ACTION_VIRTUAL_STOCK_MANAGE @"ACTION_VIRTUAL_STOCK_MANAGE"
/**款式查询*/
#define ACTION_GOODS_STYLE_SEARCH @"ACTION_GOODS_STYLE_SEARCH"
/**默认开微店新增 店铺二维码*/
//#define ACTION_WEISHOP @"ACTION_WEISHOP"
#define ACTION_WEIDIAN_QR_CODE @"ACTION_WEIDIAN_QR_CODE"

/**默认开微店删除*/
/**微店信息*/
//#define ACTION_WEISHOP @"ACTION_WEISHOP"
/**账户信息*/
//#define ACTION_ACCOUNT_INFO @"ACTION_ACCOUNT_INFO"
/**订单处理机构*/
//#define ACTION_WEISHOP_ORDER_OP_ORG @"ACTION_WEISHOP_ORDER_OP_ORG"
/**提现审核*/
//#define ACTION_WEISHOP_WITHDRAW @"ACTION_WEISHOP_WITHDRAW"
/**主题销售包*/
//#define ACTION_SALE_PARK @"ACTION_SALE_PARK"
/**微店积分商品库存*/
//#define ACTION_WEISHOP_GIFT_STOCK @"ACTION_WEISHOP_GIFT_STOCK"
/**虚拟库存管理*/
//#define ACTION_VIRTUAL_STOCK_MANAGE @"ACTION_VIRTUAL_STOCK_MANAGE"


/**
 * 电子收款账户权限
 */
/**微信支付汇总*/
#define ACTION_WEI_PAY_SUMMARIZE_SEARCH @"ACTION_WEI_PAY_SUMMARIZE_SEARCH"
/**微信支付明细*/
#define ACTION_WEI_PAY_SEARCH @"ACTION_WEI_PAY_SEARCH"


//绑定银行卡
#define ACTION_BANK_BINDING @"ACTION_BANK_BINDING"

#endif
