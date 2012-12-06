//
//  RKOAuthClient.h
//  RestKit
//
//  Created by Rodrigo Garcia on 7/20/11.
//  Copyright (c) 2009-2012 RestKit. All rights reserved.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>
#import "RKClient.h"
//#import "RKObjectLoader.h"

/**
 Defines error codes for OAuth client errors that are returned via a callback
 to RKOAuthClient's delegate
 */
#define AM_OCEAN_ERROR_NEED_AUTHENTICATED @"401"

typedef enum{
    AMTokenStateNormal,
    AMTokenStateAccessTokenOutOfDate,
    AMTokenStateRefreshTokenOutOfDate,
}AMTokenState;

@protocol RKOceanClientDelegate,RKObjectLoaderDelegate; 

@interface RKOceanClient : NSObject <RKObjectLoaderDelegate>{
    id<RKOceanClientDelegate> _delegate;
    BOOL _isRequestSucess;
}
@property (nonatomic, assign) id<RKOceanClientDelegate> delegate;
@property (nonatomic,assign) BOOL isRequestSucess;
@property (nonatomic, retain) RKRequest * request;
@end

@protocol RKOceanClientDelegate <NSObject>

@required

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error;

@optional

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects;

//- (void)OceanClient:(RKOceanClient *)oceanClient didAcessTokenOutOfDate:(RKResponse *)response;

- (void)OceanClient:(RKOceanClient *)oceanClient Request:(RKRequest *) request  didAcessTokenOutOfDate:(RKResponse *)response;


- (void)OceanClient:(RKOceanClient *)oceanClient didRefreshTokenOutOfDate:(RKResponse *)response;

- (void)OceanClient:(RKOceanClient *)oceanClient didDonotLogin:(RKResponse *)response;

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error;
- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response;
@end

