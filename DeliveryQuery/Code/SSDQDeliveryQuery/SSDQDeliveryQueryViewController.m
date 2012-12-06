//
//  SSDQDeliveryQueryViewController.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-13.
//
// http://api.kuaidi100.com/api?id=7b732424c8c4a433&com=shunfeng&nu=102494116867&show=0&muti=1&order=desc

#import "SSDQDeliveryQueryViewController.h"
#import "SSMapping4RestKitUtils.h"
#import "SSDQDeliveryQueryResult.h"
#import "SSDQAllDeliveryCompanyListViewController.h"
#import "SSDQDeliveryQueryResultViewController.h"
#import "FMDatabase.h"
#import "SSQUAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "SSSystemUtils.h"
#import "UIView+UIViewUtil.h"

@interface SSDQDeliveryQueryViewController ()
@property (nonatomic,retain) IBOutlet UILabel *companyName;
@property (nonatomic,retain) IBOutlet UITextField *deliveryNumber;
//@property (nonatomic,retain) RKRequest *request;
@property (nonatomic,retain) IBOutlet UIWebView *tempWebView;
@property (nonatomic) BOOL isSend;
@property (nonatomic,retain) NSArray *needPreRequestCodes;
@property (nonatomic) int retryTimes;
@property (nonatomic,retain) IBOutlet UIButton *sendrequestButton;
@property (nonatomic,retain) IBOutlet UIView *bg;
@property (nonatomic,retain) IBOutlet UIToolbar *keyBoardToolBar;

@property (nonatomic,copy) NSString *code;

-(IBAction)changeKeyBoard:(UISegmentedControl*)sender;
@end

@implementation SSDQDeliveryQueryViewController
@synthesize company = _company;
@synthesize companyName = _companyName;
@synthesize deliveryNumber = _deliveryNumber;
//@synthesize request = _request;
@synthesize code = _code;
@synthesize isSend = _isSend;
@synthesize needPreRequestCodes = _needPreRequestCodes;
@synthesize retryTimes = _retryTimes;
@synthesize sendrequestButton = _sendrequestButton;
@synthesize bg = _bg;
@synthesize keyBoardToolBar = _keyBoardToolBar;
@synthesize tempWebView = _tempWebView;
-(void)dealloc{
    self.company = nil;
    self.companyName = nil;
    self.tempWebView = nil;
    self.deliveryNumber = nil;
    self.needPreRequestCodes = nil;
    self.code = nil;
    self.keyBoardToolBar = nil;
    self.bg = nil;
    self.sendrequestButton = nil;
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
	// Do any additional setup after loading the view.
//    self.tempWebView.hidden = YES;
    
    [self initNeedPreRequestCodes];
    [self setBtn];
    [self initBg];
    SET_GRAY_BG(self);
    
    [self.keyBoardToolBar setOriginY:[self.view height] - 260];
    if (HAS_AD) {
        [self.keyBoardToolBar verticalMove:25];
    }
    
}

-(void)viewDidUnload {
    self.company = nil;
    self.companyName = nil;
    self.tempWebView = nil;
    self.deliveryNumber = nil;
    self.needPreRequestCodes = nil;
    self.code = nil;
    self.keyBoardToolBar = nil;
    self.bg = nil;
    self.sendrequestButton = nil;
    
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.company) {
        self.companyName.text = self.company.name;
    }
    
