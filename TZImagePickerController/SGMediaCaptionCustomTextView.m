//
//  SGMediaCaptionCustomTextView.m
//  TZImagePickerController
//
//  Created by Aban on 4/27/18.
//  Copyright © 2018 谭真. All rights reserved.
//

#import "SGMediaCaptionCustomTextView.h"

@implementation SGMediaCaptionCustomTextView
{
    CGSize actualEmptySize;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        actualEmptySize = frame.size;
    }
    return self;
}



- (void)setText:(NSString *)text
{
    if (!self.text || [self.text isEqualToString:self.placeHolderText])
    {
        text = self.placeHolderText;
    }
    super.text = text;
    [self adjustFrameWithText];
}

- (void)adjustFrameWithText
{
    if ([super.text isEqualToString:self.placeHolderText])
    {
        // handle placeholder text size;
        self.frame = CGRectMake(self.frame.origin.x, CGRectGetMaxY(self.frame) - actualEmptySize.height, actualEmptySize.width, actualEmptySize.height);
    }
    else
    {
        // handle other texts
        if (self.contentSize.height < self.maxHeight)
        {
            
        }
        self.frame = CGRectMake(self.frame.origin.x, CGRectGetMaxY(self.frame) -self.contentSize.height , self.contentSize.width, self.contentSize.height);
    }
}



@end
