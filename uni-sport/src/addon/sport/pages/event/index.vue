<template>
  <view class="event-index">
    <!-- 页面内容 -->
    <view class="content">
      <view class="empty-state">
        <u-icon name="calendar" size="60" color="#c0c4cc"></u-icon>
        <view class="empty-text">赛事列表</view>
        <view class="empty-desc">暂无赛事数据</view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'

// 页面数据
const eventList = ref([])

</script>

<style lang="scss" scoped>
.event-index {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 32rpx;
}

.content {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 60vh;
}

.empty-state {
  text-align: center;
  
  .empty-text {
    font-size: 32rpx;
    color: #606266;
    margin: 24rpx 0 8rpx;
  }
  
  .empty-desc {
    font-size: 24rpx;
    color: #909399;
  }
}
</style> 