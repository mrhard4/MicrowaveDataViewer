//
//  S2PLoader.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 01.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "S2PLoader.h"
#import "S2PParser.h"

@implementation S2PLoader {
    NSString *_documentDirectoryPath;
}

+ (S2PLoader *)sharedInstance {
    static S2PLoader *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        instance = [[[self class] alloc] init];
    } );
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        _documentDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    }
    return self;
}

- (NSString *)pathForFile:(NSString *)file {
    return [_documentDirectoryPath stringByAppendingPathComponent:file];
}

- (NSArray *)listOfFiles {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_documentDirectoryPath error:nil];
}

- (BOOL)removeS2PFile:(NSString *)fileName {
    return [[NSFileManager defaultManager] removeItemAtPath:[self pathForFile:fileName] error:nil];
}

- (NSDictionary *)loadFile:(NSString *)fileName {
#ifdef DEBUG
    NSString *file = [NSString stringWithContentsOfFile:[self pathForFile:fileName]
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    if (!file || [file length] == 0) {
        file = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:nil]
                                         encoding:NSUTF8StringEncoding
                                            error:nil];
    }
    return [S2PParser parse:file];
#else
    return [S2PParser parse:[NSString stringWithContentsOfFile:[self pathForFile:fileName]
                                                      encoding:NSUTF8StringEncoding
                                                         error:nil]];
#endif
}

@end
