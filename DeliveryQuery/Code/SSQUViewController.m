//
//  SSQUViewController.m
//  QueryUtilities
//
//  Created by 佳 刘 on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SSQUViewController.h"
#import "SSMenuItemView.h"
#import "SSMenuView.h"
#import "SSQUMoreViewController.h"
#import "SSDQAllDeliveryCompanyListViewController.h"
#import "SSDQDeliveryQueryViewController.h"
#import "SSDQMyDeliveryViewController.h"
#import "SSDQSendDeliveryViewController.h"
#import "SSDQFollowDeliveryViewController.h"
#import "FMDatabase.h"
#import "SSQUAppDelegate.h"
#import "SSDQDeliveryQueryResult.h"
#import "SSMapping4RestKitUtils.h"
#import "ADVPercentProgressBar.h"
#import "SSBadgeView.h"
#import "SSToastView.h"

@interface SSQUViewController()<SSMenuViewDelegate>
@property (nonatomic,retain) IBOutlet SSMenuView * menuView;
@property (nonatomic,retain) NSArray *menuTitle;
@property (nonatomic,retain) NSArray *menuImage;
@property (nonatomic,retain) NSMutableArray *data;
@property (nonatomic,retain) SSBadgeView *badgeView;

@property (nonatomic) int index;
@property (nonatomic) CGFloat process;
@property (nonatomic) CGFloat subProcess;

//@property (nonatomic,retain) RKRequest *request;
@property (nonatomic,retain) UIWebView *tempWebView;
@property (nonatomic) BOOL isSend;
@property (nonatomic,retain) NSArray *needPreRequestCodes;
@property (nonatomic) int retryTimes;
@property (nonatomic) int updateCount;
@end

@implementation SSQUViewController
@synthesize menuView = _menuView;
@synthesize menuTitle = _menuTitle;
@synthesize menuImage = _menuImage;
@synthesize data = _data;
@synthesize index = _index;
@synthesize process = _process;
@synthesize subProcess = _subProcess;
@synthesize badgeView = _badgeView;

//@synthesize request = _request;
@synthesize tempWebView = _tempWebView;
@synthesize isSend = _isSend;
@synthesize needPreRequestCodes = _needPreRequestCodes;
@synthesize retryTimes = _retryTimes;
@synthesize updateCount = _updateCount;

-(NSArray *)menuTitle{
    if(nil==_menuTitle){
        self.menuTitle = [[NSArray alloc] initWithObjects:@"快递追踪",@"我的快递",@"快递查询",@"常用快递",@"快递公司大全",@"寄快递", nil];
    }
        
    return _menuTitle;
}

-(NSArray *)menuImage{
    if(nil==_menuImage){
        self.menuImage = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"zhuizong"],[UIImage imageNamed:@"liwu"],[UIImage imageNamed:@"chaxun"],[UIImage imageNamed:@"fav"],[UIImage imageNamed:@"companys"],[UIImage imageNamed:@"send"], nil];
    }
    
    return _menuImage;
}

