//
//  SSDQDeliveryCompany.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-13.
//
//

#import <Foundation/Foundation.h>

@interface SSDQDeliveryCompany : NSObject

@property(nonatomic,retain) NSNumber *id;
@property(nonatomic,retain) NSString *code;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *phone;
@property(nonatomic,retain) NSString *site;
@property(nonatomic,retain) NSString *firstLetter;
@property(nonatomic) BOOL isFavorite;

@end
