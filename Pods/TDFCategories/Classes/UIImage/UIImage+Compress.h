//
//  UIImage+Resize.h
//  TDFCategories
//
//  Created by tripleCC on 3/21/17.
//  Copyright © 2017 tripleCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)
- (NSData *)tdf_dataWithCompressKB:(NSInteger)kb;
@end
