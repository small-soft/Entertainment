//
//  SSUncaughtExceptionService.h
//  DeliveryQuery
//
//  Created by 于 佳 on 12-12-3.
//
//

#import <Foundation/Foundation.h>

@interface SSUncaughtExceptionService : NSObject
+ (SSUncaughtExceptionService*) sharedInstance;
+ (void)catchException:(NSException*)exception;
+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler*) getHandler;
@end
