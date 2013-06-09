//
//  ColorCell.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 08.06.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "BaseCell.h"
#import <ColorPopover/ColorViewController.h>

@interface ColorCell : BaseCell <ColorViewControllerDelegate>

@property (nonatomic, strong) UIColor *color;

@end
