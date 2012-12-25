//
//  SSCommonResult.h
//  ShakeLady
//
//  Created by 刘 佳 on 12-12-19.
//
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface SSCommonResult:NSObject
+ (RKObjectMapping *)sharedObjectMapping;
@property (nonatomic, retain) NSString * result;
@property (nonatomic, retain) NSString * errorCode;

-(BOOL) isSuccess;
@end
