//
//  SSUncaughtExceptionService.m
//  DeliveryQuery
//
//  Created by 于 佳 on 12-12-3.
//
//

#import "SSUncaughtExceptionService.h"

void UncaughtExceptionHandler(NSException *exception){
    [SSUncaughtExceptionService catchException:exception];
}

@implementation SSUncaughtExceptionService
static SSUncaughtExceptionService * _sharedInstance = nil;

+ (SSUncaughtExceptionService *) sharedInstance{
    @synchronized(self){
        if (_sharedInstance == nil) {
            _sharedInstance = [[SSUncaughtExceptionService alloc] init];
        }
    }
    return _sharedInstance;
}

+ (void) setDefaultHandler
{
    
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

+ (void) catchException:(NSException *)exception{
    [[SSUncaughtExceptionService sharedInstance] printLog:exception];
}

-(void)printLog:(NSException*)exception{
    NSArray *detail = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *cause = [NSString stringWithFormat:@"name:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[detail componentsJoinedByString:@"\n"]];
    
    NSLog(@"exception cause is \n%@",cause);
}
@end
