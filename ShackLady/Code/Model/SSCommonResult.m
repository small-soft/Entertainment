//
//  SSCommonResult.m
//  ShakeLady
//
//  Created by 刘 佳 on 12-12-19.
//
//

#import "SSCommonResult.h"

@implementation SSCommonResult
@synthesize errorCode = _errorCode;
@synthesize result = _result;

+ (RKObjectMapping *)sharedObjectMapping{
    RKObjectMapping* sharedObjectMapping = [RKObjectMapping mappingForClass:[SSCommonResult class]];
    [sharedObjectMapping mapKeyPath:@"result" toAttribute:@"result"];
    [sharedObjectMapping mapKeyPath:@"errorCode" toAttribute:@"errorCode"];
    return sharedObjectMapping;
}

- (void)dealloc
{
    self.errorCode = nil;
    self.result = nil;
    [super dealloc];
}

-(BOOL)isSuccess {
    return [self.result isEqualToString:@"true"];
}
@end
