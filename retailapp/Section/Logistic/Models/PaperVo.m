//
//  PaperVo.m
//  retailapp
//
//  Created by hm on 15/10/9.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "PaperVo.h"
#import "DateUtils.h"

@implementation PaperVo

+ (PaperVo *)converToVo:(NSDictionary *)dic paperType:(NSInteger)paperType
{
    PaperVo *vo = [[PaperVo alloc] init];
    if ([ObjectUtil isNotEmpty:dic])
    {
        if (paperType == ORDER_PAPER_TYPE || paperType == CLIENT_ORDER_PAPER_TYPE)
        {
            vo.paperId = [ObjectUtil getStringValue:dic key:@"orderGoodsId"];
            vo.paperNo = [ObjectUtil getStringValue:dic key:@"orderGoodsNo"];
            
        }
        else if (paperType == PURCHASE_PAPER_TYPE)
        {
            vo.paperId = [ObjectUtil getStringValue:dic key:@"stockInId"];
            vo.paperNo = [ObjectUtil getStringValue:dic key:@"stockInNo"];
            vo.recordType = [ObjectUtil getStringValue:dic key:@"recordType"];
            vo.lastVer = [ObjectUtil getStringValue:dic key:@"lastVer"];
        }
        else if (paperType == ALLOCATE_PAPER_TYPE)
        {
            vo.paperId = [ObjectUtil getStringValue:dic key:@"allocateId"];
            vo.paperNo = [ObjectUtil getStringValue:dic key:@"allocateNo"];
            vo.outShopName = [ObjectUtil getStringValue:dic key:@"outShopName"];
            vo.inShopName = [ObjectUtil getStringValue:dic key:@"inShopName"];
            vo.lastVer = [ObjectUtil getStringValue:dic key:@"lastVer"];
        }
        else if (paperType == RETURN_PAPER_TYPE || paperType == CLIENT_RETURN_PAPER_TYPE)
        {
            vo.paperId = [ObjectUtil getStringValue:dic key:@"returnGoodsId"];
            vo.paperNo = [ObjectUtil getStringValue:dic key:@"returnGoodsNo"];
        }
        if ([ObjectUtil isNotNull:dic[@"supplyCheck"]]) {
            vo.supplyCheck = [dic[@"supplyCheck"] boolValue];
        }
        vo.sendEndTime = [ObjectUtil getLonglongValue:dic key:@"sendEndTime"];
        vo.billStatus = [ObjectUtil getIntegerValue:dic key:@"billStatus"];
        vo.billStatusName = [ObjectUtil getStringValue:dic key:@"billStatusName"];
        vo.goodsTotalPrice = [ObjectUtil getDoubleValue:dic key:@"goodsTotalPrice"];
        vo.goodsTotalSum = [ObjectUtil getDoubleValue:dic key:@"goodsTotalSum"];
        vo.supplyId = [ObjectUtil getStringValue:dic key:@"supplyId"];
        vo.supplyName = [ObjectUtil getStringValue:dic key:@"supplyName"];
        vo.shopId = [ObjectUtil getStringValue:dic key:@"shopId"];
        vo.shopName = [ObjectUtil getStringValue:dic key:@"shopName"];
        vo.billType = paperType;
    }
    return vo;
}

+ (NSMutableArray *)converToArr:(NSArray *)sourceList paperType:(NSInteger)paperType
{
    if ([ObjectUtil isNotEmpty:sourceList]) {
        NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:sourceList.count];
        for (NSDictionary *dic in sourceList) {
            PaperVo *vo = [PaperVo converToVo:dic paperType:paperType];
            [dataList addObject:vo];
        }
        return dataList;
    }
    return [NSMutableArray array];
}

