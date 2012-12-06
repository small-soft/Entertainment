//
//  SSDQDeliveryQueryResult.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-13.
//
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

typedef NS_ENUM(NSInteger, SSDQDeliveryResultStatus)
{
    //0：在途中,1：已发货，2：疑难件，3： 已签收 ，4：已退货
    SSDQDeliveryResultStatusSending = 0,
    SSDQDeliveryResultStatusSended,
    SSDQDeliveryResultStatusHard,
    SSDQDeliveryResultStatusSigned,
    SSDQDeliveryResultStatusSendBack,
    SSDQDeliveryResultStatusFailed = 99,
};


//0：运单暂无结果，1：查询成功，2：接口出现异常
typedef NS_ENUM(NSInteger, SSDQDeliveryResultErrorCode) {
    SSDQDeliveryResultErrorCodeNumberNotExist = 0,
    SSDQDeliveryResultErrorCodeNoError,
    SSDQDeliveryResultErrorCodeInterfaceError,
    
};

@interface SSDQDeliveryItem : NSObject
@property (nonatomic,copy) NSString * time;
@property (nonatomic,copy) NSString * context;
+ (RKObjectMapping *)sharedObjectMapping;
@end


@interface SSDQDeliveryResult : NSObject
@property (nonatomic, retain) NSMutableArray* data;
@property (nonatomic) SSDQDeliveryResultStatus status;
@property (nonatomic) SSDQDeliveryResultErrorCode errCode;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, copy) NSString *expTextName;
@property (nonatomic, copy) NSString *expSpellName;
@property (nonatomic, copy) NSString *mailNo;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic) NSInteger id;
@property (nonatomic,retain) NSString *sendTime;
@property (nonatomic,retain) NSString *signTime;
@property (nonatomic,retain) NSString *latestContext;
@property (nonatomic,retain) NSString *companyPhone;
+ (RKObjectMapping *)sharedObjectMapping;

-(NSString*) getStatusDescription;
-(NSString*) getErrorDescription;
@end
