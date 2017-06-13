//
//  RetailConstants.h
//  retailapp
//
//  Created by hm on 15/6/26.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#ifndef retailapp_RetailConstants_h
#define retailapp_RetailConstants_h

//======================================测试================================================
#if DAILY || DEBUG

//计次卡
#define API_ROOT @"http://10.1.4.152:8080/retail-server/serviceCenter/api"
#define API_OUT_ROOT  @"http://10.1.5.202:8080/retail-api"


//上传图片路径
#define API_UPLOAD_ROOT @"http://zmfile.2dfire-daily.com/zmfile/imageUpload"
//微店二维码地址
#define QRCODE_ROOT @"http://10.1.6.173/shoplist/go_shoplist.do" //测试
#define APP_API_OUT_SECRET @"817dff1ce96b49918708401205e78a14"
//app检查更新地址
#define URL_APP_UPDATE @"http://api.2dfire-daily.com/boss-api/app/v1/query_app_upgrade_version"
//======================================预发================================================
#elif PRE
//预发
#define API_ROOT @"http://myshop.2dfire-pre.com/serviceCenter/api"
#define API_OUT_ROOT  @"http://retailapi.2dfire-pre.com"
//上传图片路径
#define API_UPLOAD_ROOT @"http://rest3.zm1717.com/zmfile/imageUpload"
#define QRCODE_ROOT @"http://retailweixin.2dfire.com/shoplist/go_shoplist.do" //正式
#define APP_API_OUT_SECRET @"29dc4dafc8ad495db12fe411e16197b8"
//app检查更新地址
#define URL_APP_UPDATE @"http://boss-api.2dfire-pre.com/app/v1/query_app_upgrade_version"
//======================================线上================================================
#elif ENTERPRISE || RELEASE
//线上
#define API_ROOT @"https://myshop.2dfire.com/serviceCenter/api"
#define API_OUT_ROOT  @"https://retailapi.2dfire.com"
//上传图片路径
#define API_UPLOAD_ROOT @"http://rest3.zm1717.com/zmfile/imageUpload"
#define QRCODE_ROOT @"https://retailweixin.2dfire.com/shoplist/go_shoplist.do" //正式
#define APP_API_OUT_SECRET @"29dc4dafc8ad495db12fe411e16197b8"
//app检查更新地址
#define URL_APP_UPDATE @"https://boss-api.2dfire.com/app/v1/query_app_upgrade_version"
#endif
//上传图片路径
#define UPLOAD_IMAGE @"upload/image"


//appkey
#define APP_KEY @"S00002"
//appSecret
#define APP_SECRET @"42E1270B7A48412472F6AAE128552ABF"
//系统信息
#define SYS_VERSION @"v1"


//********************************第三方平台友盟分享  start  ********************************
//友盟(分享，统计)的AppKey
#define UmengAppKey  @"58ddd26be88bad6fb00007f2"
//微信开发平台
//线上appstore
#if RELEASE

// app 发布渠道
#define AppChannelId  @"release"
//AppStore
//APP_ID
#define WX_APP_ID @"wx2929be59b59929bd"
//APP_SECERT
#define WX_APP_SECERT @"b57e31236c7ca89beb460e0253d4fb86"
#else

#define AppChannelId  @"enterprise"
//企业版
//APP_ID
#define WX_APP_ID @"wx384217e52c23e5a4"
//APP_SECERT
#define WX_APP_SECERT @"7ac4af5715fe0d51f6cefd913d1b8058"
#endif
//********************************第三方平台友盟分享  end   *********************************

// 智齿云客服key
#if RELEASE || DEBUG
#define ZC_APP_KEY @"55809fdc1ff34a198445492f4add8f1d"
#else 
#define ZC_APP_KEY @"5e8f7d3a44764452be19351b49cf62a2"
#endif

#define APP_API_OUT_KEY @"200002"
//和公司的API注册服务,分配给掌柜的ApI_key.
#define APP_CY_API_KEY @"100008"

//和公司的API注册服务,分配给掌柜的ApI_val.
#define APP_CY_API_SECRET @"540d5a0d2ead402f841c9c690c50165f"

//URL路径格式.
#define URL_PATH_FORMAT @"%@/%@"

//服务器路径
#define SERVER_PATH @"serverpath"

#define BG_FILE @"bgFile"

