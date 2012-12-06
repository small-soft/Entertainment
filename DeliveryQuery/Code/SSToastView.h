//
//  AliToastVew.h
//  AlibabaMobile
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const int TOAST_STYLE_COMMON;
extern const int TOAST_STYLE_SUCC;
extern const int TOAST_STYLE_FAIL;
extern const int TOAST_STYLE_FAV;

@interface SSToastView : UIView

+ (SSToastView *)MakeToastWithType:(int)type info:(NSString *)text;
- (void) show;
- (void) showAllTime ;
@end
