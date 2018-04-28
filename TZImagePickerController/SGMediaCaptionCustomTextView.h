//
//  SGMediaCaptionCustomTextView.h
//  TZImagePickerController
//
//  Created by Aban on 4/27/18.
//  Copyright © 2018 Aban. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SGMediaCaptionCustomTextView;

@protocol SGMediaCaptionCustomTextViewProtocol <NSObject>

@optional
- (void)captionTextDidUpdate:(SGMediaCaptionCustomTextView*)captionTextView UpdatedText:(NSString*)updatedText;



@end



@interface SGMediaCaptionCustomTextView : UITextView <UITextViewDelegate>

@property (nonatomic, strong) UIColor* placeHolderTextColor;
@property (nonatomic, strong) NSString* placeHolderText;
@property (nonatomic, strong) UIFont* placeHolderFont;

@property (nonatomic, strong) UIColor* defaultTextColor;
@property (nonatomic, strong) UIFont* defaultTextFont;

@property (nonatomic, weak) id <SGMediaCaptionCustomTextViewProtocol> captionTextViewDelegate;

@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) NSInteger maxTextLength;



- (void)setText:(NSString *)text;


@end
