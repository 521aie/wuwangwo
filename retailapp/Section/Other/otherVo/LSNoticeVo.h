//
//  LSNoticeVo.h
//  retailapp
//
//  Created by guozhi on 16/10/10.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSNoticeVo : NSObject
/**消息ID*/
@property (nonatomic, copy) NSString *noticeId;
/**消息目标商店ID*/
@property (nonatomic, copy) NSString *targetShopId;
/**消息标题*/
@property (nonatomic, copy) NSString *noticeTitle;
/**消息内容*/
@property (nonatomic, copy) NSString *noticeContent;
/**发布时间*/
@property (nonatomic, assign) long long publishTime;
/***/
@property (nonatomic, assign) long lastVer;
/***/
@property (nonatomic, assign) short status;
/***/
@property (nonatomic, assign) short type;
/***/
@property (nonatomic, copy) NSString *targetShopName;
/**文件名*/
@property (nonatomic, copy) NSString *fileName;
/**文件内容*/
@property (nonatomic, copy) NSString *file;
/**文件操作*/
@property (nonatomic, assign) short fileOperate;
/**文件路径*/
@property (nonatomic, copy) NSString *filePath;
/**创建时间*/
@property (nonatomic, assign) long long createTime;
/**业务类别 1是一键上架 42是数据清理通知 其他是导出*/
@property (nonatomic, assign) short businessType;
/**点击是否跳转 false:0 true:1*/
@property (nonatomic, assign) short isJump;



@end
