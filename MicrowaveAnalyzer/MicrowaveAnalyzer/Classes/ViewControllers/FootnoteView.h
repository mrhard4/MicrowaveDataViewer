//
//  FootnoteView.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 11.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplexNumber.h"

@interface FootnoteView : UIControl

@property (nonatomic, copy) void(^onCloseButtonTap)(void);
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong, readonly) ComplexNumber *complexNumber;

+ (FootnoteView *)view;

- (void)setGraphPoint:(double *)graphPoint;
- (double *)graphPoint;

- (void)setFrequency:(double)freq complexNumber:(ComplexNumber *)complexNumber frequencyMeasurement:(NSString *)measurement;

@end
