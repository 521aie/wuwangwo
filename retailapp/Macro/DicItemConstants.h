//
//  DicItemConstants.h
//  retailapp
//
//  Created by hm on 15/9/28.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#ifndef retailapp_DicItemConstants_h
#define retailapp_DicItemConstants_h


/**采购叫货单状态*/
#define DIC_CALL_ORDER_STATUS @"DIC_CALL_ORDER_STATUS"

/**客户叫货单列表*/
#define DIC_CUSTOMER_CALL_ORDER_STATUS @"DIC_CUSTOMER_CALL_ORDER_STATUS"

/**单店 收货单状态*/
#define DIC_SINGLE_RECEIPT_STATUS @"DIC_SINGLE_RECEIPT_STATUS"

/**连锁 收货单状态*/
#define DIC_CHAIN_RECEIPT_STATUS @"DIC_CHAIN_RECEIPT_STATUS"

/**装箱单状态*/
#define DIC_PACK_BOX_STATUS @"DIC_PACK_BOX_STATUS"

/**单店 退货单*/
#define DIC_SINGLE_RETURN_STATUS @"DIC_SINGLE_RETURN_STATUS"

/**连锁 退货单*/
#define DIC_CHAIN_RETURN_STATUS @"DIC_CHAIN_RETURN_STATUS"

/**客户退货单*/
#define DIC_CUSTOMER_RETURN_STATUS @"DIC_CUSTOMER_RETURN_STATUS"

/**门店调拨单*/
#define DIC_ALLOCATE_STATUS @"DIC_ALLOCATE_STATUS"

//原因code
/**退货原因code*/
#define DIC_RETURN_RESON @"DIC_RETURN_RESON"

/**拒绝配送code*/
#define DIC_REFUSE_RESON @"DIC_REFUSE_RESON"

//允许供货开关
#define CONFIG_ALLOW_SUPPLY @"CONFIG_ALLOW_SUPPLY"

// 启用装箱单
#define CONFIG_OPEN_PACKAGE_STATUS @"CONFIG_OPEN_PACKAGE_STATUS"
//允许拒绝配送中的收货单
#define CONFIG_ALLOW_SENDING_REFUSE @"CONFIG_ALLOW_SENDING_REFUSE"
//允许对配送中的收货单进行修改
#define CONFIG_ALLOW_SENDING_UPDATE @"CONFIG_ALLOW_SENDING_UPDATE"
//查看同级店铺库存 1:关闭 2:开启（默认）
#define CONFIG_SEE_BROTHER_STORE @"CONFIG_SEE_BROTHER_STORE"
#endif
