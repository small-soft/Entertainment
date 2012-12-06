//
//  RKXMLParserXMLReader.m
//  RestKit
//
//  Created by Christopher Swasey on 1/24/12.
//  Copyright (c) 2012 GateGuru. All rights reserved.
//

#import "RKXMLParserXMLReader.h"

@implementation RKXMLParserXMLReader

- (id)objectFromString:(NSString*)string error:(NSError**)error {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [string dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    return [XMLReader dictionaryForXMLData:data error:error];
}

-(id)objectFromString:(NSString *)string error:(NSError **)error usingEncoding:(NSStringEncoding)encoding{
    NSData *data = [string dataUsingEncoding:encoding];
    return [XMLReader dictionaryForXMLData:data error:error];
}
- (NSString*)stringFromObject:(id)object error:(NSError**)error {
    return nil;
}

@end