+ (NSDictionary *)converToDic:(PaperVo *)paperVo paperType:(NSInteger)paperType
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if ([ObjectUtil isNotNull:paperVo]) {
        if (paperType == ORDER_PAPER_TYPE) {
            [ObjectUtil setStringValue:data key:@"orderGoodsId" val:paperVo.paperId];
            [ObjectUtil setStringValue:data key:@"orderGoodsNo" val:paperVo.paperNo];
        }
        [ObjectUtil setLongLongValue:data key:@"sendEndTime" val:paperVo.sendEndTime];
        [ObjectUtil setIntegerValue:data key:@"billStatus" val:paperVo.billStatus];
        [ObjectUtil setStringValue:data key:@"lastVer" val:paperVo.lastVer];
        [ObjectUtil setStringValue:data key:@"supplyId" val:paperVo.supplyId];
        [ObjectUtil setStringValue:data key:@"supplyName" val:paperVo.supplyName];
    }
    return data;
}

+ (NSDictionary *)converStockInVoToDic:(PaperVo *)paperVo {
   
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [ObjectUtil setLongLongValue:data key:@"sendEndTime" val:paperVo.sendEndTime];
    [ObjectUtil setIntegerValue:data key:@"billStatus" val:paperVo.billStatus];
    [ObjectUtil setStringValue:data key:@"lastVer" val:paperVo.lastVer];
    [ObjectUtil setStringValue:data key:@"supplyId" val:paperVo.supplyId];
    [ObjectUtil setStringValue:data key:@"supplyName" val:paperVo.supplyName];
   
    [ObjectUtil setStringValue:data key:@"recordType" val:paperVo.recordType];
    [ObjectUtil setStringValue:data key:@"stockInId" val:paperVo.paperId];
    [ObjectUtil setStringValue:data key:@"stockInNo" val:paperVo.paperNo];
    [ObjectUtil setStringValue:data key:@"billStatusName" val:paperVo.billStatusName];
    [ObjectUtil setDoubleValue:data key:@"goodsTotalSum" val:paperVo.goodsTotalSum];
    [ObjectUtil setDoubleValue:data key:@"goodsTotalPrice" val:paperVo.goodsTotalPrice];
    [ObjectUtil setStringValue:data key:@"shopId" val:paperVo.shopId];
    [ObjectUtil setStringValue:data key:@"shopName" val:paperVo.shopName];
    return [data copy];
}

#pragma mark - ExportListProtocol

- (NSString *)getStatus {
    return self.billStatusName;
}

- (NSString *)getBillDate {
    
    if (self.billType == ORDER_PAPER_TYPE || self.billType == PURCHASE_PAPER_TYPE || self.billType == CLIENT_ORDER_PAPER_TYPE)
    {
       return [NSString stringWithFormat:@"要求到货日:%@",[DateUtils formateTime2:self.sendEndTime]];
    }
    else if (self.billType == ALLOCATE_PAPER_TYPE)
    {
        return [NSString stringWithFormat:@"调拨日期:%@",[DateUtils formateTime2:self.sendEndTime]];
    }
    else if (self.billType == RETURN_PAPER_TYPE || self.billType == CLIENT_RETURN_PAPER_TYPE)
    {
       return [NSString stringWithFormat:@"退货日期:%@",[DateUtils formateTime2:self.sendEndTime]];
    }
   return @"";
}

- (NSString *)getName {
    
    if (self.billType == ALLOCATE_PAPER_TYPE)
    {
        //调拨单
        NSString *outShopName = (self.outShopName.length > 5) ? [NSString stringWithFormat:@"%@...",[self.outShopName substringToIndex:5]] : self.outShopName;
        NSString *inShopName = (self.inShopName.length > 5) ? [NSString stringWithFormat:@"%@...",[self.inShopName substringToIndex:5]] : self.inShopName;
        return [NSString stringWithFormat:@"%@-%@",outShopName,inShopName];
    }
    else if (self.billType == CLIENT_ORDER_PAPER_TYPE || self.billType == CLIENT_RETURN_PAPER_TYPE)
    {
       return self.shopName;
    }
    return self.supplyName;
}

- (NSString *)getBillNum {
    return [NSString stringWithFormat:@"单号:%@" ,self.paperNo];
}

- (NSInteger)getBillStatus {
    return self.billStatus;
}
@end
