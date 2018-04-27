//
//  SGMediaCaptionCustomTextView.h
//  TZImagePickerController
//
//  Created by Aban on 4/27/18.
//  Copyright © 2018 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SGMediaCaptionCustomTextView;

@protocol SGMediaCaptionCustomTextViewProtocol <NSObject>


@end



@interface SGMediaCaptionCustomTextView : UITextView

@property (nonatomic, strong) UIColor* placeHolderTextColor;
@property (nonatomic, strong) NSString* placeHolderText;
@property (nonatomic, strong) UIFont* placeHolderFont;


@property (nonatomic, assign) CGFloat maxHeight;


- (void)setText:(NSString *)text;


@end
