//
//  SmithChartView.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 25.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "SmithChartView.h"
#import "ComplexNumber.h"
#import "PortCharacteristic.h"

@implementation ComplexPoint

- (id)initWithRealPoint:(CGPoint)point {
    if ((self = [super init])) {
        self.realPoint = point;
    }
    return self;
}

- (CGFloat)realX {
    return self.realPoint.x;
}

- (CGFloat)realY {
    return self.realPoint.y;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[ComplexPoint class]] &&
    (int)self.realPoint.x == (int)[object realPoint].x &&
    (int)self.realPoint.y == (int)[object realPoint].y;
}

@end


@implementation SmithChartView {
    CGFloat xffset;
    CGFloat scale;
    
    NSMutableDictionary *_points;
    
    PortCharacteristic *_currentCharacteristic;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (!hidden) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [self.image drawInRect:rect];
    
    [[UIColor redColor] setFill];
    [[UIColor redColor] setStroke];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGPoint p1 = [self convertPoint:CGPointMake(-1.f, 0.f)];
//    CGPoint p2 = [self convertPoint:CGPointMake(1.f, 0.f)];
//    
//    CGContextMoveToPoint(context, p1.x, p1.y);
//    CGContextAddLineToPoint(context, p2.x, p2.y);
//    
//    CGContextStrokePath(context);
//    
//    p1 = [self convertPoint:CGPointMake(0.f, -1.f)];
//    p2 = [self convertPoint:CGPointMake(0.f, 1.f)];
//    
//    CGContextMoveToPoint(context, p1.x, p1.y);
//    CGContextAddLineToPoint(context, p2.x, p2.y);
//    
//    CGContextStrokePath(context);
    
//    NSArray *rs = @[@(0), @(0.5), @(1), @(2)];
////    NSArray *rs = @[@(0.f), @(0.2f), @(0.4f), @(0.6f), @(0.8f), @(1.f), @(2.f), @(3.f), @(4.f)];
//    
//    CGContextSetLineWidth(context, 3.0f);
//    
//    for (NSNumber *rPointer in rs) {
//        CGFloat r = [rPointer floatValue];
//        CGFloat radius = 1.f / (1.f + r);
//        CGFloat center = 1.f - radius;
//        
//        CGContextAddEllipseInRect(context, [self convertRect:CGRectMake(center - radius, radius, radius * 2.f, radius * 2.f)]);
//        CGContextStrokePath(context);
//    }
//
//    NSArray *xs = @[ @(0.2f), @(0.4f), @(0.6f), @(0.8f), @(1.f), @(2.f), @(3.f), @(4.f)];
//    //NSArray *xs = @[@(0.6f)];
//    
//    for (NSNumber *xPointer in xs) {
//        CGFloat x = [xPointer floatValue];
//        CGFloat radius = 1.f / x;
//        CGFloat yCenter = radius;
//        
//        CGContextAddEllipseInRect(context, [self convertRect:CGRectMake(1.f - radius, yCenter + radius, radius * 2.f, radius * 2.f)]);
//        CGContextStrokePath(context);
//    }
    

    _points = [NSMutableDictionary new];
    
    for (PortCharacteristic *ch in [GraphDataSource smithCharacteristicsInArray:_dataSource.characteristics.allValues]) {
        NSMutableArray *points = [NSMutableArray new];
        _points[ch.description] = points;
        
        __block BOOL isFirst = YES;
        [[ch complexNumbers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CGPoint imPoint = [self convertComplexToPoint:obj];
            if ((-1.f <= imPoint.x && imPoint.x <= 1.f) && (-1.f <= imPoint.y && imPoint.y <= 1.f)) {
                CGPoint point = [self convertPoint:imPoint];
                ComplexPoint *pt = [ComplexPoint new];
                pt.realPoint = point;
                pt.complexNumber = obj;
                pt.characteristic = ch;
                pt.freq = ch.freq[idx];
                [points addObject:pt];
                if (isFirst) {
                    isFirst = NO;
                    CGContextMoveToPoint(context, point.x, point.y);
                } else {
                    CGContextAddLineToPoint(context, point.x, point.y);
                }
            } else {
                isFirst = YES;
            }
        }];
        [points sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"realX" ascending:YES]]];
        [ch.lineColor setStroke];
        CGContextSetLineWidth(context, ch.lineWidth);
        CGContextStrokePath(context);
    }
}

- (void)drawPoint:(CGPoint)point {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, [self convertRect:CGRectMake(point.x - 0.025f, point.y + 0.025f, 0.05f, 0.05f)]);
    CGContextFillPath(context);
}

