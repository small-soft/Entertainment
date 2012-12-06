//
//  SSDQAllDeliveryCompanyListViewController.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-10.
//
//

#import "SSDQAllDeliveryCompanyListViewController.h"
#import "FMDatabase.h"
#import "SSDQDeliveryCompany.h"
#import "SSDQDeliveryCompanyListCell.h"
#import "SSDQDeliveryQueryViewController.h"
#import "SSQUAppDelegate.h"
#import "SSDQCompanyDetailViewController.h"

@interface SSDQAllDeliveryCompanyListViewController ()

#pragma mark -
#pragma mark ib
@property(nonatomic,retain) IBOutlet UITableView *contentTable;

#pragma mark -
#pragma mark attr
@property(nonatomic,retain) NSArray *keys;
@property(nonatomic,retain) NSMutableDictionary *sectionData;

@end

@implementation SSDQAllDeliveryCompanyListViewController
@synthesize contentTable = _contentTable;
@synthesize displayMode = _displayMode;
@synthesize contentMode = _contentMode;
@synthesize sectionData = _sectionData;
@synthesize keys = _keys;

-(void)dealloc{
    self.contentTable = nil;
    self.keys = nil;
    self.sectionData = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *title = @"只显示常用";
    self.title = @"全部快递";
    if (self.contentMode == DeliverCompanyListContentModeFavOnly) {
        title = @"显示全部";
        self.title = @"常用快递";
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(switchContent)];
    
    [self loadDB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadDB{
    self.sectionData = [NSMutableDictionary dictionaryWithCapacity:26];
    NSString *firstLetter = @"a";
    NSMutableArray *aLetter = [NSMutableArray arrayWithCapacity:10];
    
    [self.sectionData setObject:aLetter forKey:firstLetter];
    
    FMDatabase *db = GETDB;
    if ([db open]) {
        NSMutableString *sql = [NSMutableString stringWithString: @"SELECT * from DeliveryCompany"];
        if (self.contentMode == DeliverCompanyListContentModeFavOnly) {
            [sql appendString:@" where isFavorite = 1"];
        }
        
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            SSDQDeliveryCompany *company = [[[SSDQDeliveryCompany alloc]init]autorelease];
            company.name = [[rs stringForColumn:@"name"] copy];
            company.code = [[rs stringForColumn:@"code"] copy];
            company.isFavorite = [rs intForColumn:@"isFavorite"] > 0;
            company.site = [[rs stringForColumn:@"site"] copy];
            company.phone = [[rs stringForColumn:@"phone"] copy];
            company.id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
            company.firstLetter = [[rs stringForColumn:@"firstLetter"] copy];
            
            if ([company.firstLetter isEqualToString:firstLetter]) {
                NSMutableArray *companyArray =  [self.sectionData objectForKey:firstLetter];
                [companyArray addObject:company];
            }else {
                firstLetter = company.firstLetter;
                
                NSMutableArray *companyArray = [NSMutableArray arrayWithCapacity:10];
                [companyArray addObject:company];
                
                [self.sectionData setObject:companyArray forKey:firstLetter];
            }
            
//            [self.data addObject:company];
        }
        
        self.keys = [[self.sectionData allKeys]sortedArrayUsingSelector:@selector(compare:)];
    }
    
    
    [db close];
}

#pragma mark -
#pragma mark table delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSDQDeliveryCompanyListCell *cell = [tableView dequeueReusableCellWithIdentifier:[SSDQDeliveryCompanyListCell cellIdentifer]];
    if (cell == nil) {
        cell = [SSDQDeliveryCompanyListCell createCell:nil];
        if (cell.backgroundView == nil) {
            cell.backgroundView = [[[UIView alloc]init]autorelease];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.backgroundView.backgroundColor = [UIColor whiteColor];
    cell.backgroundView.alpha = 1;
    if (indexPath.row%2 == 0) {
        
        cell.backgroundView.backgroundColor = [UIColor grayColor];
        cell.backgroundView.alpha = 0.1;
    }
    
    NSString *key =  [self.keys objectAtIndex:indexPath.section];
    NSArray *companys =  [self.sectionData objectForKey:key];
    
    cell.company = [companys objectAtIndex:indexPath.row];
    [cell setupView];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key =  [self.keys objectAtIndex:section];
    NSArray *companys =  [self.sectionData objectForKey:key];
    
    return companys!=nil?[companys count]:0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.displayMode) {
        case 0:{
            SSDQCompanyDetailViewController *detail = [[[SSDQCompanyDetailViewController alloc]init]autorelease];
            
            NSString *key =  [self.keys objectAtIndex:indexPath.section];
            NSArray *companys =  [self.sectionData objectForKey:key];
            
            detail.company = [companys objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:detail animated:YES];
        }
            
            break;
        case 1:{
            NSInteger i = [[self.navigationController viewControllers] count] -2;
            SSDQDeliveryQueryViewController *qv = [[self.navigationController viewControllers] objectAtIndex:i];
            
            NSString *key =  [self.keys objectAtIndex:indexPath.section];
            NSArray *companys =  [self.sectionData objectForKey:key];
            qv.company = [companys objectAtIndex:indexPath.row];
            
            float version = [[[UIDevice currentDevice] systemVersion] floatValue];
            
            if (version < 5.0) {
                [qv viewWillAppear:YES];
            }
            
            [self.navigationController popToViewController:qv animated:YES];
        }
            
            break;
        default:
            break;
    }
}

-(void)switchContent {
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"只显示常用"]) {
        self.contentMode = DeliverCompanyListContentModeFavOnly;
        self.navigationItem.rightBarButtonItem.title = @"显示全部";
        self.title = @"常用快递";
    }else{
        self.contentMode = DeliverCompanyListContentModeAll;
        self.navigationItem.rightBarButtonItem.title = @"只显示常用";
        self.title = @"全部快递";
    }
    
    [self loadDB];
    [self.contentTable reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionData.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.contentMode == DeliverCompanyListContentModeFavOnly) {
        return nil;
    }
    
    NSString *key =  [self.keys objectAtIndex:section];
    return key;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.contentMode == DeliverCompanyListContentModeFavOnly) {
        return nil;
    }
    
    return self.keys;
}
@end