#pragma mark - SSMenuViewDelegate Methods
-(void)menuView:(SSMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index{
    NSString * menuTileForIndex = [self.menuTitle objectAtIndex:index];
    if ([menuTileForIndex isEqualToString:@"快递追踪"]) {
//        SSQUTranslateViewController * translateViewController = [[SSQUTranslateViewController alloc] init];
//        translateViewController.navigationItem.title = @"翻译";
//        translateViewController.selectIndex = 0;
//        SET_GRAY_BG(translateViewController);
//        [self.navigationController pushViewController:translateViewController animated:YES];
//        [translateViewController release];

        SSDQFollowDeliveryViewController * translateViewController = [[SSDQFollowDeliveryViewController alloc] init];
        translateViewController.navigationItem.title = @"快递追踪";
        //        translateViewController.selectIndex = 1;
        SET_GRAY_BG(translateViewController);
        [self.navigationController pushViewController:translateViewController animated:YES];
        [translateViewController release];
    }else if ([menuTileForIndex isEqualToString:@"我的快递"]){
        SSDQMyDeliveryViewController * translateViewController = [[SSDQMyDeliveryViewController alloc] init];
        translateViewController.navigationItem.title = @"我的快递";
//        translateViewController.selectIndex = 1;
        SET_GRAY_BG(translateViewController);
        [self.navigationController pushViewController:translateViewController animated:YES];
        [translateViewController release];
    }else if ([menuTileForIndex isEqualToString:@"快递查询"]){
        SSDQDeliveryQueryViewController * fontChangeViewController = [[SSDQDeliveryQueryViewController alloc] initWithNibName:@"SSDQDeliveryQueryViewController" bundle:nil];
        fontChangeViewController.navigationItem.title = @"快递查询";
//        fontChangeViewController.selectIndex = 0;
        SET_GRAY_BG(fontChangeViewController);
        [self.navigationController pushViewController:fontChangeViewController animated:YES];
        [fontChangeViewController release];
    }else if ([menuTileForIndex isEqualToString:@"常用快递"]){
        SSDQAllDeliveryCompanyListViewController * translateViewController = [[SSDQAllDeliveryCompanyListViewController alloc] init];
        translateViewController.navigationItem.title = @"常用快递";
        translateViewController.contentMode = DeliverCompanyListContentModeFavOnly;
        //        translateViewController.selectIndex = 0;
        SET_GRAY_BG(translateViewController);
        [self.navigationController pushViewController:translateViewController animated:YES];

    }else if ([menuTileForIndex isEqualToString:@"快递公司大全"]){
        SSDQAllDeliveryCompanyListViewController * translateViewController = [[SSDQAllDeliveryCompanyListViewController alloc] init];
        translateViewController.navigationItem.title = @"快递公司大全";
        SET_GRAY_BG(translateViewController);
        [self.navigationController pushViewController:translateViewController animated:YES];
        [translateViewController release];
    }else if ([menuTileForIndex isEqualToString:@"寄快递"]){
        SSDQSendDeliveryViewController * localeViewController = [[SSDQSendDeliveryViewController alloc] init];
        localeViewController.navigationItem.title = @"寄快递";
//        localeViewController.selectIndex = 1;
        SET_GRAY_BG(localeViewController);
        [self.navigationController pushViewController:localeViewController animated:YES];
        [localeViewController release];
    }
}

-(NSUInteger)menuViewNumberOfItems:(SSMenuView*)menuView{
    return self.menuTitle.count;
}

-(SSMenuItemView*)menuView:(SSMenuView *)menuView ItemViewForRowAtIndex:(NSUInteger)index{
    SSMenuItemView * menuItemView = [[[SSMenuItemView alloc] init] autorelease];
    menuItemView.label.text = [self.menuTitle objectAtIndex:index];
    menuItemView.imageView.image = [self.menuImage objectAtIndex:index];
    menuItemView.maskImageView.frame = menuItemView.imageView.frame;
    menuItemView.maskImageView.image = [UIImage imageNamed:@"gray_mengban"];
    return menuItemView;
}

#pragma mark - Life cycle

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

-(void)dealloc{
    self.badgeView = nil;
    self.tempWebView = nil;
    self.needPreRequestCodes = nil;
    self.data = nil;
    self.menuView = nil;
    self.menuTitle = nil;
    self.menuImage = nil;

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.menuView.menuDelegate = self;
    self.menuView.topPadding = 11;
    self.menuView.yPadding = 22;
    self.menuView.columnCount = 3;
    SET_GRAY_BG(self);
    [self.menuView reloadData];
    
    [self initRightBtn];
    
    [self initNeedPreRequestCodes];
    [self updateDelivery];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self initBadgeView];
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    self.badgeView = nil;
    self.tempWebView = nil;
    self.needPreRequestCodes = nil;
    self.data = nil;
    self.menuView = nil;
    self.menuTitle = nil;
    self.menuImage = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)updateDelivery {
    self.isLoading = !self.isLoading;
    
    if (self.isLoading) {
        [self.loadingView showLoadingView];
        self.navigationItem.rightBarButtonItem.title = @"停止更新";
    }else{
        [self stopUpdating];
        return;
    }
    
    if (![self isNetworkOK]) {
        [[SSToastView MakeToastWithType:TOAST_STYLE_FAV info:@"网络无法连接，请稍后手动更新"]show];
        return;
    }
    
    self.index = 0;
    self.retryTimes = 0;
    self.updateCount = 0;
    self.isLoading = YES;
    self.process = 0.0;
    [self.loadingView hasProcessBar:0.0];
    
    self.data = [[[NSMutableArray alloc]init]autorelease];
    FMDatabase *db = GETDB;
    if ([db open]) {
        NSMutableString *sql = [NSMutableString stringWithString: @"SELECT * from DeliveryQueryHistoryMain where status = 0 or status = 1 or status = 2"];
        
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
            
            FMResultSet *items = [db executeQuery:[NSString stringWithFormat:@"SELECT * from DeliveryQueryHistoryItems where mainId = %d",result.id]];
            
            result.data = [NSMutableArray arrayWithCapacity:[items columnCount]];
            while ([items next]) {
                SSDQDeliveryItem *item = [[[SSDQDeliveryItem alloc]init]autorelease];
                item.time = [items stringForColumn:@"time"];
                item.context = [items stringForColumn:@"context"];
                
                [result.data addObject:item];
            }

            
            [self.data addObject:result];
            
        }
        
    }


    [db close];

    if (self.data.count <= 0) {
        self.isLoading = NO;
        [self stopUpdating];
        return;
    }
    
    self.subProcess = (CGFloat)(1.0/self.data.count);
    
    [self loadObjectsFromRemote];

}


