//
//  ViewController.m
//  Check the Weather Project
//
//  Created by Marek on 29.04.2015.
//  Copyright (c) 2015 Marek Helak. All rights reserved.
//

#import "ViewController.h"
#import "YQL.h"


@implementation ViewController

@synthesize yql, JSON, secondDay, thirdDay, fourthDay, fifthDay;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Get access to Yahoo Query language
    yql = [[YQL alloc] init];
}

//Long press on "City"
- (IBAction)longPress:(id)sender {
    
    //Alert Body
    UIAlertController *alert = [[UIAlertController
                                 alertControllerWithTitle:@"Search"
                                 message:@"Enter desired location"
                                 preferredStyle:UIAlertControllerStyleAlert]
                                init];
    
    //Alert Button ok
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Get text from UIAlert array
                             NSString *text = ((UITextField* )
                                [alert.textFields objectAtIndex:0]).text;
                             
                             NSString *destination = [NSString stringWithFormat:@"select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"%@\") and u=\"c\"", text];
                             
                             JSON = [yql query:destination].mutableCopy;
                             
                             @try {
                                 [self parseJSONtoViewMain:text];
                                 [self parseJSONtoViewNextDays:text];
                             }
                             @catch (NSException *exception){
                                 
                                  [self presentViewController:alert animated:YES completion:nil];
                             }
                             
                             
                         }];
    
    //Alert button cancel
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action)
                             {
                                 // Dismiss
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

//Push to view first day
-(void)parseJSONtoViewMain:(NSString *)city
{
    //Get JSON from Yahoo Weather API
    NSString *destination = [NSString stringWithFormat:@"select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"%@\") and u=\"c\"", city];
    JSON = [yql query:destination].mutableCopy;
    
    //Set city and country into main label
    NSString *actualCity = JSON[@"query"][@"results"][@"channel"][@"location"][@"city"];
    NSString *actualCountry = [@", " stringByAppendingString:JSON[@"query"][@"results"][@"channel"][@"location"][@"country"]];
    NSString *cityAndCountry = [actualCity stringByAppendingString:actualCountry];
    self.city.text = cityAndCountry;
    
    //Set temperature and parse to label
    NSString *actualTemp = JSON[@"query"][@"results"][@"channel"][@"item"][@"condition"][@"temp"];
    self.temperature.text = [actualTemp stringByAppendingString:@" °C"];
    
    //Set wind speed and parse to label
    NSString *actualWindSpeed = JSON[@"query"][@"results"][@"channel"][@"wind"][@"speed"];
    self.windForce.text = [actualWindSpeed stringByAppendingString:@" km/h"];
    
    //Set actual condition and parse to label
    NSString *actualCondition = JSON[@"query"][@"results"][@"channel"][@"item"][@"condition"][@"text"];
    self.conditions.text = actualCondition;
    
}

//Push to view next days
-(void)parseJSONtoViewNextDays:(NSString *)city{
 
    //Put UILabels to array
    NSArray *nextDaysArray = @[secondDay, thirdDay, fourthDay, fifthDay];
    
    //Make smaller dictionary
    NSMutableDictionary *forecast = JSON[@"query"][@"results"][@"channel"][@"item"];
    
    int i;
    for(i = 1; i<5; i++){
    
        NSString *date = forecast[@"forecast"][i][@"day"];
        NSString *high = forecast[@"forecast"][i][@"high"];
        NSString *low = forecast[@"forecast"][i][@"low"];
        NSString *condition = forecast[@"forecast"][i][@"text"];

        NSString *day = [NSString stringWithFormat:@"%@, %@°C-%@°C, %@", date, low, high, condition];
        UILabel *label = nextDaysArray[i-1];
        label.text = day;
    }
}

@end