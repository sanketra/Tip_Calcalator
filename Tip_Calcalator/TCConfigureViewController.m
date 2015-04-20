//
//  ThirdViewController.m
//  Tip_Calcalator
//
//  Created by Kingfisher on 10/27/14.
//  Copyright (c) 2014 __ASU__. All rights reserved.
//

#define INT_SET @"1234567890"
#define DOUBLE_SET @"1234567890."
#define CHARACTER_LIMIT 5

#import "TCConfigureViewController.h"

@implementation TCConfigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"Configure"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.minimumTipPercentage.text = @"0";
    self.maxmimumTipPercentage.text = @"40";
    [self.includeTax addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.includeDeductions addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)switchValueChanged:(id)iSender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject: [NSNumber numberWithBool:[self.includeTax isOn]] forKey:@"shouldIncludeTax"];
    [dict setObject: [NSNumber numberWithBool:[self.includeDeductions isOn]] forKey:@"shouldIncludeDeductions"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tipConfigurationDidChange"
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.minimumTipPercentage.text floatValue] > [self.maxmimumTipPercentage.text floatValue]) {
        [self showAlertWithTitle:@"Minimum Tip" message:@"cannot be greater than Maximum Tip"];
        self.minimumTipPercentage.text = @"0";
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.minimumTipPercentage.text forKey:@"min"];
    [dict setObject:self.maxmimumTipPercentage.text forKey:@"max"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tipPercentageDidChange"
                                                        object:nil
                                                      userInfo:dict];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSCharacterSet *charSet = nil;
    charSet = [[NSCharacterSet characterSetWithCharactersInString: DOUBLE_SET] invertedSet];
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered]) && (newLength <= CHARACTER_LIMIT));
}

@end
