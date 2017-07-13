//
//  UICollectionReusableView+ReuseIndentifier.m
//  DHTTableViewManager
//
//  Created by tripleCC on 12/10/16.
//  Copyright © 2016 tripleCC. All rights reserved.
//

#import "UICollectionReusableView+ReuseIndentifier.h"

@implementation UICollectionReusableView (ReuseIndentifier)
+ (NSString *)tdf_reuseIdentifier {
    return NSStringFromClass(self);
}
@end
