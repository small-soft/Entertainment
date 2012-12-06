//
//  SSDQDeliveryCompany.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-13.
//
//

#import "SSDQDeliveryCompany.h"

@implementation SSDQDeliveryCompany

@synthesize code = _code;
@synthesize firstLetter = _firstLetter;
@synthesize id = _id;
@synthesize isFavorite = _isFavorite;
@synthesize name = _name;
@synthesize phone = _phone;
@synthesize site = _site;

-(void)dealloc {
    [_code release];
    [_firstLetter release];
    [_id release];
    [_name release];
    [_phone release];
    [_site release];
    
    [super dealloc];
}

@end
