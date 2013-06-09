//
//  WidthCell.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 08.06.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "WidthCell.h"

@implementation WidthCell {
    IBOutlet UISlider *_slider;
    IBOutlet UIView *_previewView;
}

+ (CGFloat)cellHeight {
    return 74.f;
}

- (void)setWidth:(CGFloat)width {
    _width = width;
    _slider.value = width;
    CGPoint center = _previewView.center;
    CGRect frame = _previewView.frame;
    frame.size.height = _width;
    _previewView.frame = frame;
    _previewView.center = center;
}

- (IBAction)onSliderValueChange:(UISlider *)sender {
    self.width = sender.value;
}

@end
