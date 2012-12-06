//
//  SSDBUtils.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-17.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface SSDBUtils : NSObject

-(FMResultSet*)executeQuery:(NSString*)sql;
-(BOOL)executeUpdate:(NSString*)sql;

@end
