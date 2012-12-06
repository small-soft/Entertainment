//
//  SSDQDeliveryQueryResult.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-13.
//
//

#define COMMON_ERROR_DESCRIPTION @"系统错误，请稍后再试！"

#import "SSDQDeliveryQueryResult.h"

@implementation SSDQDeliveryItem
@synthesize context = _context;
@synthesize time = _time;
+ (RKObjectMapping *)sharedObjectMapping {
//        static RKObjectMapping* sharedObjectMapping;
    //
//        @synchronized (self) {
//        if (!sharedObjectMapping) {
    RKObjectMapping * sharedObjectMapping;
    sharedObjectMapping = [RKObjectMapping mappingForClass:[SSDQDeliveryItem class]] ;
    
    [sharedObjectMapping mapKeyPath:@"context" toAttribute:@"context"];
    [sharedObjectMapping mapKeyPath:@"time" toAttribute:@"time"];
    
//        }
//    }
    return sharedObjectMapping;
}
- (void)dealloc
{
    self.time = nil;
    self.context = nil;
    [super dealloc];
}

@end

@interface SSDQDeliveryResult()
@property (nonatomic,retain) NSArray *statusDescriptions;
@property (nonatomic,retain) NSArray *errorDescriptions;
@end

@implementation SSDQDeliveryResult

@synthesize data = _data;
@synthesize errCode = _errCode;
@synthesize expSpellName = _expSpellName;
@synthesize expTextName = _expTextName;
@synthesize status = _status;
@synthesize mailNo = _mailNo;
@synthesize id;
@synthesize comment = _comment;
@synthesize message = _message;
@synthesize statusDescriptions = _statusDescriptions;
@synthesize errorDescriptions = _errorDescriptions;
@synthesize latestContext = _latestContext;
@synthesize sendTime = _sendTime;
@synthesize signTime = _signTime;
@synthesize companyPhone = _companyPhone;

+ (RKObjectMapping *)sharedObjectMapping {
//    static RKObjectMapping* sharedObjectMapping;
    //
//    @synchronized (self) {
    RKObjectMapping * sharedObjectMapping;
//        if (!sharedObjectMapping) {
    sharedObjectMapping = [RKObjectMapping mappingForClass:[SSDQDeliveryResult class]] ;
    
    [sharedObjectMapping mapKeyPath:@"status" toAttribute:@"errCode"];
    [sharedObjectMapping mapKeyPath:@"com" toAttribute:@"expSpellName"];
//    [sharedObjectMapping mapKeyPath:@"expTextName" toAttribute:@"expTextName"];
    [sharedObjectMapping mapKeyPath:@"state" toAttribute:@"status"];
    [sharedObjectMapping mapKeyPath:@"nu" toAttribute:@"mailNo"];
    [sharedObjectMapping mapKeyPath:@"message" toAttribute:@"message"];
    
    [sharedObjectMapping mapRelationship:@"data" withMapping:[SSDQDeliveryItem sharedObjectMapping]];
//    sharedObjectMapping.rootKeyPath =@"response";
//            }
//        }
    
    return sharedObjectMapping;
}
- (void)dealloc
{
    self.comment = nil;
    self.data = nil;
//    self.errCode = nil;
//    self.status =nil;
    self.expSpellName = nil;
    self.expTextName = nil;
    self.mailNo = nil;
    self.message = nil;
    self.errorDescriptions = nil;
    self.statusDescriptions = nil;
    self.companyPhone = nil;
    self.sendTime = nil;
    self.latestContext = nil;
    self.signTime = nil;
    [super dealloc];
}

-(NSString *)getErrorDescription {
    
    if (_errorDescriptions == nil) {
        //0：运单暂无结果，1：查询成功，2：接口出现异常
        
        self.errorDescriptions = [NSArray arrayWithObjects:@"快递单号不存在",@"成功",@"系统错误，请稍后再试", nil];
    }
    
    if (self.errCode >= [self.errorDescriptions count]) {
        return @"快递单号不存在";
    }
    
    return [self.errorDescriptions objectAtIndex:self.errCode];
    
}

-(NSString *)getStatusDescription {
    if (_statusDescriptions == nil) {
        //0：在途中,1：已发货，2：疑难件，3： 已签收 ，4：已退货
        self.statusDescriptions = [NSArray arrayWithObjects:@"在途中",@"已发货",@"疑难件",@"已签收",@"已退回", nil];
    }
    
    if (self.status >= [self.statusDescriptions count]) {
        return @"暂无结果";
    }
    
    return [self.statusDescriptions objectAtIndex:self.status];
}

@end