-(void)loadObjectsFromRemote{
    
    if (!self.isLoading) {
        return;
    }
    
    if (self.index >= self.data.count) {
        self.isLoading = NO;
        [self stopUpdating];
        return;
    }
    
    SSDQDeliveryResult *srcResult = [self.data objectAtIndex:self.index];
    
    if ([self.needPreRequestCodes containsObject:srcResult.expSpellName]) {
//        NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *preUrl = [NSString stringWithFormat:@"http://www.kuaidi100.com/chaxun?com=%@&nu=%@",srcResult.expSpellName, srcResult.mailNo];
//        NSString *htmlUrl =  [NSString stringWithContentsOfURL:[NSURL URLWithString:preUrl] encoding:encode error:nil];
        
        //    NSLog(@"%d",[[NSURL URLWithString:htmlUrl]checkResourceIsReachableAndReturnError:nil]);
        
        if (_tempWebView == nil) {
            self.tempWebView = [[[UIWebView alloc]init]autorelease];
            self.tempWebView.hidden = YES;
            self.tempWebView.delegate = self;
        }
        
        self.isSend = NO;
        
        [_tempWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:preUrl]]];
        
        self.process = self.process + self.subProcess*0.2;
        [self.loadingView updateProcess:self.process];
    }else {
        self.process = self.process + self.subProcess*0.4;
        [self.loadingView updateProcess:self.process];
        [self loadRealRequest];
    }
    
    
}

-(void)loadRealRequest {
    
    if (!self.isLoading) {
        return;
    }
    
//    [self.request cancel];
//    [self.request release];
//    self.request = nil;
    
    SSDQDeliveryResult *srcResult = [self.data objectAtIndex:self.index];
    
    NSString *url = [NSString stringWithFormat:@"api?id=%@&com=%@&nu=%@&show=0&muti=1&order=asc",API_KEY,srcResult.expSpellName, srcResult.mailNo];
    
    RKClient* sharedClient = [RKClient sharedClient];
    [sharedClient get:url usingBlock:^(RKRequest * request){
        request.delegate = self;
    }];
    
//    RKRequest* request = [RKRequest requestWithURL:[NSURL URLWithString:url]delegate:self];
//    if (request!=nil) {
//        request.delegate = self;
        //        [self.loadingView showLoadingView];
//        [request send];
//    }
}

-(void)initNeedPreRequestCodes {
    if (self.needPreRequestCodes == nil) {
        self.needPreRequestCodes = [NSArray arrayWithObjects:@"youzhengguonei",@"ems",@"emsen",@"youzhengguoji",@"shentong",@"shunfeng",@"shunfengen",@"xingchengjibian", nil];
    }
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    [self.tempWebView stopLoading];
    
    if (!self.isLoading) {
        return;
    }
    
    NSLog(@"success :%@",[response bodyAsString]);
    
    SSDQDeliveryResult * result = [SSMapping4RestKitUtils performMappingWithMapping:[SSDQDeliveryResult sharedObjectMapping] forJsonString:[response bodyAsString]] ;
    
    self.process = self.process + self.subProcess*0.6;
    [self.loadingView updateProcess:self.process];
    
    if (result==nil)
    {
//        self.resultText.text = @"抱歉！查无结果";
    }else{
        
//        result.expTextName = self.company.name;
        if (result.errCode!=SSDQDeliveryResultErrorCodeNoError) {
            switch (result.errCode) {
                case SSDQDeliveryResultErrorCodeNumberNotExist:
                {
//                    NSString *msg = [NSString stringWithFormat:@"快递单不存在或者已经过期！要保存查询记录吗？"];
//                    
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"查询失败" message:msg delegate:self cancelButtonTitle:@"重新查询" otherButtonTitles:@"仍然保存", nil];
//                    alert.tag = 0;
//                    [alert show];
                    
                }
                    break;
                case SSDQDeliveryResultErrorCodeInterfaceError:
                {
                    
//                    NSString *msg = [NSString stringWithFormat:@"当前查询量过大，请重试！"];
//                    
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"查询失败" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
//                    alert.tag = 1;
//                    [alert show];
                    
                }
                    break;
                default:
                    break;
            }
            
            
            
            
//            [self.loadingView hideLoadingView];
//            return;
        }else{
            [self updateSingleDelivery:result];
        }

    }
    
    self.index = self.index + 1;
    [self loadObjectsFromRemote];
}


