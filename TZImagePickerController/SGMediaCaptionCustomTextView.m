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
    CGSize _actualEmptySize;
    BOOL _textWithPlaceHolder;
    
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
        _actualEmptySize = frame.size;
        self.delegate = self;
        self.layer.cornerRadius = 4;
        
    }
    return self;
}

- (void)setDelegate:(id<UITextViewDelegate>)delegate
{
    if (delegate)
    {
        super.delegate = self;
    }
    else
    {
        super.delegate = nil;
    }
    
}



- (void)setText:(NSString *)text
{
    if (!text || [text isEqualToString:self.placeHolderText])
    {
        text = self.placeHolderText;
        self.textColor = self.placeHolderTextColor;
        self.font = self.placeHolderFont;
        _textWithPlaceHolder = YES;
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
    if ([super.text isEqualToString:self.placeHolderText] )
    {
        // handle placeholder text size;
        self.frame = CGRectMake(self.frame.origin.x, CGRectGetMaxY(self.frame) - _actualEmptySize.height, _actualEmptySize.width, _actualEmptySize.height);
    }
    else
    {
        // handle other texts
        if (self.contentSize.height < self.maxHeight)
        {
            
        }
        CGFloat desiredHeight = self.contentSize.height < _actualEmptySize.height ? _actualEmptySize.height : self.contentSize.height;
        if (desiredHeight != self.frame.size.height)
        {
            self.frame = CGRectMake(self.frame.origin.x, CGRectGetMaxY(self.frame) - desiredHeight , self.contentSize.width, desiredHeight);
        }

    }
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([super.text isEqualToString:self.placeHolderText] && _textWithPlaceHolder)
    {
        super.text = nil;
        _textWithPlaceHolder = NO;
        self.textColor = self.defaultTextColor;
        self.font = self.defaultTextFont;
    }
    else
    {
        //pass 
        
    }
}


- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.captionTextViewDelegate respondsToSelector:@selector(captionTextDidUpdate:UpdatedText:)])
    {
        [self.captionTextViewDelegate captionTextDidUpdate:self UpdatedText:self.text];
    }
    [self adjustFrameWithText];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length + text.length >= self.maxTextLength  && ![text isEqualToString:@""] && text )
    {
        return NO;
    }
    return YES;
}


@end
