//
//  SGMediaCaptionCustomTextView.m
//  TZImagePickerController
//
//  Created by Aban on 4/27/18.
//  Copyright © 2018 Aban. All rights reserved.
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
        self.delegate = self;
        self.layer.cornerRadius = 4;
    }
    return self;
}

- (void)setDelegate:(id<UITextViewDelegate>)delegate
{
    super.delegate = self;
}



- (void)setText:(NSString *)text
{
    if (!text || [text isEqualToString:self.placeHolderText])
    {
        text = self.placeHolderText;
        self.textColor = self.placeHolderTextColor;
    }
    else
    {
        self.textColor = self.defaultTextColor;
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


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([super.text isEqualToString:self.placeHolderText])
    {
        super.text = nil;
    }
}


@end