//    _isSend = NO;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadObjectsFromRemote{
    
    [self.loadingView showLoadingView];
    
    if ([self.needPreRequestCodes containsObject:self.company.code]) {
        NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *preUrl = [NSString stringWithFormat:@"http://www.kuaidi100.com/chaxun?com=%@&nu=%@",self.company.code, self.deliveryNumber.text];
        NSString *htmlUrl =  [NSString stringWithContentsOfURL:[NSURL URLWithString:preUrl] encoding:encode error:nil];
        
        //    NSLog(@"%d",[[NSURL URLWithString:htmlUrl]checkResourceIsReachableAndReturnError:nil]);
        
        NSLog(@"url:%@",preUrl);
        NSLog(@"url:%@",htmlUrl);
        
        
        [_tempWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:preUrl]]];
    }else {
        [self loadRealRequest];
    }
   
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    [self.tempWebView stopLoading];
    
    NSLog(@"success :%@",[response bodyAsString]);
    
    SSDQDeliveryResult * result = [SSMapping4RestKitUtils performMappingWithMapping:[SSDQDeliveryResult sharedObjectMapping] forJsonString:[response bodyAsString]] ;

    
    if (result==nil)
    {
    }else{

        result.expTextName = self.company.name;
        if (result.errCode!=SSDQDeliveryResultErrorCodeNoError) {
            switch (result.errCode) {
                case SSDQDeliveryResultErrorCodeNumberNotExist:
                {
                    NSString *msg = [NSString stringWithFormat:@"快递单不存在或者已经过期！要保存查询记录吗？"];
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"查询失败" message:msg delegate:self cancelButtonTitle:@"重新查询" otherButtonTitles:@"仍然保存", nil];
                    alert.tag = 0;
                    [alert show];
                    [alert release];
                }
                    break;
                case SSDQDeliveryResultErrorCodeInterfaceError:
                {
                    
                    NSString *msg = [NSString stringWithFormat:@"当前查询量过大，请重试！"];
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"查询失败" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
                    alert.tag = 1;
                    [alert show];
                    [alert release];
                }
                    break;
                default:
                    break;
            }
            
            
            
            
            [self.loadingView hideLoadingView];
            return;
        }
        
        [self addDelivery:result];
        
        [self enterDetail];
    }
    [self.loadingView hideLoadingView];
}

#pragma mark –
#pragma mark onClickButton
-(IBAction)onButton:(id)sender
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
}
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    NSLog(@"===%@",symbol.data);
    self.deliveryNumber.text= symbol.data;

    [reader dismissModalViewControllerAnimated: YES];
}

-(IBAction)selectDeliveryCompany:(id)sender {
    SSDQAllDeliveryCompanyListViewController *dcl = [[SSDQAllDeliveryCompanyListViewController alloc]init];
    dcl.displayMode = DeliverCompanyListDisplayModeSelect;
    dcl.contentMode = DeliverCompanyListContentModeFavOnly;
    [self.navigationController pushViewController:dcl animated:YES];
    [dcl release];
}

-(IBAction)query:(id)sender {
    [self.deliveryNumber resignFirstResponder];
    
    if (self.company.code.length <=0 || self.deliveryNumber.text.length <=0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"信息不完整" message:@"请完整输入快递公司和快递单号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return;
    }
    
    // 如果已经签收了，就不查询了
    if (![self isFinished]) {
        [self loadObjectsFromRemote];
        self.isSend = NO;
        self.retryTimes = 0;
    }else{
        [self enterDetail];
    }
    
}

-(void)addDelivery:(SSDQDeliveryResult *) result {
    
    if (result == nil) {
        return;
    }
    
    result.id = [[self isQueryed] id];
    
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
        
        if (result.id == 0) {
            str = [NSString stringWithFormat:@"insert into DeliveryQueryHistoryMain (companyCode,companyName,deliveryNumber,status,sendTime,signTime,latestContext,companyPhone,errCode) values('%@','%@','%@',%d,'%@','%@','%@','%@',%d)",result.expSpellName,result.expTextName,result.mailNo,result.status,sendTime,signTime,latestContext,self.company.phone,result.errCode];
        } else {
            str = [NSString stringWithFormat:@"update DeliveryQueryHistoryMain set status=%d,errCode=%d,sendTime='%@',signTime='%@',latestContext='%@' where id = %d",result.status,result.errCode,sendTime,signTime,latestContext, result.id];
            
            // 删除
            NSString *delItemsSql = [NSString stringWithFormat:@"delete from  DeliveryQueryHistoryItems where mainId = %d",result.id];
            [db executeUpdate:delItemsSql];
        }
        
        
        BOOL success = [db executeUpdate:str];
        NSLog(@"result is %d",success);
        
        
        if (result.id == 0) {
            NSString *sql = [NSString stringWithFormat: @"SELECT * from DeliveryQueryHistoryMain where companyCode = '%@' and deliveryNumber = '%@'",result.expSpellName,result.mailNo];
            
            NSLog(@"execute sql:%@",sql);
            FMResultSet *rs = [db executeQuery:sql];
            
            if ([rs next]) {
                result.id = [rs intForColumn:@"id"];
            }
            
        }
        
        
        for (int i=0; i < [result.data count]; i++) {
            SSDQDeliveryItem *item = [result.data objectAtIndex:i];
            
            NSString *itemSql = [NSString stringWithFormat:@"insert into DeliveryQueryHistoryItems (time,context,mainId) values('%@','%@',%d)",item.time,item.context,result.id];
            
            [db executeUpdate:itemSql];
        }
        
    }
    
    [db close];
}

