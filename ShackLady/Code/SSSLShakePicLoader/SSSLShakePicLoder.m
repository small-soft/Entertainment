//
//  SSSLShakePicLoder.m
//  ShakeLady
//
//  Created by 于 佳 on 12-12-10.
//
//

#import "SSSLShakePicLoder.h"
#import <RestKit/RestKit.h>
#import "HJManagedImageV.h"
#import "HJObjManager.h"
#import "SSMapping4RestKitUtils.h"
#import "SSSLLadyListResult.h"
#import "FMDatabase.h"
#import "SSSLAppDelegate.h"

@interface SSSLShakePicLoder() <RKRequestDelegate>

@end

@implementation SSSLShakePicLoder
@synthesize picMutArray = _picMutArray;
@synthesize ladyMutArray = _ladyMutArray;
@synthesize delegate = _delegate;
@synthesize historyPicArray = _historyPicArray;
static SSSLShakePicLoder * _sharedInstance = nil;
+(SSSLShakePicLoder *)sharedInstance{
    @synchronized(self){
        if (_sharedInstance == nil) {
            _sharedInstance = [[SSSLShakePicLoder alloc] init];
        }
    }
    return _sharedInstance;
}

+(void)sendRequestToGetLadyList{
    [[SSSLShakePicLoder sharedInstance] sendRequestToGetLadyList];
}

-(NSMutableArray *)historyPicArray{
    if (_historyPicArray==nil) {
        _historyPicArray = [[NSMutableArray alloc] init];
    }
    return _historyPicArray;
}

-(NSMutableArray *)picMutArray{
    if (_picMutArray == nil) {
        _picMutArray = [[NSMutableArray alloc] init];
    }
    return _picMutArray;
}

-(NSMutableArray *)ladyMutArray{
    if (_ladyMutArray == nil) {
        _ladyMutArray = [[NSMutableArray alloc] init];
    }
    return _ladyMutArray;
}
-(void)sendRequestToGetLadyList{
    RKClient *client = [RKClient sharedClient];
    [client get:@"favorites/json/shakeLady.json?operation=shake&userType=AISOUCANG&userName=aisoucang" delegate:self];
}
-(void)dealloc{
    self.picMutArray = nil;
    self.ladyMutArray = nil;
    self.historyPicArray = nil;
    [super dealloc];
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(SSSLShakePicLoderRequestFinished:)]) {
        [self.delegate SSSLShakePicLoderRequestFinished:NO];
    }
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"response %@", [response bodyAsString]);
    SSSLLadyListResult * ladyListResult = [SSMapping4RestKitUtils performMappingWithMapping:[SSSLLadyListResult sharedObjectMapping] forJsonString:[response bodyAsString]];
    HJObjManager * objManager = [HJObjManager sharedManager];
    for (SSSLLadyPic * ladyPic in ladyListResult.dataList) {
        HJManagedImageV * imageV = [[HJManagedImageV alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        imageV.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://static.aisoucang.com/upload/shakeLady/%d.jpg",[ladyPic.picId integerValue]]];
        [objManager manage:imageV];
        [self.picMutArray addObject:imageV];
        [imageV release];
        
        [self.ladyMutArray addObject:ladyPic];
    }
    if ([self.delegate respondsToSelector:@selector(SSSLShakePicLoderRequestFinished:)]) {
        [self.delegate SSSLShakePicLoderRequestFinished:YES];
    }

}

-(void)nextLady{
    [self saveLady];
    
    // pop
    [self.picMutArray removeObjectAtIndex:0];
    [self.ladyMutArray removeObjectAtIndex:0];
}

-(void)saveLady{
    FMDatabase *db = GETDB;
    if ([db open]) {
        
        SSSLLadyPic *lady = [self.ladyMutArray objectAtIndex:0];
        
        NSString *sqlInsert = [NSString stringWithFormat: @"INSERT INTO SLMyLady(ladyId,date) values(%d,%f)",[lady.picId integerValue],[[NSDate date] timeIntervalSince1970]];
        
        NSLog(@"sql:%@",sqlInsert);
        
        [NSDate timeIntervalSinceReferenceDate];
        
        NSLog(@"inertResult:%d",[db executeUpdate:sqlInsert]);
    }
    
    [db close];
}
@end
