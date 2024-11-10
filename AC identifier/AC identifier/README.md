# AC Identifier

AC Identifier 是一个iOS应用程序，用于识别动漫角色(Anime Character)并提供相关信息。

## 功能特点

- 图片输入
  - 支持相机实时拍照
  - 支持从相册选择照片
- 角色识别
  - 使用Llama 3.2模型进行动漫角色识别
  - 高精度的角色特征提取
- 角色信息
  - 展示角色基本信息（名字、作品等）
  - 对接动漫角色数据库API获取详细资料

## 技术架构

- 开发环境
  - iOS 15.0+
  - Swift 5.0
  - Xcode 14.0+

- 核心技术
  - UIKit/SwiftUI - UI框架
  - AVFoundation - 相机功能
  - PhotosUI - 相册访问
  - Llama 3.2 API - 角色识别
  - Anime Characters Database API - 角色信息

## 实现计划

### 第一阶段 - 基础框架搭建
1. 创建项目基础结构
2. 实现相机和相册功能
3. 设计主界面UI

### 第二阶段 - 核心功能开发
1. 集成Llama 3.2 API
2. 实现图片识别功能
3. 对接动漫角色数据库API

### 第三阶段 - 优化完善
1. 优化识别准确度
2. 完善UI/UX体验
3. 性能优化

## 项目结构 