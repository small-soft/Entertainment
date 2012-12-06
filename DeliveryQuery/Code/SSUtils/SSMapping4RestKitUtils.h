//
//  SSMapping4RestKitUtils.h
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-3.
//
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
@interface SSMapping4RestKitUtils : NSObject
+(id)performMappingWithMapping:(RKObjectMappingDefinition*)configuredObjectMapping forXmlString:(NSString*)xmlString;
+(id)performMappingWithMapping:(RKObjectMappingDefinition*)configuredObjectMapping forXmlString:(NSString*)xmlString usingEncoding:(NSStringEncoding)encoding;
+(id)performMappingWithMapping:(RKObjectMappingDefinition*)configuredObjectMapping forJsonString:(NSString*)jsonString;
@end
