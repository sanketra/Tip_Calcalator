//
//  SecondViewController.m
//  Tip_Calcalator
//
//  Created by Kingfisher on 10/27/14.
//  Copyright (c) 2014 __ASU__. All rights reserved.
//

#define INT_SET @"1234567890"
#define DOUBLE_SET @"1234567890."
#define CHARACTER_LIMIT 5

#import "TCHomeViewController.h"

@interface TCHomeViewController ()

@property (nonatomic, assign) float minTipPercentage;
@property (nonatomic, assign) float maxTipPercentage;
@property (nonatomic, assign) BOOL shouldIncludeTax;
@property (nonatomic, assign) BOOL shouldIncludeDeductions;
@property (nonatomic, assign) UITextField *activeField;
@end

@implementation TCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"Tip Calculator"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tipPercentageDidChange:) name:@"tipPercentageDidChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tipConfigurationDidChange:) name:@"tipConfigurationDidChange" object:nil];
    [self.slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self configureDefaults];
}

- (void)sliderValueChanged {
    NSInteger intRate = lroundf(((self.maxTipPercentage - self.minTipPercentage) * self.slider.value) + self.minTipPercentage);
    NSString *rate = [NSString stringWithFormat:@"%ld %%", (long)intRate];
    self.tipRate.text = rate;
    [self calculateTip];
}

- (void)tipPercentageDidChange:(NSNotification *)iNotification {
    NSDictionary *dictionary = [iNotification userInfo];
    self.minTipPercentage = [[dictionary valueForKey:@"min"] floatValue];
    self.maxTipPercentage = [[dictionary valueForKey:@"max"] floatValue];
    [self sliderValueChanged];
}

- (void)tipConfigurationDidChange:(NSNotification *)iNotification {
    NSDictionary *dictionary = [iNotification userInfo];
    self.shouldIncludeTax = [[dictionary valueForKey:@"shouldIncludeTax"] boolValue];
    self.shouldIncludeDeductions = [[dictionary valueForKey:@"shouldIncludeDeductions"] boolValue];
    [self.tax setEnabled:self.shouldIncludeTax];
    
    if (!self.shouldIncludeTax) {
       self.tax.text = @"0.0";
    }
    
    [self calculateTip];
}

- (void)configureDefaults {
    self.guestCount.text = @"1";
    self.billTotal.text = @"0.0";
    self.billDeductions.text = @"0.0";
    self.tax.text = @"0.0";
    self.minTipPercentage = 0;
    self.maxTipPercentage = 40;
    self.shouldIncludeTax = NO;
    self.shouldIncludeDeductions = YES;
    [self sliderValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)calculateTip {
    NSInteger numberOfGuests = [self.guestCount.text integerValue];
    float billTotal = [self.billTotal.text floatValue];
    float billDeductions = self.shouldIncludeDeductions ? [self.billDeductions.text floatValue] : 0.0;
    float tax = self.shouldIncludeTax ? [self.tax.text floatValue] : 0.0;
    float tipRate = [[self.tipRate.text substringToIndex:[self.tipRate.text length] - 2] floatValue] / 100.0;
    float totalTip = ((billTotal - billDeductions) + tax) * tipRate;
    self.totalTip.text = [NSString stringWithFormat:@"%.2f", totalTip];
    float perPersonTip = totalTip / numberOfGuests;
    self.perPersonTip.text = [NSString stringWithFormat:@"%.2f", perPersonTip];
    float totalBill = billTotal - billDeductions + tax + totalTip;
    self.total.text = [NSString stringWithFormat:@"%.2f", totalBill];
    
    [self updateTipTailoringWithPerPeronTip:perPersonTip andTotalTip:totalTip];
}

- (void)updateTipTailoringWithPerPeronTip:(float)perPersonTip andTotalTip:(float)totalTip {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.guestCount.text forKey:@"guestsCount"];
    [dict setObject:[NSNumber numberWithFloat:perPersonTip] forKey:@"perPersonTip"];
    [dict setObject:[NSNumber numberWithFloat:totalTip] forKey:@"totalTip"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePerPersonTip"
                                                        object:nil
                                                      userInfo:dict];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.billDeductions || textField == self.tax || textField == self.billTotal) {
        if ([self.billDeductions.text floatValue] > [self.billTotal.text floatValue]) {
            [self showAlertWithTitle: @"Bill Deductions" message:@"cannot be more than Bill Total!"];
            self.billDeductions.text = @"0.0";
        }
        
        if ([self.tax.text floatValue] > [self.billTotal.text floatValue]) {
            [self showAlertWithTitle: @"Tax" message:@"cannot be more than Bill Total!"];
        }
    }
    
    if (textField == self.guestCount && [self.guestCount.text isEqualToString:@"0"]) {
        [self showAlertWithTitle: @"Guest's Count" message:@"cannot be zero!"];
        self.guestCount.text = @"1";
        [self calculateTip];
    } else {
         [self calculateTip];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSCharacterSet *charSet = nil;
    
    if (textField == self.guestCount) {
        charSet = [[NSCharacterSet characterSetWithCharactersInString: INT_SET] invertedSet];
    } else {
        charSet = [[NSCharacterSet characterSetWithCharactersInString: DOUBLE_SET] invertedSet];
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered]) && (newLength <= CHARACTER_LIMIT));
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
