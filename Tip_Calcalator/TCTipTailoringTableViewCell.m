//
//  TableViewCell.m
//  Tip_Calcalator
//
//  Created by Kingfisher on 10/27/14.
//  Copyright (c) 2014 __ASU__. All rights reserved.
//

#import "TCTipTailoringTableViewCell.h"

@implementation TCTipTailoringTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)sliderValueChanged {
    self.amount.text = [NSString stringWithFormat:@"%.2f", [self.slider value] * self.maxTipAmount];
    self.updated = YES;
    if ([self.delegate respondsToSelector:@selector(sliderValueDidChangeForCell:)]) {
        //[self.delegate sliderValueDidChangeForCell:self];
    }
}

- (void)prepareForReuse {
    self.updated = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
