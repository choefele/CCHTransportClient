//
//  CCHTransportGenerator.h
//  Departures
//
//  Created by Hoefele, Claus on 07.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCHTransportGenerator <NSObject>

- (NSURLRequest *)generateRequest;

@end
