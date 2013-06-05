//
//  Matrix.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 05.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Matrix : NSObject

@property (nonatomic, readonly) double frequency;
@property (nonatomic, readonly) double *elements;
@property (nonatomic, readonly) int size;

- (id)initWithFrequency:(double)frequency elements:(double *)elements size:(int)size;

- (Matrix *)multiply:(Matrix *)matrix;

- (double)elementForColumn:(int)column row:(int)row;
- (double)elementAtIndex:(int)index;

@end
