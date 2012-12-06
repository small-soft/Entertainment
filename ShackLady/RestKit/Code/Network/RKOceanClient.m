//
//  RKOceanClient.m
//  RestKit
//
//  Created by  on 12-8-14.
//  Copyright (c) 2012年 RestKit. All rights reserved.
//

#import "RKOceanClient.h"
#import "RKErrors.h"
@interface RKOceanClient() 

@property (nonatomic,assign) AMTokenState tokenState;

@end

@implementation RKOceanClient

@synthesize delegate = _delegate; 
@synthesize tokenState = _tokenState;
@synthesize isRequestSucess = _isRequestSucess;

- (id)init
{
    self = [super init];
    if (self) {
        _tokenState = AMTokenStateNormal;
        _isRequestSucess = NO;
    }
    return self;
}

-(void)dealloc{
    [_delegate release];
    [super dealloc];
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
    if ([self.delegate respondsToSelector:@selector(request:didLoadResponse:)]) {
        [self.delegate request:request didLoadResponse:response];
    }
    
    NSError *error = nil;
    NSString *errorResponse = nil;
    
    //Use the parsedBody answer in NSDictionary
    
    NSDictionary* oauthResponse = (NSDictionary *) [response parsedBody:&error];
    if ([oauthResponse isKindOfClass:[NSDictionary class]]) {
        
        //Check the if an access token comes in the response
        errorResponse = [oauthResponse objectForKey:@"error_code"];
        if (errorResponse) {
            self.isRequestSucess = NO;
            if ([errorResponse isEqualToString:AM_OCEAN_ERROR_NEED_AUTHENTICATED]) {
                
                if (self.tokenState==AMTokenStateNormal) {
                    
                    self.tokenState = AMTokenStateAccessTokenOutOfDate;
//                    if ([self.delegate respondsToSelector:@selector(OceanClient:didAcessTokenOutOfDate:)]) {
//                        [self.delegate OceanClient:self didAcessTokenOutOfDate:response];
//                    }
                    if ([self.delegate respondsToSelector:@selector(OceanClient:Request:didAcessTokenOutOfDate:)]) {
                        [self.delegate OceanClient:self Request:request didAcessTokenOutOfDate:response];
                    }
                    
                }else if(self.tokenState==AMTokenStateAccessTokenOutOfDate){
                    
                    self.tokenState = AMTokenStateRefreshTokenOutOfDate;
                    if ([self.delegate respondsToSelector:@selector(OceanClient:didRefreshTokenOutOfDate:)]) {
                        [self.delegate OceanClient:self didRefreshTokenOutOfDate:response];
                    }
                    
                }else if(self.tokenState==AMTokenStateRefreshTokenOutOfDate){
                    self.tokenState = AMTokenStateNormal;
                    if ([self.delegate respondsToSelector:@selector(OceanClient:didDonotLogin:)]) {
                        [self.delegate OceanClient:self didDonotLogin:response];
                    }
                    
                }
            }
        }
    } 
}


- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(request:didFailLoadWithError:)]) {
        [self.delegate request:request didFailLoadWithError:error];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects{
    
    self.tokenState = AMTokenStateNormal;
    self.isRequestSucess = YES;
    
    if ([self.delegate respondsToSelector:@selector(objectLoader:didLoadObjects:)]) {
        [self.delegate objectLoader:objectLoader didLoadObjects:objects];
    }
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(objectLoader:didFailWithError:)]) {
        [self.delegate objectLoader:objectLoader didFailWithError:error];
    }
}


@end
