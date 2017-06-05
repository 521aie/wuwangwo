//
//  KeyBoardBar.h
//  CardApp
//
//  Created by 邵建青 on 13-12-23.
//  Copyright (c) 2013年 ZMSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyBoardBarClient <NSObject>

- (void)hideKeyBorad;

@end

@interface KeyBoardBar : UIView
{
    id<KeyBoardBarClient> keyBoardBarClient;
}

- (id)initWithFrame:(CGRect)frame client:(id<KeyBoardBarClient>)client;
@end



