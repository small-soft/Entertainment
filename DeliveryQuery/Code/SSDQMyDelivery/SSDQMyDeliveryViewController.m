//
//  SSDQMyDeliveryViewController.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-18.
//
//

#import "SSDQMyDeliveryViewController.h"
#import "FMDatabase.h"
#import "SSQUAppDelegate.h"
#import "SSDQDeliveryQueryResultViewController.h"
#import "SSDQDeliveryQueryResult.h"
#import "SSDQMyDeliveryCell.h"
#import "SSDQDeliveryQueryViewController.h"

@interface SSDQMyDeliveryViewController ()

@property(nonatomic,retain) IBOutlet UITableView *contentTable;
@property(nonatomic,retain) NSMutableArray *data;
@property(nonatomic) BOOL hasUpdate;

-(IBAction)changeStatus:(UISegmentedControl*)sender;
@end

@implementation SSDQMyDeliveryViewController
@synthesize contentTable = _contentTable;
@synthesize data = _data;
@synthesize statusArray = _statusArray;
@synthesize hasUpdate = _hasUpdate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    self.contentTable = nil;
    self.data = nil;
    self.statusArray = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initRightBtn];
    
    self.hasUpdate = NO;
    self.statusArray = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self loadDB];
    [self.contentTable reloadData];
    [super viewWillAppear:animated];
}

-(void)loadDB{
    self.data = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase *db = GETDB;
    if ([db open]) {
        NSMutableString *sql = [NSMutableString stringWithString: @"SELECT * from DeliveryQueryHistoryMain"];
        
        if (self.hasUpdate) {
            [sql appendString: @" where hasUpdate=1 "];
        }else if (self.statusArray && [self.statusArray count] >0) {
            [sql appendString: @" where 1=1 "];
            
            for (int i=0; i<[self.statusArray count]; i++) {
                NSString *andOr = @"or";
                if (i == 0) {
                    andOr = @"and";
                }
                
                SSDQDeliveryResultStatus s = [(NSNumber*)[self.statusArray objectAtIndex:i] intValue];
                [sql appendFormat:@" %@ status = %d",andOr,s];
            }
        }
        
        [sql appendString:@" order by id desc"];
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
            
            [self.data addObject:result];
        }
    }
    
    if (self.data == nil || self.data.count <= 0) {
        [self.loadingView hasToolBar];
        [self.loadingView showNoDataView];
    }else{
        [self.loadingView hideNoDataView];
    }
    
    [db close];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSDQMyDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:[SSDQMyDeliveryCell cellIdentifer]];
    
    if (cell == nil) {
        cell = [SSDQMyDeliveryCell createCell:nil];
    }
    
//    cell.backgroundView.backgroundColor = [UIColor whiteColor];
//    cell.backgroundView.alpha = 1;
//    if (indexPath.row%2 == 0) {
//        
//        cell.backgroundView.backgroundColor = [UIColor grayColor];
////        cell.backgroundView.alpha = 0.1;
//    }
    
    cell.result = [self.data objectAtIndex:indexPath.row];
    [cell setupView];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SSDQDeliveryResult *result = [self.data objectAtIndex:indexPath.row];
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SSDQMyDeliveryCell cellHeight];
}

-(void)changeStatus:(UISegmentedControl *)sender {
    self.statusArray = nil;
    self.hasUpdate = NO;
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            
            break;
            
        case 1:
            self.statusArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:SSDQDeliveryResultStatusSending],[NSNumber numberWithInteger:SSDQDeliveryResultStatusSended], nil];
            break;
        case 2:
            self.statusArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:SSDQDeliveryResultStatusSigned], nil];
            break;
        case 3:
            self.statusArray = nil;
            self.hasUpdate = YES;
            break;
        default:
            break;
    }
    
    [self reloadData];
}

-(void)reloadData {
    [self loadDB];
    [self.contentTable reloadData];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SSDQDeliveryResult *delData =  [self.data objectAtIndex:indexPath.row];
        [self delData:delData.id];
        
        [self loadDB];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.contentTable reloadData];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)delData:(int)mainId {
    FMDatabase *db = GETDB;
    
    if ([db open]) {
        NSString *delMainSql = [NSString stringWithFormat:@"delete from  DeliveryQueryHistoryMain where id = %d",mainId];
        [db executeUpdate:delMainSql];
        
        
        NSString *delItemsSql = [NSString stringWithFormat:@"delete from  DeliveryQueryHistoryItems where mainId = %d",mainId];
        [db executeUpdate:delItemsSql];
        
    }
    
    [db close];
}

-(void) initRightBtn {
    
    UIBarButtonItem * infoButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStylePlain target:self action:@selector(addBtnPress)]autorelease];
    
    self.navigationItem.rightBarButtonItem = infoButtonItem ;
}

-(void)addBtnPress {
    SSDQDeliveryQueryViewController *controller = [[[SSDQDeliveryQueryViewController alloc]init]autorelease];
//    controller.company = self.company;
    controller.navigationItem.title = @"快递查询";
    [self.navigationController pushViewController:controller animated:YES];
}
@end
