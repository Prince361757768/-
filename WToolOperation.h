//
//  WToolOperation.h
//  YiJiaTong
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WToolOperation : NSObject
+(WToolOperation*)shareTool;

//1.获取磁盘空间大小
+(CGFloat)diskOfAllSizeMbytes;
//2.获取磁盘的可用空间
+ (CGFloat)diskOfFreeSizeMBytes;
//3. 获取指定路径下某个文件的大小
+ (long long)fileSizeAtPath:(NSString *)filePath;
//4. 获取文件夹下所有文件的大小
+ (long long)folderSizeAtPath:(NSString *)folderPath;

//5. 获取字符串(或汉字)首字母

+ (NSString *)firstCharacterWithString:(NSString *)string;

//6.获取当前时间
//format: @"yyyy-MM-dd HH:mm:ss"、@"yyyy年MM月dd日 HH时mm分ss秒"
+ (NSString *)currentDateWithFormat:(NSString *)format;
//7. - 对图片进行滤镜处理
// 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name;


//8.pragma mark - 对图片进行模糊处理
// CIGaussianBlur ---> 高斯模糊
// CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
// CIDiscBlur     ---> 环形卷积模糊(Available in iOS 9.0 and later)
// CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
// CIMotionBlur   ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius;

/**
 * 9. 调整图片饱和度, 亮度, 对比度
 *
 *  @param image      目标图片
 *  @param saturation 饱和度
 *  @param brightness 亮度: -1.0 ~ 1.0
 *  @param contrast   对比度
 *
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast;

//10. 全屏截图

+ (UIImage *)shotScreen;

//11截取view生成一张图片
+ (UIImage *)shotWithView:(UIView *)view;
//12截取view中某个区域生成一张图片
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;
//13.压缩图片到指定尺寸大小
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

// 14.判断字符串中是否含有空格
+ (BOOL)isHaveSpaceInString:(NSString *)string;
//15. 判断字符串中是否含有某个字符串
+ (BOOL)isHaveString:(NSString *)string1 InString:(NSString *)string2;
//16. 判断字符串中是否含有中文
+ (BOOL)isHaveChineseInString:(NSString *)string;

//17. 判断字符串是否全部为数字

+ (BOOL)isAllNum:(NSString *)string;
//18.绘制虚线
/*
 ** lineFrame:     虚线的 frame
 ** length:        虚线中短线的宽度
 ** spacing:       虚线中短线之间的间距
 ** color:         虚线中短线的颜色
 */
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color;

//19.// 手机号码 格式验证
+ (BOOL)isPhoneNumberFormat:(NSString *)phoneNumberString;

@end
