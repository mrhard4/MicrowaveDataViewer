//
//  FootnoteView.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 11.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "FootnoteView.h"
#import <QuartzCore/QuartzCore.h>

@interface FootnoteView ()

@property (nonatomic, weak) IBOutlet UILabel *xLabel;
@property (nonatomic, weak) IBOutlet UILabel *yLabel;
@property (nonatomic, weak) IBOutlet UIView *dotView;
@property (nonatomic, weak) IBOutlet UIView *labelsBackground;

@end

@implementation FootnoteView {
    CGFloat centerYOffset;
    double *_graphPoint;
    
    BOOL _inSmithMode;
}

+ (FootnoteView *)view {
    NSArray *result = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    for (id object in result) {
        if ([object isKindOfClass:[UIView class]]) {
            return object;
        }
    }
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.labelsBackground.layer.cornerRadius = 10.f;
    self.labelsBackground.layer.borderColor = [[[UIColor blackColor] colorWithAlphaComponent:0.8f] CGColor];
    self.labelsBackground.layer.borderWidth = 2.f;
    centerYOffset = self.frame.size.height / 2.f - self.dotView.center.y;
}

- (void)setCenter:(CGPoint)center {
    center.y += centerYOffset;
    [super setCenter:center];
    [self refresh];
}

static NSNumberFormatter *_labelFormatter;

+ (NSNumberFormatter *)formatter {
    if (!_labelFormatter) {
        _labelFormatter = [NSNumberFormatter new];
        [_labelFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [_labelFormatter setAllowsFloats:YES];
        [_labelFormatter setMaximumFractionDigits:8];
    }
    return _labelFormatter;
}

- (void)setGraphPoint:(double *)graphPoint {
    free(_graphPoint);
    _graphPoint = malloc(sizeof(double) * 2);
    memcpy(_graphPoint, graphPoint, sizeof(double) * 2);
    
    NSNumberFormatter *labelFormatter = [[self class] formatter];
    [labelFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [labelFormatter setAllowsFloats:YES];
    [labelFormatter setMaximumFractionDigits:8];
    
    self.xLabel.text = [NSString stringWithFormat:@"x = %@", [labelFormatter stringFromNumber:@(graphPoint[0])]];
    self.yLabel.text = [NSString stringWithFormat:@"y = %@", [labelFormatter stringFromNumber:@(graphPoint[1])]];
}

- (double *)graphPoint {
    return _graphPoint;
}

- (void)refresh {
    if (!self.superview) {
        return;
    }
    CGRect superViewRect = self.superview.frame;
    CGRect selfRect = self.frame;
    
    if (selfRect.origin.y < 0.f) {
        CGPoint center = self.dotView.center;
        center.y = self.dotView.frame.size.height / 2.f;
        self.dotView.center = center;
        
        center = self.labelsBackground.center;
        center.y = selfRect.size.height - self.labelsBackground.frame.size.height / 2.f;
        self.labelsBackground.center = center;
        
        centerYOffset *= -1;
    } else if (self.frame.origin.y + self.frame.size.height > superViewRect.size.height) {
        CGPoint center = self.dotView.center;
        center.y = selfRect.size.height - self.dotView.frame.size.height / 2.f;
        self.dotView.center = center;
        
        center = self.labelsBackground.center;
        center.y = self.labelsBackground.frame.size.height / 2.f;
        self.labelsBackground.center = center;
        
        centerYOffset *= -1;
    }
}

- (void)setFrequency:(double)freq complexNumber:(ComplexNumber *)complexNumber frequencyMeasurement:(NSString *)measurement {
    if (!_inSmithMode) {
        [self.yLabel removeFromSuperview];
        self.xLabel.frame = self.labelsBackground.bounds;
        self.xLabel.numberOfLines = 0;
    }
    _complexNumber = complexNumber;
    NSNumberFormatter *f = [[self class] formatter];
    self.xLabel.text = [NSString stringWithFormat:@"%@ %@,\nr: %@,\nx: %@", [f stringFromNumber:@(freq)], measurement, [f stringFromNumber:@(complexNumber.re)], [f stringFromNumber:@(complexNumber.im)]];
}

- (IBAction)onCloseButtonTap:(id)sender {
    if (_onCloseButtonTap) {
        _onCloseButtonTap();
    }
}

- (void)dealloc {
    free(_graphPoint);
}

@end
