//
//  ViewController.h
//  Check the Weather Project
//
//  Created by Marek on 29.04.2015.
//  Copyright (c) 2015 Marek Helak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQL.h"

@interface ViewController : UIViewController

//Long gesture for City
- (IBAction)longPress:(id)sender;

//First day details
@property (strong, nonatomic) YQL *yql;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UILabel *temperature;
@property (strong, nonatomic) IBOutlet UILabel *windForce;
@property (strong, nonatomic) IBOutlet UILabel *conditions;

//Next days
@property (strong, nonatomic) IBOutlet UILabel *secondDay;
@property (strong, nonatomic) IBOutlet UILabel *thirdDay;
@property (strong, nonatomic) IBOutlet UILabel *fourthDay;
@property (strong, nonatomic) IBOutlet UILabel *fifthDay;

@property NSMutableDictionary *JSON;


@end

