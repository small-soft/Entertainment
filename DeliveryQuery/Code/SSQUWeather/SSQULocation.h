//
//  SSQULocation.h
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-28.
//
//

#import <Foundation/Foundation.h>

@interface SSQULocation : NSObject
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *district;
@property (copy, nonatomic) NSString *street;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@end
