//
//  UITableViewCell+ReuseIdentifier.m
//  Pods
//
//  Created by tripleCC on 10/18/16.
//
//

#import "UITableViewCell+ReuseIdentifier.h"

@implementation UITableViewCell (ReuseIdentifier)
+ (NSString *)tdf_reuseIdentifier {
    return NSStringFromClass(self);
}

+ (UINib *)tdf_nib {
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:[NSBundle mainBundle]];
}
@end
