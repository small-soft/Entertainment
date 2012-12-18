//
//  SSSLShakePicLoder.h
//  ShakeLady
//
//  Created by 于 佳 on 12-12-10.
//
//

#import <Foundation/Foundation.h>
@protocol SSSLShakePicLoderDelegate <NSObject>
-(void)SSSLShakePicLoderRequestFinished:(BOOL)isLoadSuccessed;
@end

@interface SSSLShakePicLoder : NSObject
@property (nonatomic, assign) id<SSSLShakePicLoderDelegate> delegate;
@property (nonatomic, retain) NSMutableArray * picMutArray;
@property (nonatomic, retain) NSMutableArray * ladyMutArray;
@property (nonatomic, retain) NSMutableArray * historyPicArray;
+(SSSLShakePicLoder *)sharedInstance;
+(void)sendRequestToGetLadyList;

-(void)nextLady;
@end
