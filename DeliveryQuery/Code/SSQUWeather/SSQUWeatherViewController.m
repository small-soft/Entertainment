//
//  SSQUWeatherViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-27.
//
//

#import "SSQUWeatherViewController.h"

#import "SSQULocation.h"

@interface SSQUWeatherViewController ()

@property (nonatomic, retain) NSArray *provinces;
@property (nonatomic, retain) NSArray *cities;
@property (nonatomic, retain) SSQULocation *currentLocation;


@end

@implementation SSQUWeatherViewController
@synthesize provinces = _provinces;
@synthesize cities = _cities;
@synthesize currentLocation = _currentLocation;


-(void)dealloc{

    self.provinces = nil;
    self.cities = nil;
    self.currentLocation = nil;

    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvincesAndCities.plist" ofType:nil]];
        _cities = [[[self.provinces objectAtIndex:0] objectForKey:@"Cities"] retain];
        
        _currentLocation = [[SSQULocation alloc] init];
        _currentLocation.state = [[self.provinces objectAtIndex:0] objectForKey:@"State"];
        _currentLocation.city = [[self.cities objectAtIndex:0] objectForKey:@"city"];
        _currentLocation.latitude = [[[self.cities objectAtIndex:0] objectForKey:@"lat"] doubleValue];
        _currentLocation.longitude = [[[self.cities objectAtIndex:0] objectForKey:@"lon"] doubleValue];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvincesAndCities.plist" ofType:nil]];
        _cities = [[[self.provinces objectAtIndex:0] objectForKey:@"Cities"] retain];
        
        _currentLocation = [[SSQULocation alloc] init];
        _currentLocation.state = [[self.provinces objectAtIndex:0] objectForKey:@"State"];
        _currentLocation.city = [[self.cities objectAtIndex:0] objectForKey:@"city"];
        _currentLocation.latitude = [[[self.cities objectAtIndex:0] objectForKey:@"lat"] doubleValue];
        _currentLocation.longitude = [[[self.cities objectAtIndex:0] objectForKey:@"lon"] doubleValue];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadObjectsFromRemote{

    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

    self.request = [RKRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://api.liqwei.com/weather?city=%@",self.currentLocation.city] stringByAddingPercentEscapesUsingEncoding:encode]]];
    [super loadObjectsFromRemote];
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"success :%@",[response bodyAsString]);
    NSArray *tempResultArray = [[response bodyAsString] componentsSeparatedByString:@"<br/>"];
    NSMutableString * tempResult = [[NSMutableString alloc] init];
    for (NSString * tempResultLine in tempResultArray) {
        [tempResult appendFormat:@"%@\n",tempResultLine];
    }
    self.resultLabel.text = tempResult;
    
    [super request:request didLoadResponse:response];

}


#pragma mark - PickerView lifecycle
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [self.provinces count];

        case 1:
            return [self.cities count];

        default:
            return 0;

    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[self.provinces objectAtIndex:row] objectForKey:@"State"];

        case 1:
            return [[self.cities objectAtIndex:row] objectForKey:@"city"];
       
        default:
            return nil;

    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.cities = [[self.provinces objectAtIndex:row] objectForKey:@"Cities"];
            [self.pickerView selectRow:0 inComponent:1 animated:NO];
            [self.pickerView reloadComponent:1];
            
            self.currentLocation.state = [[self.provinces objectAtIndex:row] objectForKey:@"State"];
            self.currentLocation.city = [[self.cities objectAtIndex:0] objectForKey:@"city"];
            self.currentLocation.latitude = [[[self.cities objectAtIndex:0] objectForKey:@"lat"] doubleValue];
            self.currentLocation.longitude = [[[self.cities objectAtIndex:0] objectForKey:@"lon"] doubleValue];
            break;
        case 1:
            self.currentLocation.city = [[self.cities objectAtIndex:row] objectForKey:@"city"];
            self.currentLocation.latitude = [[[self.cities objectAtIndex:row] objectForKey:@"lat"] doubleValue];
            self.currentLocation.longitude = [[[self.cities objectAtIndex:row] objectForKey:@"lon"] doubleValue];
            break;
        default:
            break;
    }
}

@end
