//
//  TZPhotoPreviewCell.m
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "TZPhotoPreviewCell.h"
#import "TZAssetModel.h"
#import "UIView+Layout.h"
#import "TZImageManager.h"
#import "TZProgressView.h"
#import "TZImageCropManager.h"
#import "TZImagePickerController.h"

@interface TZPhotoPreviewCell ()
@end

@implementation TZPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.previewView = [[TZPhotoPreviewView alloc] initWithFrame:self.bounds];
        __weak typeof(self) weakSelf = self;
        [self.previewView setSingleTapGestureBlock:^{
            if (weakSelf.singleTapGestureBlock) {
                weakSelf.singleTapGestureBlock();
            }
        }];
        [self.previewView setImageProgressUpdateBlock:^(double progress) {
            if (weakSelf.imageProgressUpdateBlock) {
                weakSelf.imageProgressUpdateBlock(progress);
            }
        }];
        [self addSubview:self.previewView];
    }
    return self;
}

- (void)setModel:(TZAssetModel *)model {
    _model = model;
    _previewView.asset = model.asset;
}

- (void)recoverSubviews {
    [_previewView recoverSubviews];
}

- (void)setAllowCrop:(BOOL)allowCrop {
    _allowCrop = allowCrop;
    _previewView.allowCrop = allowCrop;
}

- (void)setCropRect:(CGRect)cropRect {
    _cropRect = cropRect;
    _previewView.cropRect = cropRect;
}

@end


@implementation SGVideoPreviewCell
{
    AVPlayer *_player;
    UIButton *_playButton;
    UIImage *_cover;
    CALayer* _layer;
    AVPlayerLayer *_playerLayer;
    UIImageView* _imageView;
    UIView *_toolBar;
    UIProgressView *_progress;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
    }
    
    return self;
}

- (void)setModel:(TZAssetModel *)model{
    _model = model;
    [self configMoviePlayer];
    
}

- (void)cleanCell
{
    for (UIView* view in self.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    [_layer removeFromSuperlayer];
    [_playerLayer removeFromSuperlayer];
    [_playButton removeFromSuperview];
    _playerLayer = nil;
    _player = nil;
    
}

- (void)stopVideoPlayer
{
    [self pausePlayerAndShowNaviBar];
}


- (void)configMoviePlayer {
    [[TZImageManager manager] getPhotoWithAsset:_model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        _cover = photo;
        _imageView = [[UIImageView alloc] initWithImage:_cover];
        
        _imageView.frame = CGRectMake(10, 0, self.contentView.frame.size.width - 20, self.contentView.frame.size.height);
        
        _imageView.contentMode =  UIViewContentModeScaleAspectFit;
        
//

        [self.contentView addSubview:_imageView];

        if ([self.contentView.subviews containsObject:_playButton])
        {
            [self.contentView bringSubviewToFront:_playButton];
        }
        
        [self configPlayButton];

    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
//        [[TZImageManager manager] getVideoWithAsset:_model.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                _player = [AVPlayer playerWithPlayerItem:playerItem];
//                _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
//                _playerLayer.frame = self.contentView.bounds;
//                
//                
////
////
////                [self.contentView.layer addSublayer:_playerLayer];
////                
////                [_imageView removeFromSuperview];
////                
////                [self configPlayButton];
////                
////                [self addProgressObserver];
////                
////                //            [self configBottomToolBar];
////                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
//            });
//        }];
//    });

}

- (void)addProgressObserver{
    AVPlayerItem *playerItem = _player.currentItem;
    UIProgressView *progress = _progress;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
        if (current) {
            [progress setProgress:(current/total) animated:YES];
        }
    }];
}

#pragma mark - Click Event

- (void)playButtonClick {
    
    if (!_player)
    {
        [[TZImageManager manager] getVideoWithAsset:_model.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _player = [AVPlayer playerWithPlayerItem:playerItem];
                _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
                _playerLayer.frame = _imageView.frame;
                CMTime currentTime = _player.currentItem.currentTime;
                CMTime durationTime = _player.currentItem.duration;
                
                [_imageView removeFromSuperview];
                
                [self.contentView addSubview:_imageView];
                if (_player.rate == 0.0f) {
                    if (currentTime.value == durationTime.value) [_player.currentItem seekToTime:CMTimeMake(0, 1)];
                    [_player play];
                    [self.contentView.layer addSublayer:_playerLayer];
                    _toolBar.hidden = YES;
                    [_playButton setImage:nil forState:UIControlStateNormal];
                    if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = YES;
                } else {
                    [self pausePlayerAndShowNaviBar];
                }
                
                //
                //
                //                [self.contentView.layer addSublayer:_playerLayer];
                //
                //                [_imageView removeFromSuperview];
                //
                //                [self configPlayButton];
                //
                //                [self addProgressObserver];
                //
                //                //            [self configBottomToolBar];
                                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
            });
        }];
    }
    else
    {

        CMTime currentTime = _player.currentItem.currentTime;
        CMTime durationTime = _player.currentItem.duration;

        if (_player.rate == 0.0f) {
            if (currentTime.value == durationTime.value) [_player.currentItem seekToTime:CMTimeMake(0, 1)];
            [_player play];

            _toolBar.hidden = YES;
            [_playButton setImage:nil forState:UIControlStateNormal];
            if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = YES;
        } else {
            [self pausePlayerAndShowNaviBar];
        }
    }


}