-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    if (!self.isLoading) {
        return;
    }
    
    self.process = self.process + self.subProcess*0.6;
    [self.loadingView updateProcess:self.process];
    self.index = self.index + 1;
    [self loadObjectsFromRemote];
}

-(void)updateSingleDelivery:(SSDQDeliveryResult *)result {
    if (!self.isLoading) {
        return;
    }
    
    SSDQDeliveryResult *srcResult = [self.data objectAtIndex:self.index];
    
    if (srcResult.status == result.status && srcResult.data.count >= result.data.count) {
        return;
    }
    
    self.updateCount = self.updateCount+1;
    [self.loadingView updateUpdateInfo:self.updateCount];
    
    FMDatabase *db = GETDB;
    
    if ([db open]) {
        NSString *str;
        NSString *sendTime = @"";
        NSString *latestContext = @"";
        NSString *signTime = @"";
        
        if (result.data && [result.data count] > 0) {
            SSDQDeliveryItem *earliestItem = [result.data objectAtIndex:0];
            sendTime = earliestItem.time;
            
            SSDQDeliveryItem *latestItem = [result.data lastObject];
            latestContext = latestItem.context;
            
            if (result.status == SSDQDeliveryResultStatusSigned) {
                signTime = latestItem.time;
            }
            
        }
        
        
        str = [NSString stringWithFormat:@"update DeliveryQueryHistoryMain set status=%d,errCode=%d,sendTime='%@',signTime='%@',latestContext='%@',hasUpdate = 1 where id = %d",result.status,result.errCode,sendTime,signTime,latestContext, srcResult.id];
        
        NSLog(@"execute sql :%@",str);
        
        BOOL success = [db executeUpdate:str];
        NSLog(@"result is %d",success);
        
        for (int i=srcResult.data.count; i < result.data.count; i++) {
            SSDQDeliveryItem *item = [result.data objectAtIndex:i];
            
            NSString *itemSql = [NSString stringWithFormat:@"insert into DeliveryQueryHistoryItems (time,context,mainId,hasUpdate) values('%@','%@',%d,1)",item.time,item.context,srcResult.id];
            
            [db executeUpdate:itemSql];
        }
        
    }
    
    [db close];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!self.isLoading) {
        return;
    }
    
    if (!_isSend) {
        self.process = self.process + self.subProcess*0.2;
        [self.loadingView updateProcess:self.process];
        
        [self performSelector:@selector(loadRealRequest) withObject:nil afterDelay:4];
        _isSend = YES;
        
    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (!self.isLoading) {
        return;
    }
    
    if (!_isSend) {
        self.process = self.process + self.subProcess*0.2;
        [self.loadingView updateProcess:self.process];
        self.index = self.index + 1;
        [self loadObjectsFromRemote];
        _isSend = YES;
    }
}

-(void)initBadgeView{
    if (self.badgeView == nil) {
        self.badgeView = [[SSBadgeView alloc] initWithFrame:CGRectMake(78, 25, 17, 17)];
        self.badgeView.userInteractionEnabled = NO;
    }
    
    
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 99) {
        self.badgeView.badgeText = @"N";
    }else {
        self.badgeView.badgeText = [NSString stringWithFormat:@"%d", [UIApplication sharedApplication].applicationIconBadgeNumber];
    };
    [self.view addSubview:self.badgeView];
}

-(BOOL)isNetworkOK{
    return [[RKClient sharedClient] isNetworkReachable];
}

-(void) initRightBtn {
    
    UIBarButtonItem * infoButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"停止更新" style:UIBarButtonItemStylePlain target:self action:@selector(updateDelivery)]autorelease];
    
    self.navigationItem.rightBarButtonItem = infoButtonItem ;
}

-(void)stopUpdating {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.loadingView updateProcess:1.0];
    [self.loadingView performSelector:@selector(hideLoadingView) withObject:nil afterDelay:1.5];
    [self performSelector:@selector(enableRightBtn) withObject:nil afterDelay:1.5];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + self.updateCount;
    
    self.navigationItem.rightBarButtonItem.title = @"更新快递";
    
    [self initBadgeView];
}

-(void)enableRightBtn{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
@end
