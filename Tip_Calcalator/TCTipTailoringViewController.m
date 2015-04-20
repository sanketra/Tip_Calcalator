//
//  FirstViewController.m
//  Tip_Calcalator
//
//  Created by Sanket on 10/27/14.
//  Copyright (c) 2014 __ASU__. All rights reserved.
//

#import "TCTipTailoringViewController.h"
#import "TCTipTailoringTableViewCell.h"
#import "TCHomeViewController.h"

@interface TCTipTailoringViewController ()

@property (nonatomic, assign) NSInteger guestsCount;
@property (nonatomic, assign) float perPersonTip;
@property (nonatomic, assign) float totalTip;
@property (nonatomic, assign) float adjustment;

@end

@implementation TCTipTailoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePerPersonTip:) name:@"updatePerPersonTip" object:nil];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"Tip Tailoring"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:1];
    TCHomeViewController *homeVC = (TCHomeViewController *)[[navController childViewControllers] objectAtIndex:0];
    self.guestsCount = [homeVC.guestCount.text integerValue];
    self.perPersonTip = [homeVC.perPersonTip.text floatValue];
    self.totalTip = [homeVC.totalTip.text floatValue];
}

- (void)updatePerPersonTip:(NSNotification *)iNotification {
    NSDictionary *dictionary = [iNotification userInfo];
    self.guestsCount = [[dictionary objectForKey:@"guestsCount"] integerValue];
    self.perPersonTip = [[dictionary objectForKey:@"perPersonTip"] floatValue];
    self.totalTip = [[dictionary objectForKey:@"totalTip"] floatValue];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.guestsCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCTipTailoringTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuestRowId"];
    
    if (cell == nil) {
        cell = [[TCTipTailoringTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GuestRowId"];
    }
    
    cell.maxTipAmount = self.totalTip;
    cell.slider.value = (self.perPersonTip + self.adjustment) / self.totalTip;
    cell.amount.text = [NSString stringWithFormat:@"%.2f", self.perPersonTip + self.adjustment];
    cell.delegate = self;

    return cell;
}


- (void)sliderValueDidChangeForCell:(TCTipTailoringTableViewCell *)cell {
    self.adjustment = [cell.slider value] * self.totalTip - [cell.amount.text floatValue];
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
