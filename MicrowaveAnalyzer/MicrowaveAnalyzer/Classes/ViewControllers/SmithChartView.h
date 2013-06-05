//
//  SmithChartView.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 25.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphDataSource.h"

@class ComplexNumber, PortCharacteristic;

@interface ComplexPoint : NSObject

@property (nonatomic, strong) ComplexNumber *complexNumber;
@property (nonatomic) CGPoint realPoint;
@property (nonatomic, strong) NSNumber *freq;
@property (nonatomic, strong) PortCharacteristic *characteristic;

- (id)initWithRealPoint:(CGPoint)point;

@end



@interface SmithChartView : UIView

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) GraphDataSource *dataSource;

- (void)beginTouch:(CGPoint)point;
- (ComplexPoint *)pointForTouchedPoint:(CGPoint)point;

- (CGPoint)convertComplexToViewPoint:(ComplexNumber *)complex;

@end