- (void)pausePlayerAndShowNaviBar {
    [_player pause];
    _toolBar.hidden = NO;

    [_playButton setImage:[UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlay.png"] forState:UIControlStateNormal];
    if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = NO;
    _playButton.hidden = NO;
    
    [self.contentView bringSubviewToFront:_playButton];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configPlayButton {
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(0, 64, self.contentView.tz_width, self.contentView.tz_height - 64 - 44);
    [_playButton setImage:[UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlay.png"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlayHL.png"] forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_playButton];
}

@end


@interface TZPhotoPreviewView ()<UIScrollViewDelegate>

@end

@implementation TZPhotoPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(10, 0, self.tz_width - 20, self.tz_height);
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        [self addSubview:_scrollView];
        
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        
        [self configProgressView];
    }
    return self;
}

- (void)configProgressView {
    _progressView = [[TZProgressView alloc] init];
    static CGFloat progressWH = 40;
    CGFloat progressX = (self.tz_width - progressWH) / 2;
    CGFloat progressY = (self.tz_height - progressWH) / 2;
    _progressView.frame = CGRectMake(progressX, progressY, progressWH, progressWH);
    _progressView.hidden = YES;
    [self addSubview:_progressView];
}

- (void)setModel:(TZAssetModel *)model {
    _model = model;
    [_scrollView setZoomScale:1.0 animated:NO];
    if (model.type == TZAssetModelMediaTypePhotoGif) {
        [[TZImageManager manager] getOriginalPhotoDataWithAsset:model.asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
            if (!isDegraded) {
                self.imageView.image = [UIImage sd_tz_animatedGIFWithData:data];
                [self resizeSubviews];
            }
        }];
    } else {
        self.asset = model.asset;
    }
}

- (void)setAsset:(id)asset {
    _asset = asset;
    [[TZImageManager manager] getPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        self.imageView.image = photo;
        [self resizeSubviews];
        _progressView.hidden = YES;
        if (self.imageProgressUpdateBlock) {
            self.imageProgressUpdateBlock(1);
        }
    } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        _progressView.hidden = NO;
        [self bringSubviewToFront:_progressView];
        progress = progress > 0.02 ? progress : 0.02;;
        _progressView.progress = progress;
        if (self.imageProgressUpdateBlock) {
            self.imageProgressUpdateBlock(progress);
        }
    } networkAccessAllowed:YES];
}

- (void)recoverSubviews {
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
}

- (void)resizeSubviews {
    _imageContainerView.tz_origin = CGPointZero;
    _imageContainerView.tz_width = self.scrollView.tz_width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.tz_height / self.scrollView.tz_width) {
        _imageContainerView.tz_height = floor(image.size.height / (image.size.width / self.scrollView.tz_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.tz_width;
        if (height < 1 || isnan(height)) height = self.tz_height;
        height = floor(height);
        _imageContainerView.tz_height = height;
        _imageContainerView.tz_centerY = self.tz_height / 2;
    }
    if (_imageContainerView.tz_height > self.tz_height && _imageContainerView.tz_height - self.tz_height <= 1) {
        _imageContainerView.tz_height = self.tz_height;
    }
    CGFloat contentSizeH = MAX(_imageContainerView.tz_height, self.tz_height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.tz_width, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.tz_height <= self.tz_height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
    
    [self refreshScrollViewContentSize];
}

- (void)setAllowCrop:(BOOL)allowCrop {
    _allowCrop = allowCrop;
    _scrollView.maximumZoomScale = allowCrop ? 4.0 : 2.5;
}

- (void)refreshScrollViewContentSize {
    if (_allowCrop) {
        // 1.7.2 如果允许裁剪,需要让图片的任意部分都能在裁剪框内，于是对_scrollView做了如下处理：
        // 1.让contentSize增大(裁剪框右下角的图片部分)
        CGFloat contentWidthAdd = self.scrollView.tz_width - CGRectGetMaxX(_cropRect);
        CGFloat contentHeightAdd = (MIN(_imageContainerView.tz_height, self.tz_height) - self.cropRect.size.height) / 2;
        CGFloat newSizeW = self.scrollView.contentSize.width + contentWidthAdd;
        CGFloat newSizeH = MAX(self.scrollView.contentSize.height, self.tz_height) + contentHeightAdd;
        _scrollView.contentSize = CGSizeMake(newSizeW, newSizeH);
        _scrollView.alwaysBounceVertical = YES;
        // 2.让scrollView新增滑动区域（裁剪框左上角的图片部分）
        if (contentHeightAdd > 0) {
            _scrollView.contentInset = UIEdgeInsetsMake(contentHeightAdd, _cropRect.origin.x, 0, 0);
        } else {
            _scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [self refreshScrollViewContentSize];
}

#pragma mark - Private

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.tz_width > _scrollView.contentSize.width) ? ((_scrollView.tz_width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.tz_height > _scrollView.contentSize.height) ? ((_scrollView.tz_height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}

@end
