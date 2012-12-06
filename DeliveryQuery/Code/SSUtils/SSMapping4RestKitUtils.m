//
//  SSMapping4RestKitUtils.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-3.
//
//

#import "SSMapping4RestKitUtils.h"

@implementation SSMapping4RestKitUtils
+(id)performMappingWithMapping:(RKObjectMappingDefinition*)configuredObjectMapping forXmlString:(NSString*)xmlString{

    return [SSMapping4RestKitUtils performMappingWithMapping:configuredObjectMapping forString:xmlString parseForMIMEType:RKMIMETypeXML usingEncoding:NSUTF8StringEncoding];
}

+(id)performMappingWithMapping:(RKObjectMappingDefinition*)configuredObjectMapping forXmlString:(NSString*)xmlString usingEncoding:(NSStringEncoding)encoding{

    return [SSMapping4RestKitUtils performMappingWithMapping:configuredObjectMapping forString:xmlString parseForMIMEType:RKMIMETypeXML usingEncoding:encoding];;
}

+(id)performMappingWithMapping:(RKObjectMappingDefinition*)configuredObjectMapping forJsonString:(NSString*)jsonString{
    
    return [SSMapping4RestKitUtils performMappingWithMapping:configuredObjectMapping forString:jsonString parseForMIMEType:RKMIMETypeJSON usingEncoding:NSUTF8StringEncoding];
}


+(id)performMappingWithMapping:(RKObjectMappingDefinition*)configuredObjectMapping forString:(NSString*)string parseForMIMEType:(NSString*)RKMIMETYPE usingEncoding:(NSStringEncoding)encoding{
    RKObjectMappingProvider * mappingProvider = [RKObjectMappingProvider mappingProvider];
    NSString *rootKeyPath = configuredObjectMapping.rootKeyPath ? configuredObjectMapping.rootKeyPath : @"";
    [mappingProvider setMapping:configuredObjectMapping forKeyPath:rootKeyPath];
    NSError * error = nil;

    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETYPE];
    id parsedData = nil;
    if ([RKMIMETYPE isEqualToString:RKMIMETypeXML]) {
        parsedData = [parser objectFromString:string error:&error usingEncoding:encoding];
    }else{
        parsedData = [parser objectFromString:string error:&error];
    }
     
    if (parsedData == nil && error) {
        return nil;
    }

    RKObjectMapper * mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:mappingProvider];
    RKObjectMappingResult * result = [mapper performMapping];
    if (result) {
        return [result asObject];
    }
    return nil;
    
}

@end
