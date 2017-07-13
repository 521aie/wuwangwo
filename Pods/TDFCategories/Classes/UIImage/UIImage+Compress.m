//
//  UIImage+Resize.m
//  TDFCategories
//
//  Created by tripleCC on 3/21/17.
//  Copyright © 2017 tripleCC. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)
- (NSData *)tdf_dataWithCompressKB:(NSInteger)kb {
    CGFloat compressionQuality = 1;
    NSData *imageData = UIImageJPEGRepresentation(self, 1);
    while (imageData.length > 1024 * kb) {
        if (compressionQuality < 0) {
            break;
        }
        imageData = UIImageJPEGRepresentation(self, compressionQuality);
        compressionQuality -= 0.1;
    }
    return imageData;
}
@end
