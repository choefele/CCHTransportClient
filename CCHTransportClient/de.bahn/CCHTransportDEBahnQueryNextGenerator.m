//
//  CCHTransportDEBahnQueryNextGenerator.m
//  Departures
//
//  Created by Claus Höfele on 08.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEBahnQueryNextGenerator.h"

#import "CCHTransportDEBahnClientUtils.h"

static NSString * const MORE_TRIPS_CONTEXT_FORMAT = @"http://reiseauskunft.bahn.de/bin/query.exe/%%@?seqnr=%d&ident=%@%%@&h2g-direct=11&timesel=depart&clientType=ANDROID";

@interface CCHTransportDEBahnQueryNextGenerator()

@property (nonatomic, copy) NSString *context;
@property (nonatomic) BOOL laterTrips;

@end

@implementation CCHTransportDEBahnQueryNextGenerator

- (instancetype)initWithContext:(NSString *)context laterTrips:(BOOL)laterTrips
{
    self = [super init];
    if (self) {
        _context = context;
        _laterTrips = laterTrips;
    }
    
    return self;
}

- (NSURLRequest *)generateRequest
{
    NSString *languageIdentifier = [CCHTransportDEBahnClientUtils languageIdentifier];
    NSString *scrollString = [NSString stringWithFormat:@"&REQ0HafasScrollDir=%@", self.laterTrips ? @"1" : @"2"];
    NSString *urlString = [NSString stringWithFormat:self.context, languageIdentifier, scrollString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    return request;
}

+ (NSString *)generateContextWithRequestID:(NSString *)requestID sequenceNumber:(short)sequenceNumber ld:(NSString *)ld
{
    NSMutableString *context = [NSMutableString stringWithFormat:MORE_TRIPS_CONTEXT_FORMAT, sequenceNumber, requestID];
    if (ld) {
        [context appendFormat:@"&ld=%@", ld];
    }

    return context;
}

@end
