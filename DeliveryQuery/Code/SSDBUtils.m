//
//  SSDBUtils.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-17.
//
//

#import "SSDBUtils.h"

@interface SSDBUtils()
@property(nonatomic,retain)FMDatabase *db;

@end

@implementation SSDBUtils
@synthesize db = _db;

-(id)init {
    if (self = [super init]) {
       [self initDB]; 
    }
    
    return self;
}

-(void)initDB {
    if (_db == nil) {
        self.db = [FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:@"DeliveryQueryDB" ofType:@"sqlite" ]];
    }
}

-(FMResultSet *)executeQuery:(NSString *)sql {
    
    if ([self.db open]) {
        return [self.db executeQuery:sql];
    }
    
    return nil;
}

-(BOOL)executeUpdate:(NSString *)sql {
    if ([self.db open]) {
        return [self.db executeUpdate:sql];
    }
    
    return NO;
}

-(void)dealloc {
    [_db close];
    [_db release];
    
    [super dealloc];
}

@end