-(SSDQDeliveryResult*)isQueryed{
    FMDatabase *db = GETDB;
    
    if (self.deliveryNumber.text.length <=0 && self.company.code.length <=0) {
        return nil;
    }
    
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat: @"SELECT * from DeliveryQueryHistoryMain where companyCode = '%@' and deliveryNumber = '%@'",self.company.code,self.deliveryNumber.text];
        
        NSLog(@"execute sql:%@",sql);
        FMResultSet *rs = [db executeQuery:sql];
        
        if ([rs next]) {
            NSLog(@"isQueryed:%d",[rs intForColumn:@"id"]);
            SSDQDeliveryResult *result = [[[SSDQDeliveryResult alloc]init]autorelease];
            result.id = [rs intForColumn:@"id"];
            result.status = [rs intForColumn:@"status"];
            
            return result;
        }
    }
    
    [db close];
    
    return nil;
}

-(BOOL)isFinished {
    SSDQDeliveryResult *result = [self isQueryed];
    
    return result && result.id > 0 && result.status == SSDQDeliveryResultStatusSigned;
}

-(void)enterDetail {
    SSDQDeliveryQueryResultViewController *dqr = [[SSDQDeliveryQueryResultViewController alloc]init];
    dqr.title = @"快递详情";
    dqr.companyCode = self.company.code;
    dqr.deliveryNumber = self.deliveryNumber.text;
    
    [self.navigationController pushViewController:dqr animated:YES];
    [dqr release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 0:
            switch (buttonIndex) {
                case 1:{
                    SSDQDeliveryResult *result = [[SSDQDeliveryResult alloc]init];
                    result.mailNo = self.deliveryNumber.text;
                    result.expSpellName = self.company.code;
                    result.expTextName = self.company.name;
                    result.status = SSDQDeliveryResultStatusFailed;
                    result.errCode = SSDQDeliveryResultErrorCodeNumberNotExist;
                    
                    [self addDelivery:result];
                    [self enterDetail];
                }
                    
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:{
            switch (buttonIndex) {
                case 1:{
                    [self loadRealRequest];
                }
                    
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!_isSend) {
        NSTimeInterval delay = 0;
        if ([self.needPreRequestCodes containsObject:self.company.code]) {
            delay = 4;
        }
        
        [self performSelector:@selector(loadRealRequest) withObject:nil afterDelay:delay];
        _isSend = YES;
        
    }

}

-(void)loadRealRequest {
    NSString *url = [NSString stringWithFormat:@"api?id=%@&com=%@&nu=%@&show=0&muti=1&order=asc",API_KEY,self.company.code, self.deliveryNumber.text];
    
//    self.request = [RKRequest requestWithURL:[NSURL URLWithString:url]];
    RKClient * client = [RKClient sharedClient];
    [client get:url usingBlock:^(RKRequest *request){
        request.delegate = self;
    }];
    
//    if (self.request!=nil) {
//        self.request.delegate = self;
//        //        [self.loadingView showLoadingView];
//        [self.request send];
//    }
}

-(void)initNeedPreRequestCodes {
    if (self.needPreRequestCodes == nil) {
        self.needPreRequestCodes = [NSArray arrayWithObjects:@"youzhengguonei",@"ems",@"emsen",@"youzhengguoji",@"shentong",@"shunfeng",@"shunfengen",@"xingchengjibian", nil];
    }
}

-(void)setBtn {
    
    [SSSystemUtils setGrayBtn:self.sendrequestButton];
}

-(void)initBg {
    self.bg.layer.borderWidth = 1;
    self.bg.layer.cornerRadius = 12;
    self.bg.layer.borderColor = [[UIColor grayColor] CGColor];
}

-(void)changeKeyBoard:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{
            self.deliveryNumber.keyboardType = UIKeyboardTypeNumberPad;

        }
            break;
        case 1:{
            self.deliveryNumber.keyboardType = UIKeyboardTypeASCIICapable;
            
        }
            break;
        default:
            break;
    }
    
    [self.deliveryNumber reloadInputViews];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.keyBoardToolBar.hidden = NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.deliveryNumber.text = [self.deliveryNumber.text uppercaseString];
    self.keyBoardToolBar.hidden = YES;
}
@end
