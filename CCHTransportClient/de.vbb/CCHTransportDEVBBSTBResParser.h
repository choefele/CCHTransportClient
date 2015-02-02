//
//  CCHTransportClientVBBStationBoardParser.h
//  Abfahrt Berlin
//
//  Created by Hoefele, Claus on 26.06.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportParser.h"

@interface CCHTransportDEVBBSTBResParser : NSObject<CCHTransportParser>

- (NSArray *)parseResponseWithData:(NSData *)data;

@end
