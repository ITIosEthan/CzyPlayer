//  CzyTools.m
//  CzyPlayer
//  Created by macOfEthan on 17/9/12.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//  Github:https://github.com/ITIosEthan
//  简书：http://www.jianshu.com/u/1d52648daace
/**
 *   █████▒█    ██  ▄████▄   ██ ▄█▀   ██████╗ ██╗   ██╗ ██████╗
 * ▓██   ▒ ██  ▓██▒▒██▀ ▀█   ██▄█▒    ██╔══██╗██║   ██║██╔════╝
 * ▒████ ░▓██  ▒██░▒▓█    ▄ ▓███▄░    ██████╔╝██║   ██║██║  ███╗
 * ░▓█▒  ░▓▓█  ░██░▒▓▓▄ ▄██▒▓██ █▄    ██╔══██╗██║   ██║██║   ██║
 * ░▒█░   ▒▒█████▓ ▒ ▓███▀ ░▒██▒ █▄   ██████╔╝╚██████╔╝╚██████╔╝
 *  ▒ ░   ░▒▓▒ ▒ ▒ ░ ░▒ ▒  ░▒ ▒▒ ▓▒   ╚═════╝  ╚═════╝  ╚═════╝
 */


#import "CzyTools.h"

@implementation CzyTools

#pragma mark - View
/**带frame的view*/
+ (UIView *)viewWithFrame:(CGRect)frame andBackGroundColor:(UIColor *)backgroundColor
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    
    return view;
}

/**不带frame的view*/
+ (UIView *)viewWithBackGroundColor:(UIColor *)backgroundColor
{
    UIView *view = [UIView new];
    view.backgroundColor = backgroundColor;
    
    return view;
}

#pragma mark - label
/**不带frame的label*/
+ (UILabel *)labelWithTextTitle:(NSString *)textTitle andColor:(UIColor *)textColor andFont:(UIFont *)textFont andTextAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] init];
    label.font = textFont;
    label.textColor = textColor;
    label.text = textTitle;
    label.textAlignment = textAlignment;
    
    return label;
}

/**带frame的label*/
+ (UILabel *)labelWithTextTitle:(NSString *)textTitle andFrame:(CGRect)frame andColor:(UIColor *)textColor andFont:(UIFont *)textFont andTextAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] init];
    label.font = textFont;
    label.textColor = textColor;
    label.text = textTitle;
    label.frame = frame;
    label.textAlignment = textAlignment;
    
    return label;
}

#pragma mark - button
+ (UIButton *)buttonWithTextTitle:(NSString *)textTitle andColor:(UIColor *)textColor andFont:(UIFont *)textFont
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:textTitle forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = textFont;
    
    
    return button;
}



+ (UIButton *)buttonWithTextTitle:(NSString *)textTitle andFrame:(CGRect)frame andColor:(UIColor *)textColor andFont:(UIFont *)textFont
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:textTitle forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = textFont;
    button.frame = frame;
    
    return button;
}

/**带frame设置image的button*/
+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage andSeletedImage:(UIImage *)selectedImage andFrame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    button.frame = frame;
    
    return button;
}

/**不带frame设置image的button*/
+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage andSeletedImage:(UIImage *)selectedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    
    return button;
}

/**带title和image的button*/
+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage andTextTitle:(NSString *)textTitle andtextColor:(UIColor *)textColor andtextFont:(UIFont *)textFont andTitleEdgeInset:(UIEdgeInsets)titleEdgeInset andImageEdgeInset:(UIEdgeInsets)imageEdgeInset
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:textTitle forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = textFont;
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setTitleEdgeInsets:titleEdgeInset];
    [button setTitleEdgeInsets:imageEdgeInset];
    
    return button;
}

/**带title和image frame的button*/
+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage andTextTitle:(NSString *)textTitle andtextColor:(UIColor *)textColor andtextFont:(UIFont *)textFont andFrame:(CGRect)frame andTitleEdgeInset:(UIEdgeInsets)titleEdgeInset andImageEdgeInset:(UIEdgeInsets)imageEdgeInset
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:textTitle forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = textFont;
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setTitleEdgeInsets:titleEdgeInset];
    [button setTitleEdgeInsets:imageEdgeInset];
    button.frame = frame;
    
    return button;
}

@end