//用于选择服务器的
#define SERVER_API @"SERVER_API"
#define SERVER_API_OUT @"SERVER_API_OUT"
#define SERVER_API_OUT_SECERT @"SERVER_API_OUT_SECERT"
#define SERVER_API_NAME @"SERVER_API_NAME"

//导出邮箱地址
#define MAIL_PATH @"mailpath"

#define LOGO_ID @"logoid"

#define PHONE @"mobile"

//店铺编码
#define SHOP_CODE @"shopcode"

//店家Id
#define SHOP_ID @"shopid"

//实体Id
#define ENTITY_ID @"entityid"

//分账实体Id
#define PAY_ENTITY_ID @"PAY_ENTITY_ID"

//当前登录者的entityid
#define RELEVANCE_ENTITY_ID @"relevanceentityid"

//店铺名称
#define SHOP_NAME @"shopname"

//用户名ID
#define USER_ID @"userid"

//用户是否是超级管理员.
#define USER_IS_SUPER @"userIsSuper"

//用户名
#define USER_NAME @"username"

//用户
#define USER @"user"

//code
#define CODE @"code"

//密码
#define PASS @"pass"

//员工姓名
#define EMPLOYEE_NAME @"employeename"

//员工工号
#define STAFF_ID @"staffId"

//角色名
#define ROLE_NAME @"rolename"

//角色Id
#define ROLE_ID @"roleId"

//用户密码
#define USER_PASS @"userpass"

//用户头像
#define USER_PIC @"userpic"

//门店是否允许查看同级门店商品库存开关 1关闭 2打开
#define STORE_CHECK_FLAG @"storecheckflag"

//启用装箱单标识 0不启用 1启用
#define PACK_BOX_FLAG @"packBoxFlag"

//允许拒绝配送中的收货单标识 |0 不允许|1 允许|
#define DISTRIBUTION_REFUSE_FLAG @"distributionRefuseFlag"

//允许修改配送中的收货单标识 |0 不允许|1 允许|
#define DISTRIBUTION_EDIT_FLAG @"distributionEditFlag"

//启用退货指导标识 0不启用 1启用
#define RETURN_GUIDE @"returnGuide"

//启用积分商品库存标识 0不启用 1启用
#define POINT_STOCK @"pointStock"

//上级id
#define PARENT_ID @"parentid"

//机构Id
#define ORG_ID @"orgid"

//总机构id
#define FATHER_ORG_ID @"fatherOrgid"

//机构名称
#define ORG_NAME @"orgname"

//机构下仓库id
#define WAREHOUSE_ID @"warehouseid"

//机构下仓库名称
#define WAREHOUSE_NAME @"warehousename"

//连锁id
#define BRAND_ID @"brandid"

//店铺模式(服鞋模式 商超模式)
#define SHOP_MODE @"shopmode"

//sessionId
#define SESSION_ID @"sessionid"

//超时时间
#define TIME_OUT 20

//email
#define EMAIL @"email"

//支付宝
#define Alipay @"8"

//微支付
#define Wxpay @"9"


#define Notification_ModuleInfoChange_Change @"Notification_ModuleInfoChange_Change"


//过期提醒
#define OVERDUE_ALERT @"overdueAlert"
//库存预警
#define STOCK_WARNNING @"stockWarnning"
//公告通知
#define NOTICE_SMS @"noticeSms"
//操作通知
#define NOTICE_SYSTEM @"NOTICE_SYSTEM"
//系统通知
#define SYSTEM_NOFITICATION @"SYSTEM_NOFITICATION1241251"//这个值开头保存沙盒的数据每次重新登录时不会清除
//系统通知数量
#define SYSTEM_NOFITICATION_NUM @"SYSTEM_NOFITICATION_NUM"
//系统通知ID
#define NOFITICATION_ID @"NOFITICATION_ID"
/** 添加商品时的分类 默认是上次商品添加或修改成功的分类 这个需要存到本地 用entityId + kCategoryName/kCategoryId 来存储到本地*/
//商品分类名称
#define kCategoryName @"kCategoryName"
//商品分类Id
#define kCategoryId @"kCategoryId"


#define VERSION @"RMB_1.0"




/** ---------------  提示信息  --------------*/
#define ALERT_MESSAGE_PHONE @"请输入会员卡号或手机号码！"
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
//导航栏高度
#define kNavH 64
//开店完成通知
#define kNotificationOpenShopSucessed @"kNotificationOpenShopSucessed"


#endif
