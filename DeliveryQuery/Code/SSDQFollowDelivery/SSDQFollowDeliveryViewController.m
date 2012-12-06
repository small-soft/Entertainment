//
//  SSDQFollowDeliveryViewController.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-30.
//
//

#import "SSDQFollowDeliveryViewController.h"
#import "SSToastView.h"
#import "FMDatabase.h"
#import "SSQUAppDelegate.h"
#import "SSDQDeliveryQueryResult.h"
#import "SSDQMyDeliveryViewController.h"
#import "SSDQDeliveryQueryResultViewController.h"

@interface SSDQFollowDeliveryViewController ()
@property(nonatomic,retain) IBOutlet UITableView *contentTable;
@property(nonatomic,retain) NSMutableArray *data;

@end

@implementation SSDQFollowDeliveryViewController
@synthesize contentTable = _contentTable;
@synthesize data = _data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc {
    self.contentTable = nil;
    self.data = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    
    self.contentTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:GRAY_BG]];
    [self initRightBtn];
    
    [self loadDB];
}

-(void)viewWillAppear:(BOOL)animated {
    // 更新数清零
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.data count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    SSDQDeliveryResult *result =  [self.data objectAtIndex:section];
    NSMutableString *str = [NSMutableString stringWithCapacity:50];
    if (result.comment.length > 0) {
        [str appendFormat:@"[%@]",result.comment];
    }else {
        [str appendFormat:@"[无备注]"];
    }
    [str appendFormat:@"\n%@-%@:%@",result.expTextName,result.mailNo,[result getStatusDescription]];
    
    return str;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SSDQFDC"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SSDQFDC"]autorelease];
    }
    
    SSDQDeliveryResult *result = [self.data objectAtIndex:indexPath.section];
    SSDQDeliveryItem *item = [result.data objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.time;
    cell.detailTextLabel.text = item.context;
    cell.detailTextLabel.numberOfLines = 2;
    
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44. + 15.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SSDQDeliveryResult *result = [self.data objectAtIndex:section];
    return result.data.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SSDQDeliveryResult *result = [self.data objectAtIndex:indexPath.section];
    
    SSDQDeliveryQueryResultViewController *dqr = [[[SSDQDeliveryQueryResultViewController alloc]init]autorelease];
    dqr.title = @"快递详情";
    if (result.comment.length > 0) {
        dqr.title = result.comment;
    }
    
    
    dqr.companyCode = result.expSpellName;
    dqr.deliveryNumber = result.mailNo;
    
    [self.navigationController pushViewController:dqr animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)loadDB{
    self.data = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase *db = GETDB;
    if ([db open]) {
        NSString *sql = @"SELECT * from DeliveryQueryHistoryMain where hasUpdate = 1 order by id desc";
        
        NSLog(@"execute sql:%@",sql);
        
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            
            SSDQDeliveryResult *result = [[[SSDQDeliveryResult alloc]init]autorelease];
            result.id = [rs intForColumn:@"id"];
            result.expTextName = [rs stringForColumn:@"companyName"];
            result.expSpellName = [rs stringForColumn:@"companyCode"];
            result.mailNo = [rs stringForColumn:@"deliveryNumber"];
            result.status = [rs intForColumn:@"status"];
            result.latestContext = [rs stringForColumn:@"latestContext"];
            result.sendTime = [rs stringForColumn:@"sendTime"];
            result.signTime = [rs stringForColumn:@"signTime"];
            result.companyPhone = [rs stringForColumn:@"companyPhone"];
            result.comment = [rs stringForColumn:@"comment"];
            
            // items
            FMResultSet *items = [db executeQuery:[NSString stringWithFormat:@"SELECT * from DeliveryQueryHistoryItems where mainId = %d and hasUpdate = 1 order by id DESC",result.id]];
            
            result.data = [NSMutableArray arrayWithCapacity:[items columnCount]];
            while ([items next]) {
                SSDQDeliveryItem *item = [[[SSDQDeliveryItem alloc]init]autorelease];
                item.time = [items stringForColumn:@"time"];
                item.context = [items stringForColumn:@"context"];
                
                [result.data addObject:item];
            }
                        
            [self.data addObject:result];
        }
        
        if (self.data != nil && self.data.count > 0) {
            //表示已读
            NSString *updateSql = @"UPDATE DeliveryQueryHistoryMain set hasUpdate = 0";
            NSLog(@"execute sql:%@",updateSql);
            [db executeUpdate:updateSql];
            
            updateSql = @"UPDATE DeliveryQueryHistoryItems set hasUpdate = 0";
            NSLog(@"execute sql:%@",updateSql);
            [db executeUpdate:updateSql];
            
            // 更新数清零
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }else{
            [self.loadingView showNoDataView];
        }
        
    }
    
    
    [db close];
}

-(void) initRightBtn {
    
    UIBarButtonItem * infoButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"全部快递" style:UIBarButtonItemStylePlain target:self action:@selector(addBtnPress)]autorelease];
    
    self.navigationItem.rightBarButtonItem = infoButtonItem ;
}

-(void)addBtnPress {
    SSDQMyDeliveryViewController *controller = [[[SSDQMyDeliveryViewController alloc]init]autorelease];
    //    controller.company = self.company;
    controller.navigationItem.title = @"我的快递";
    [self.navigationController pushViewController:controller animated:YES];
}
@end
