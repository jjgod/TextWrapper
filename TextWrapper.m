//
//  TextWrapper.m
//  TextWrap
//
//  Created by Jiang Jiang on 2/28/10.
//  Copyright 2010 Jjgod Jiang. All rights reserved.
//

#import "TextWrapper.h"

@implementation TextWrapper

#define outputLine(output, line)           [output appendFormat: @"%@\n", line]
#define outputParagraph(output, paragraph) do { \
    [output appendFormat: @"%@\n\n", paragraph]; \
    [paragraph release]; \
    paragraph = nil; \
} while (0)

- (void) outputTo: (NSMutableString *) output from: (NSString *) contents
{
    BOOL inParagraph = NO;
    NSUInteger length = [contents length];
    NSUInteger start = 0, end = 0;
    NSRange range, lineRange;
    NSString *line;
    NSMutableString *paragraph = nil;
    NSCharacterSet *newlineCharset = [NSCharacterSet newlineCharacterSet];
    // NSCharacterSet *linePrefixCharset = [NSCharacterSet characterSetWithCharactersInString: @"　 "];

    for (range = NSMakeRange(0, 0); end < length; range.location = end)
    {
        [contents getLineStart: &start
                           end: &end
                   contentsEnd: NULL
                      forRange: range];
        
        lineRange = NSMakeRange(start, end - start);
        line = [[contents substringWithRange: lineRange] stringByTrimmingCharactersInSet: newlineCharset];

        if (inParagraph)
        {
            if ([line length] == 0) {
                inParagraph = NO;
                outputParagraph(output, paragraph);
            } else
            if ([line hasPrefix: @"＝"] || [line hasPrefix: @"*"])
            {
                outputParagraph(output, paragraph);
                outputLine(output, line);
            }
            else
                [paragraph appendString: line];

        } else {
            if ([line hasPrefix: @"　　"] || [line hasPrefix: @"    "])
            {
                inParagraph = YES;
                paragraph = [[NSMutableString alloc] initWithString: line];
            } else {
                outputLine(output, line);
            }
        }
    }

    if (inParagraph && paragraph && [paragraph length]) {
        outputParagraph(output, paragraph);
    }
}

- (void) wrapText: (NSPasteboard *) pboard
         userData: (NSString *) userData
            error: (NSString **) error
{
    NSArray *types = [pboard types];
    if (! [types containsObject: NSStringPboardType]) 
	{
		if (error != NULL)
		{
			*error = @"Invalid pasteboard type";
		}
        return;
    }

    NSMutableString *wrappedText = [[NSMutableString alloc] init];
    [self outputTo: wrappedText from: [pboard stringForType: NSStringPboardType]];

	[pboard declareTypes: [NSArray arrayWithObject: NSStringPboardType] owner: nil];
	[pboard setString: wrappedText forType: NSStringPboardType];

    [wrappedText release];
}

@end
