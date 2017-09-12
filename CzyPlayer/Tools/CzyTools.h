//  CzyTools.h
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


#import <Foundation/Foundation.h>

@interface CzyTools : NSObject

#pragma mark - view
/**带frame的view*/
+ (UIView *)viewWithFrame:(CGRect)frame andBackGroundColor:(UIColor *)backgroundColor;
/**不带frame的view*/
+ (UIView *)viewWithBackGroundColor:(UIColor *)backgroundColor;

#pragma mark - label
/**不带frame的label*/
+ (UILabel *)labelWithTextTitle:(NSString *)textTitle andColor:(UIColor *)textColor andFont:(UIFont *)textFont andTextAlignment:(NSTextAlignment)textAlignment;
/**带frame的label*/
+ (UILabel *)labelWithTextTitle:(NSString *)textTitle andFrame:(CGRect)frame andColor:(UIColor *)textColor andFont:(UIFont *)textFont andTextAlignment:(NSTextAlignment)textAlignment;

#pragma mark - button
/**不带frame的button*/
+ (UIButton *)buttonWithTextTitle:(NSString *)textTitle andColor:(UIColor *)textColor andFont:(UIFont *)textFont;
/**带frame的button*/
+ (UIButton *)buttonWithTextTitle:(NSString *)textTitle andFrame:(CGRect)frame andColor:(UIColor *)textColor andFont:(UIFont *)textFont;
/**带frame设置image的button*/
+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage andSeletedImage:(UIImage *)selectedImage andFrame:(CGRect)frame;
/**不带frame设置image的button*/
+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage andSeletedImage:(UIImage *)selectedImage;
/**带title和image的button*/
+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage andTextTitle:(NSString *)textTitle andtextColor:(UIColor *)textColor andtextFont:(UIFont *)textFont andTitleEdgeInset:(UIEdgeInsets)titleEdgeInset andImageEdgeInset:(UIEdgeInsets)imageEdgeInset;
/**带title和image frame的button*/
+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage andTextTitle:(NSString *)textTitle andtextColor:(UIColor *)textColor andtextFont:(UIFont *)textFont andFrame:(CGRect)frame andTitleEdgeInset:(UIEdgeInsets)titleEdgeInset andImageEdgeInset:(UIEdgeInsets)imageEdgeInset;

@end
