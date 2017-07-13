//
//  UICollectionViewCell+ReuseIdentifier.m
//  Pods
//
//  Created by tripleCC on 11/21/16.
//
//

#import "UICollectionViewCell+ReuseIdentifier.h"

@implementation UICollectionViewCell (ReuseIdentifier)
+ (NSString *)tdf_reuseIdentifier {
    return NSStringFromClass(self);
}
@end
