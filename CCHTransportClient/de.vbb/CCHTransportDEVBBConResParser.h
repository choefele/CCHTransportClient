//
//  CCHTransportDEVBBConResParser.h
//  Departures
//
//  Created by Claus Höfele on 09.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportParser.h"

@interface CCHTransportDEVBBConResParser : NSObject<CCHTransportParser>

- (NSArray *)parseResponseWithData:(NSData *)data;

@end
