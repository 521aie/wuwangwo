//
//  LSNetwrokHelper.m
//  retailapp
//
//  Created by taihangju on 2016/11/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "LSNetwrokHelper.h"
#import "AFNetworking.h"

@implementation LSNetworkModel

@end

@implementation LSNetwrokHelper

- (void)ls_BatchOfRequests:(NSArray<LSNetworkModel *> *)requestModel {
    
   NSArray *operations = [AFHTTPRequestOperation batchOfRequestOperations:@[] progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        ;
    } completionBlock:^(NSArray *operations) {
        ;
    }];
    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
}

- (void)ls_singleOfRequst:(LSNetworkModel *)requesetModel {
    
//    AFHTTPRequestOperation *op = [self httpRequestOpertionWithRequestModel:requesetModel];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [op start];
//    });
}

//- (AFHTTPRequestOperation *)httpRequestOpertionWithRequestModel:(LSNetworkModel *)model {
//    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] init];
//    [op setCompletionBlockWithSuccess:<#^(AFHTTPRequestOperation *operation, id responseObject)success#> failure:<#^(AFHTTPRequestOperation *operation, NSError *error)failure#>];
//    return op;
//}

@end