- (CGPoint)convertComplexToViewPoint:(ComplexNumber *)complex {
    return [self convertPoint:[self convertComplexToPoint:complex]];
}

- (CGPoint)convertComplexToPoint:(ComplexNumber *)complex {
    CGFloat radius1 = 1.f / (1.f + (complex.re));
    CGPoint center1 = CGPointMake(1.f - radius1, 0.f);
    
    CGFloat radius2 = 1.f / complex.im;
    CGPoint center2 = CGPointMake(1.f, radius2);
    
    CGFloat d = sqrtf((center2.x - center1.x) * (center2.x - center1.x) + (center2.y - center1.y) * (center2.y - center1.y));
    
    CGFloat b = (radius2 * radius2 - radius1 * radius1 + d * d) / (2.f * d);
    CGFloat a = d - b;
    CGFloat h = sqrtf(radius2 * radius2 - b * b);
    
    CGFloat x = (center1.x + (center2.x - center1.x) / (d / a));
    CGFloat y = (center1.y + (center2.y - center1.y) / (d / a));
    
    CGPoint result1 = CGPointMake(x - (center2.x - center1.x) * h / b, y + (center2.y - center1.y) * h / b);
    
    CGPoint tmp = CGPointMake(center1.x + radius1, center1.y);
    CGFloat dx = tmp.x - x;
    CGFloat dy = tmp.y - y;
    
    result1 = CGPointMake(x - dx, y - dy);
    
    return result1;
}

- (CGRect)convertRect:(CGRect)rect {
    CGRect result = rect;
    result.origin = [self convertPoint:result.origin];
    result.size.width *= scale;
    result.size.height *= scale;
    return result;
}

- (CGPoint)convertPoint:(CGPoint)point {
    CGPoint result = point;
    result.x *= scale;
    result.x += xffset;
    result.y *= scale;
    result.y = self.frame.size.height / 2.f - result.y;
    return result;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (IS_IPAD) {
        xffset = 78.5f;
    } else {
        xffset = 31.f;
    }
    scale = (MIN(self.frame.size.width, self.frame.size.height) - xffset * 2.f) / 2.f;
    xffset += scale;
    
    [self setNeedsDisplay];
}

- (int)findNearIndexInArray:(NSArray *)array forValue:(CGFloat)value {
    __block int result = 0;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (value <= [obj floatValue]) {
            result = idx;
            *stop = YES;
        }
    }];
    return result;
}

- (NSArray *)arrayFromPoints:(NSArray *)points xPart:(BOOL)xPart {
    NSMutableArray *result = [NSMutableArray new];
    [points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGPoint gPoint = [obj realPoint];
        [result addObject:@(xPart ? gPoint.x : gPoint.y)];
    }];
    return result;
}

- (ComplexPoint *)findNearPointForTouchedPoint:(CGPoint)touchedPoint inPoints:(NSArray *)points {
    if (![points count]) {
        return nil;
    }
    
    NSArray *ySortedPoints = [points sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"realY" ascending:YES]]];
    CGPoint point = [self convertPoint:touchedPoint fromView:self.superview];
    
    CGFloat firstX = [points[0] realPoint].x;
    CGFloat lastX = [[points lastObject] realPoint].x;
    CGFloat firstY = [ySortedPoints[0] realPoint].y;
    CGFloat lastY = [[ySortedPoints lastObject] realPoint].y;
    
    if (lastY - firstY > lastX - firstX) {
        if (firstY <= point.y && point.y <= lastY) {
            return ySortedPoints[[self findNearIndexInArray:[self arrayFromPoints:ySortedPoints xPart:NO] forValue:point.y]];
        }
    } else {
        if (firstX <= point.x && point.x <= lastX) {
            return points[[self findNearIndexInArray:[self arrayFromPoints:points xPart:YES] forValue:point.x]];
        }
    }
    return nil;
}

- (void)beginTouch:(CGPoint)point {    
    CGFloat minYDest = CGFLOAT_MAX;
    for (PortCharacteristic *ch in [_points allKeys]) {
        NSArray *points = _points[ch];
        
        ComplexPoint *cPoint = [self findNearPointForTouchedPoint:point inPoints:points];
        CGFloat deltaY = fabsf(point.y - cPoint.realPoint.y);
        if (minYDest > deltaY) {
            minYDest = deltaY;
            _currentCharacteristic = cPoint.characteristic;
        }
    }
}

- (ComplexPoint *)pointForTouchedPoint:(CGPoint)point {
    return [self findNearPointForTouchedPoint:point inPoints:_points[_currentCharacteristic.description]];
}

@end
