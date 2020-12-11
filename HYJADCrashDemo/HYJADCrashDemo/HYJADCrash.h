//
//  HYJADCrash.h
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/11.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#ifndef HYJADCrash_h
#define HYJADCrash_h


/** 屏幕高度 */
#define ScreenH [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度 */
#define ScreenW [UIScreen mainScreen].bounds.size.width

/** 屏幕适配 */
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

#define HYJScale(value) (IS_PAD?((value)*MIN(ScreenW,ScreenH)/768.0f):((value)*MIN(ScreenW,ScreenH)/375.0f))

#endif /* HYJADCrash_h */
