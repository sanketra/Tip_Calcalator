//
//  SecondViewController.h
//  Tip_Calcalator
//
//  Created by Kingfisher on 10/27/14.
//  Copyright (c) 2014 __ASU__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCTipTailoringViewController.h"

@interface TCHomeViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *guestCount;
@property (nonatomic, strong) IBOutlet UITextField *billTotal;
@property (nonatomic, strong) IBOutlet UITextField *billDeductions;
@property (nonatomic, strong) IBOutlet UITextField *tax;
@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UILabel *tipRate;
@property (nonatomic, strong) IBOutlet UILabel *totalTip;
@property (nonatomic, strong) IBOutlet UILabel *perPersonTip;
@property (nonatomic, strong) IBOutlet UILabel *total;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@end

