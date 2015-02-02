//
//  CCHTransportDEBahnQueryYParser.h
//  Departures
//
//  Created by Claus Höfele on 19.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportParser.h"

@interface CCHTransportDEBahnQueryYParser : NSObject<CCHTransportParser>

- (NSArray *)parseResponseWithData:(NSData *)data;

@end
