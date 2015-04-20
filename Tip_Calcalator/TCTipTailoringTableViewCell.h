//
//  TableViewCell.h
//  Tip_Calcalator
//
//  Created by Kingfisher on 10/27/14.
//  Copyright (c) 2014 __ASU__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCTipTailoringTableViewCell;

@protocol TCTipTailoringTableViewCellDelegate <NSObject>

- (void)sliderValueDidChangeForCell:(TCTipTailoringTableViewCell *)cell;

@end

@interface TCTipTailoringTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *guestName;
@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UILabel *amount;
@property (nonatomic, assign) float maxTipAmount;
@property (nonatomic, weak) id<TCTipTailoringTableViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL updated;

@end
