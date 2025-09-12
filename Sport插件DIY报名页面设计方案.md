# Sport插件DIY报名页面设计方案

## 📋 项目概述

### 设计目标
为Sport插件设计一个DIY模式的用户报名页面，让赛事发布者可以完全自定义报名页面的展示效果，包括模块开关、排序、样式配置等，提供类似商品详情页的灵活性和专业性。

### 核心特性
- 🎨 **DIY设计模式**：拖拽排序 + 模块开关 + 实时预览
- 🖼️ **Banner管理**：支持多图片轮播，可上传、编辑、排序
- 📋 **模块化配置**：基本信息、项目信息、详情内容、报名操作等模块可独立配置
- 👀 **实时预览**：所见即所得的设计体验
- 📱 **响应式设计**：适配各种设备尺寸

## 🗄️ 数据库设计

### 1. 赛事DIY配置表 (sport_event_diy_config)
```sql
CREATE TABLE `sport_event_diy_config` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `event_id` int(11) unsigned NOT NULL COMMENT '赛事ID',
  `config_data` text NOT NULL COMMENT 'DIY配置数据(JSON格式)',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_event_id` (`event_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='赛事DIY配置表';
```

### 2. 赛事Banner图片表 (sport_event_banner)
```sql
CREATE TABLE `sport_event_banner` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '图片ID',
  `event_id` int(11) unsigned NOT NULL COMMENT '赛事ID',
  `image_url` varchar(500) NOT NULL DEFAULT '' COMMENT '图片URL',
  `image_title` varchar(255) NOT NULL DEFAULT '' COMMENT '图片标题',
  `image_link` varchar(500) NOT NULL DEFAULT '' COMMENT '图片链接',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_event_id` (`event_id`),
  KEY `idx_status_sort` (`status`,`sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='赛事Banner图片表';
```

### 3. 赛事详情内容表 (sport_event_detail_content)
```sql
CREATE TABLE `sport_event_detail_content` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '内容ID',
  `event_id` int(11) unsigned NOT NULL COMMENT '赛事ID',
  `content_type` varchar(50) NOT NULL DEFAULT 'rich_text' COMMENT '内容类型：rich_text富文本，html_html，markdown_markdown',
  `content_data` longtext COMMENT '内容数据',
  `content_images` text COMMENT '内容图片(JSON格式)',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_event_id` (`event_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='赛事详情内容表';
```

## 🏗️ 系统架构设计

### 整体架构图
```
┌─────────────────────────────────────────────────────────────┐
│                    DIY报名页面系统架构                        │
├─────────────────────────────────────────────────────────────┤
│  前端层 (uni-app)                                          │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │  DIY设计页面    │  │   报名展示页面   │  │   报名表单页面   │ │
│  │  (create_diy)   │  │  (signup_show)  │  │  (signup_form)  │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  API层 (ThinkPHP)                                          │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │  DIY配置API     │  │   Banner API    │  │   内容管理API   │ │
│  │  (DiyConfig)    │  │   (Banner)      │  │  (Content)      │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  服务层 (Service)                                          │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ DIY配置服务     │  │  Banner服务     │  │   内容服务      │ │
│  │ (DiyConfigSvc)  │  │  (BannerSvc)    │  │  (ContentSvc)   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  数据层 (Model)                                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ DIY配置模型     │  │  Banner模型     │  │   内容模型      │ │
│  │ (DiyConfig)     │  │  (Banner)       │  │  (Content)      │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 📱 页面设计规范

### 1. DIY设计页面 (create_diy.vue)

#### 页面布局
```
┌─────────────────────────────────────────────────────────────┐
│                     DIY设计页面                              │
├─────────────┬─────────────────────────────┬─────────────────┤
│   左侧面板   │         中间预览区           │    右侧属性面板   │
│             │                            │                 │
│  ┌─────────┐ │  ┌─────────────────────────┐ │  ┌─────────────┐ │
│  │模块列表  │ │  │     实时预览区域        │ │  │  属性设置    │ │
│  │         │ │  │                        │ │  │             │ │
│  │• Banner │ │  │  ┌─────────────────┐   │ │  │ 根据选中模块  │ │
│  │• 基本信息│ │  │  │   Banner区域    │   │ │  │ 显示对应属性  │ │
│  │• 项目信息│ │  │  └─────────────────┘   │ │  │             │ │
│  │• 详情内容│ │  │  ┌─────────────────┐   │ │  │ • 样式设置   │ │
│  │• 报名操作│ │  │  │   基本信息模块   │   │ │  │ • 内容配置   │ │
│  │         │ │  │  └─────────────────┘   │ │  │ • 行为设置   │ │
│  │[拖拽排序]│ │  │  ┌─────────────────┐   │ │  │             │ │
│  │[开关控制]│ │  │  │   项目信息模块   │   │ │  └─────────────┘ │
│  └─────────┘ │  │  └─────────────────┘   │ │                 │
│             │  │  ┌─────────────────┐   │ │                 │
│             │  │  │   详情内容模块   │   │ │                 │
│             │  │  └─────────────────┘   │ │                 │
│             │  │  ┌─────────────────┐   │ │                 │
│             │  │  │   报名操作模块   │   │ │                 │
│             │  │  └─────────────────┘   │ │                 │
│             │  └─────────────────────────┘ │                 │
└─────────────┴─────────────────────────────┴─────────────────┘
```

#### 核心功能
- **模块管理**：拖拽排序、开关控制、实时预览
- **Banner编辑**：图片上传、排序、链接设置
- **属性配置**：每个模块的详细配置选项
- **实时预览**：所见即所得的设计体验

### 2. 报名展示页面 (signup_show.vue)

#### 页面结构
```
┌─────────────────────────────────────────────────────────────┐
│                    报名展示页面                              │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                Banner轮播区域                           │ │
│  │         (根据DIY配置显示/隐藏)                          │ │
│  └─────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                基本信息模块                             │ │
│  │  • 赛事名称    • 时间地点    • 主办方信息              │ │
│  │  • 协办方信息  • 系列赛信息  • 项目分类                │ │
│  │  • 年龄分组    • 自定义分组  • 联系方式                │ │
│  └─────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                比赛项目模块                             │ │
│  │  • 项目详情    • 报名费用    • 参赛人数                │ │
│  │  • 年龄限制    • 性别限制    • 其他设置                │ │
│  └─────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                详情内容模块                             │ │
│  │  • 富文本内容  • 图片展示    • 其他媒体                │ │
│  └─────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                报名操作模块                             │ │
│  │  • 报名状态    • 报名时间    • 参赛人数统计            │ │
│  │  • 立即报名按钮                                        │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### 3. 报名表单页面 (signup_form.vue)

#### 页面功能
- **多人报名**：支持一次报名多个参赛者
- **动态表单**：根据signup_fields配置生成表单
- **数据验证**：必填字段验证、格式验证
- **费用计算**：自动计算报名费用
- **提交确认**：报名信息确认和提交

## 🔧 技术实现方案

### 1. 数据结构设计

#### DIY配置数据结构
```typescript
interface DIYConfig {
  modules: {
    banner: {
      enabled: boolean;
      order: number;
      properties: {
        images: string[];
        height: number;
        autoplay: boolean;
        indicator: boolean;
        interval: number;
      };
    };
    basicInfo: {
      enabled: boolean;
      order: number;
      properties: {
        showEventName: boolean;
        showTimeLocation: boolean;
        showOrganizer: boolean;
        showCoOrganizer: boolean;
        showSeries: boolean;
        showCategory: boolean;
        showAgeGroups: boolean;
        showCustomGroups: boolean;
        showContactInfo: boolean;
        layout: 'vertical' | 'horizontal';
        cardStyle: 'default' | 'minimal' | 'highlight';
      };
    };
    projects: {
      enabled: boolean;
      order: number;
      properties: {
        showProjectDetails: boolean;
        showRegistrationFee: boolean;
        showParticipantCount: boolean;
        showAgeGroup: boolean;
        showGenderLimit: boolean;
        showVenue: boolean;
        layout: 'list' | 'grid' | 'card';
        maxDisplay: number;
      };
    };
    detailContent: {
      enabled: boolean;
      order: number;
      properties: {
        content: string;
        showRichText: boolean;
        showImages: boolean;
        maxHeight: number;
        showExpand: boolean;
      };
    };
    signupAction: {
      enabled: boolean;
      order: number;
      properties: {
        showRegistrationStatus: boolean;
        showRegistrationTime: boolean;
        showParticipantCount: boolean;
        buttonText: string;
        buttonStyle: 'primary' | 'secondary' | 'success' | 'warning';
        buttonSize: 'small' | 'medium' | 'large';
        showProgress: boolean;
      };
    };
  };
  global: {
    theme: 'light' | 'dark' | 'auto';
    primaryColor: string;
    backgroundColor: string;
    borderRadius: number;
    spacing: number;
  };
}
```

#### 可用模块配置
```typescript
interface DIYModule {
  key: string;
  name: string;
  icon: string;
  description: string;
  enabled: boolean;
  order: number;
  properties: ModuleProperties;
  preview: string;
}

const availableModules: DIYModule[] = [
  {
    key: 'banner',
    name: 'Banner轮播图',
    icon: '🖼️',
    description: '展示赛事宣传图片，支持多图轮播',
    enabled: true,
    order: 1,
    properties: {
      images: [],
      height: 400,
      autoplay: true,
      indicator: true,
      interval: 3000
    },
    preview: 'banner-preview.png'
  },
  {
    key: 'basicInfo',
    name: '基本信息',
    icon: '📋',
    description: '展示赛事基本信息和组织方信息',
    enabled: true,
    order: 2,
    properties: {
      showEventName: true,
      showTimeLocation: true,
      showOrganizer: true,
      showCoOrganizer: true,
      showSeries: true,
      showCategory: true,
      showAgeGroups: true,
      showCustomGroups: true,
      showContactInfo: true,
      layout: 'vertical',
      cardStyle: 'default'
    },
    preview: 'basic-info-preview.png'
  },
  {
    key: 'projects',
    name: '比赛项目',
    icon: '🏆',
    description: '展示赛事项目和报名信息',
    enabled: true,
    order: 3,
    properties: {
      showProjectDetails: true,
      showRegistrationFee: true,
      showParticipantCount: true,
      showAgeGroup: true,
      showGenderLimit: true,
      showVenue: true,
      layout: 'list',
      maxDisplay: 10
    },
    preview: 'projects-preview.png'
  },
  {
    key: 'detailContent',
    name: '详情内容',
    icon: '📄',
    description: '展示赛事详细说明和规则',
    enabled: true,
    order: 4,
    properties: {
      content: '',
      showRichText: true,
      showImages: true,
      maxHeight: 500,
      showExpand: true
    },
    preview: 'detail-content-preview.png'
  },
  {
    key: 'signupAction',
    name: '报名操作',
    icon: '📝',
    description: '报名状态和操作按钮',
    enabled: true,
    order: 5,
    properties: {
      showRegistrationStatus: true,
      showRegistrationTime: true,
      showParticipantCount: true,
      buttonText: '立即报名',
      buttonStyle: 'primary',
      buttonSize: 'large',
      showProgress: true
    },
    preview: 'signup-action-preview.png'
  }
];
```

### 2. 后端API设计

#### API接口列表
```php
// DIY配置相关API
POST   /sport/diy-config/save          // 保存DIY配置
GET    /sport/diy-config/get           // 获取DIY配置
PUT    /sport/diy-config/update        // 更新DIY配置
DELETE /sport/diy-config/delete        // 删除DIY配置

// Banner相关API
POST   /sport/banner/upload            // 上传Banner图片
GET    /sport/banner/list              // 获取Banner列表
PUT    /sport/banner/update            // 更新Banner信息
DELETE /sport/banner/delete            // 删除Banner图片
PUT    /sport/banner/sort              // 排序Banner图片

// 内容管理API
POST   /sport/content/save             // 保存详情内容
GET    /sport/content/get              // 获取详情内容
PUT    /sport/content/update           // 更新详情内容
POST   /sport/content/upload-image     // 上传内容图片

// 报名展示API
GET    /sport/signup/show              // 获取报名展示页面数据
POST   /sport/signup/submit            // 提交报名信息
GET    /sport/signup/status            // 查询报名状态
```

### 3. 前端组件设计

#### 核心组件列表
```typescript
// DIY设计页面组件
components/
├── DiyDesignPage.vue           // DIY设计主页面
├── ModulePanel.vue             // 左侧模块面板
├── PreviewArea.vue             // 中间预览区域
├── PropertiesPanel.vue         // 右侧属性面板
├── ModuleItem.vue              // 模块项组件
├── BannerEditor.vue            // Banner编辑器
├── BasicInfoEditor.vue         // 基本信息编辑器
├── ProjectsEditor.vue          // 项目信息编辑器
├── ContentEditor.vue           // 内容编辑器
└── SignupActionEditor.vue      // 报名操作编辑器

// 报名展示页面组件
components/
├── SignupShowPage.vue          // 报名展示主页面
├── BannerModule.vue            // Banner模块
├── BasicInfoModule.vue         // 基本信息模块
├── ProjectsModule.vue          // 项目信息模块
├── DetailContentModule.vue     // 详情内容模块
├── SignupActionModule.vue      // 报名操作模块
└── SignupFormPage.vue          // 报名表单页面
```

## 📋 开发计划

### 阶段一：基础架构搭建 (1-2天)
1. **数据库表创建**
   - 执行SQL语句创建三个核心表
   - 验证表结构和索引

2. **后端模型创建**
   - 创建DiyConfig模型
   - 创建Banner模型
   - 创建DetailContent模型

3. **后端服务层**
   - 创建DiyConfigService
   - 创建BannerService
   - 创建ContentService

### 阶段二：后端API开发 (2-3天)
1. **DIY配置API**
   - 实现配置的增删改查
   - 配置数据验证和格式化

2. **Banner管理API**
   - 图片上传功能
   - Banner列表管理
   - 排序和状态控制

3. **内容管理API**
   - 富文本内容保存
   - 图片上传和管理

### 阶段三：前端页面开发 (3-4天)
1. **DIY设计页面**
   - 页面布局和基础功能
   - 模块拖拽和排序
   - 实时预览功能

2. **报名展示页面**
   - 根据配置动态渲染
   - 模块化组件开发
   - 响应式布局适配

3. **报名表单页面**
   - 动态表单生成
   - 多人报名功能
   - 数据验证和提交

### 阶段四：集成和测试 (1-2天)
1. **功能集成**
   - 与赛事创建流程集成
   - 与现有系统对接

2. **测试验证**
   - 功能测试
   - 兼容性测试
   - 性能优化

## 🎯 技术要点

### 1. 拖拽排序实现
```typescript
// 使用sortable.js或自定义拖拽逻辑
import Sortable from 'sortablejs';

const initSortable = () => {
  const el = document.getElementById('modules-list');
  new Sortable(el, {
    animation: 150,
    ghostClass: 'sortable-ghost',
    onEnd: (evt) => {
      // 更新模块顺序
      updateModuleOrder(evt.oldIndex, evt.newIndex);
    }
  });
};
```

### 2. 实时预览实现
```typescript
// 监听配置变化，实时更新预览
const watchConfig = () => {
  watch(diyConfig, (newConfig) => {
    // 更新预览区域
    updatePreview(newConfig);
  }, { deep: true });
};
```

### 3. 图片上传处理
```typescript
// 统一的图片上传处理
const uploadImage = async (file: File) => {
  const formData = new FormData();
  formData.append('image', file);
  formData.append('event_id', eventId.value);
  
  const response = await request.post('/sport/banner/upload', formData);
  return response.data;
};
```

### 4. 配置数据管理
```typescript
// 配置数据的保存和加载
const saveDiyConfig = async () => {
  const configData = {
    modules: diyConfig.value,
    global: globalSettings.value,
    version: '1.0.0'
  };
  
  await request.post('/sport/diy-config/save', {
    event_id: eventId.value,
    config_data: JSON.stringify(configData)
  });
};
```

## 🔍 注意事项

### 1. 数据安全
- 图片上传需要验证文件类型和大小
- 配置数据需要验证JSON格式
- 防止XSS攻击，对富文本内容进行过滤

### 2. 性能优化
- 图片懒加载和压缩
- 配置数据缓存
- 组件按需加载

### 3. 兼容性
- 支持不同设备尺寸
- 兼容不同浏览器
- 向后兼容现有数据

### 4. 用户体验
- 操作反馈及时
- 错误提示友好
- 加载状态显示

## 📚 参考资料

### 1. 技术文档
- [uni-app官方文档](https://uniapp.dcloud.net.cn/)
- [ThinkPHP8官方文档](https://www.kancloud.cn/manual/thinkphp8_0)
- [Element Plus组件库](https://element-plus.org/)

### 2. 设计参考
- 商品详情页DIY模式
- 小程序页面设计规范
- 移动端UI设计最佳实践

### 3. 相关项目
- 商城插件的商品详情页
- 其他插件的DIY功能实现

---

**文档版本**: v1.0  
**创建时间**: 2025-01-11  
**最后更新**: 2025-01-11  
**维护人员**: 开发团队
