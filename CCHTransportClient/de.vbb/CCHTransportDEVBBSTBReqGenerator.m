//
//  CCHTransportDEVBBSTBReqGenerator.m
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

#import "CCHTransportDEVBBSTBReqGenerator.h"

#import "CCHTransportDEVBBClientUtils.h"

@interface CCHTransportDEVBBSTBReqGenerator()

@property (nonatomic, copy) NSString *accessID;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *stationID;
@property (nonatomic) NSUInteger maxNumberOfResults;

@end

@implementation CCHTransportDEVBBSTBReqGenerator

- (instancetype)initWithAccessID:(NSString *)accessID date:(NSDate *)date stationID:(NSString *)stationID maxNumberOfResults:(NSUInteger)maxNumberOfResults
{
    self = [super init];
    if (self) {
        _accessID = accessID;
        _date = date;
        _stationID = stationID;
        _maxNumberOfResults = maxNumberOfResults;
    }
    
    return self;
}

- (NSURLRequest *)generateRequest
{
    NSString *payloadFormat = @"<STBReq boardType='DEP' maxJourneys='%tu'><Time>%@</Time><Period><DateBegin>%@</DateBegin></Period><TableStation externalId='%@' /></STBReq>";
    NSString *timeString = [CCHTransportDEVBBClientUtils timeStringFromDate:self.date];
    NSString *dateString = [CCHTransportDEVBBClientUtils dateStringFromDate:self.date];
    NSString *payLoad = [NSString stringWithFormat:payloadFormat, self.maxNumberOfResults, timeString, dateString, self.stationID];

    return [CCHTransportDEVBBClientUtils URLRequestWithData:payLoad accessID:self.accessID];
}

@end
