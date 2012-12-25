//
//  SSSLLadyListResult.h
//  ShakeLady
//
//  Created by 于 佳 on 12-12-7.
//
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "HJManagedImageV.h"

@interface SSSLLadyPic:NSObject
+ (RKObjectMapping *)sharedObjectMapping;
@property (nonatomic, retain) NSNumber * picId;
@property (nonatomic) float rate;
@property (nonatomic, retain) HJManagedImageV * imageView;
@end

@interface SSSLLadyListResult : NSObject
+ (RKObjectMapping *)sharedObjectMapping;
@property (nonatomic, retain) NSMutableArray * dataList;
@property (nonatomic, retain) NSNumber * result;
@end
