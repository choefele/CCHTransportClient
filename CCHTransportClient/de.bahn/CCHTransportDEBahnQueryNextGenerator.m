//
//  CCHTransportDEBahnQueryNextGenerator.m
//  CCHTransportClient
//
//  Copyright (C) 2015 Claus Höfele
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
