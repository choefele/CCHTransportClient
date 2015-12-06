//
//  CCHTransportDEBahnAjaxGetstopGenerator.m
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

#import "CCHTransportDEBahnAjaxGetstopGenerator.h"

#import "CCHTransportDEBahnClientUtils.h"

static NSString * const API_URL_STATIONS_FORMAT = @"http://reiseauskunft.bahn.de/bin/ajax-getstop.exe/%@?getstop=1&REQ0JourneyStopsB=%tu&REQ0JourneyStopsS0A=1&REQ0JourneyStopsS0G=%@?&js=true";

@interface CCHTransportDEBahnAjaxGetstopGenerator()

@property (nonatomic, copy) NSString *searchString;
@property (nonatomic) NSUInteger maxNumberOfResults;

@end

@implementation CCHTransportDEBahnAjaxGetstopGenerator

- (instancetype)initWithSearchString:(NSString *)searchString maxNumberOfResults:(NSUInteger)maxNumberOfResults
{
    self = [super init];
    if (self) {
        _searchString = searchString;
        _maxNumberOfResults = maxNumberOfResults;
    }
    
    return self;
}

- (NSURLRequest *)generateRequest
{
    NSString *languageIdentifier = [CCHTransportDEBahnClientUtils languageIdentifier];
    NSString *encodedSearchString = [CCHTransportDEBahnClientUtils encodeQueryValue:self.searchString withEncoding:NSISOLatin1StringEncoding];
    NSString *urlString = [NSString stringWithFormat:API_URL_STATIONS_FORMAT, languageIdentifier, self.maxNumberOfResults, encodedSearchString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    return request;
}

@end
