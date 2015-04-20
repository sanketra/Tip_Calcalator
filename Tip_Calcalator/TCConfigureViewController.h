//
//  ThirdViewController.h
//  Tip_Calcalator
//
//  Created by Kingfisher on 10/27/14.
//  Copyright (c) 2014 __ASU__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TCConfigureViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *minimumTipPercentage;
@property (nonatomic, strong) IBOutlet UITextField *maxmimumTipPercentage;
@property (nonatomic, strong) IBOutlet UISwitch *includeTax;
@property (nonatomic, strong) IBOutlet UISwitch *includeDeductions;

@end