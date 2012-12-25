//
//  SSSLLadyListResult.m
//  ShakeLady
//
//  Created by 于 佳 on 12-12-7.
//
//

#import "SSSLLadyListResult.h"

@implementation SSSLLadyPic
@synthesize picId = _picId;
@synthesize imageView = _imageView;
@synthesize rate = _rate;
+ (RKObjectMapping *)sharedObjectMapping{
    RKObjectMapping* sharedObjectMapping = [RKObjectMapping mappingForClass:[SSSLLadyPic class]];
    [sharedObjectMapping mapKeyPath:@"id" toAttribute:@"picId"];
    [sharedObjectMapping mapKeyPath:@"rate" toAttribute:@"rate"];
    
    return sharedObjectMapping;
}

- (void)dealloc
{
    self.picId = nil;
    self.imageView = nil;
    [super dealloc];
}
@end

@implementation SSSLLadyListResult
@synthesize dataList = _dataList;
@synthesize result = _result;
+ (RKObjectMapping *)sharedObjectMapping{
    RKObjectMapping* sharedObjectMapping = [RKObjectMapping mappingForClass:[SSSLLadyListResult class]];
    [sharedObjectMapping mapRelationship:@"dataList" withMapping:[SSSLLadyPic sharedObjectMapping]];
    [sharedObjectMapping mapKeyPath:@"result" toAttribute:@"result"];
    return sharedObjectMapping;
}
- (void)dealloc
{
    self.dataList = nil;
    self.result = nil;
    [super dealloc];
}
@end
