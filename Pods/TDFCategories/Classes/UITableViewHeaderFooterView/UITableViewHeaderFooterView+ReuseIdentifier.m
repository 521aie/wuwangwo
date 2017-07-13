//
//  UITableViewHeaderFooterView+ReuseIdentifier.m
//  Pods
//
//  Created by tripleCC on 10/24/16.
//
//

#import "UITableViewHeaderFooterView+ReuseIdentifier.h"

@implementation UITableViewHeaderFooterView (ReuseIdentifier)
+ (NSString *)tdf_reuseIdentifier {
    return NSStringFromClass(self);
}
@end
