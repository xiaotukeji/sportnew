<?php

namespace addon\sport\app\service\api\diy;

use addon\sport\app\model\banner\SportEventBanner;
use addon\sport\app\model\event\SportEvent;
use core\exception\CommonException;
use think\facade\Filesystem;

/**
 * Banner服务类
 * Class BannerService
 * @package addon\sport\app\service\api\diy
 */
class BannerService
{
    /**
     * 当前用户ID
     * @var int
     */
    protected $member_id;

    /**
     * 构造函数
     * @param int $member_id
     */
    public function __construct($member_id = 0)
    {
        $this->member_id = $member_id;
    }

    /**
     * 获取赛事的Banner列表
     * @param int $eventId
     * @return array
     * @throws CommonException
     */
    public function getEventBanners($eventId)
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        $bannerModel = new SportEventBanner();
        $banners = $bannerModel->getEventBanners($eventId);

        return [
            'event_id' => $eventId,
            'banners' => $banners
        ];
    }

    /**
     * 上传Banner图片
     * @param int $eventId
     * @param array $file
     * @param string $imageTitle
     * @param string $imageLink
     * @return array
     * @throws CommonException
     */
    public function uploadBanner($eventId, $file, $imageTitle = '', $imageLink = '')
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        // 验证文件
        $this->validateImageFile($file);

        try {
            // 上传文件
            $saveName = Filesystem::disk('public')->putFile('sport/banner', $file);
            $imageUrl = '/storage/' . $saveName;

            // 保存到数据库
            $bannerModel = new SportEventBanner();
            $result = $bannerModel->addBanner($eventId, $imageUrl, $imageTitle, $imageLink);

            if (!$result) {
                throw new CommonException('保存Banner信息失败');
            }

            return [
                'id' => $bannerModel->id,
                'image_url' => $imageUrl,
                'image_title' => $imageTitle,
                'image_link' => $imageLink,
                'sort' => $bannerModel->sort
            ];

        } catch (\Exception $e) {
            throw new CommonException('上传Banner失败: ' . $e->getMessage());
        }
    }

    /**
     * 更新Banner信息
     * @param int $bannerId
     * @param array $data
     * @return bool
     * @throws CommonException
     */
    public function updateBanner($bannerId, $data)
    {
        // 验证Banner权限
        $this->checkBannerPermission($bannerId);

        $bannerModel = new SportEventBanner();
        $result = $bannerModel->updateBanner($bannerId, $data);

        if (!$result) {
            throw new CommonException('更新Banner信息失败');
        }

        return true;
    }

    /**
     * 删除Banner图片
     * @param int $bannerId
     * @return bool
     * @throws CommonException
     */
    public function deleteBanner($bannerId)
    {
        // 验证Banner权限
        $this->checkBannerPermission($bannerId);

        $bannerModel = new SportEventBanner();
        $banner = $bannerModel->find($bannerId);
        
        if (!$banner) {
            throw new CommonException('Banner不存在');
        }

        // 删除文件
        $this->deleteImageFile($banner->image_url);

        // 删除数据库记录
        $result = $bannerModel->deleteBanner($bannerId);

        if (!$result) {
            throw new CommonException('删除Banner失败');
        }

        return true;
    }

    /**
     * 更新Banner排序
     * @param int $eventId
     * @param array $sortData
     * @return bool
     * @throws CommonException
     */
    public function updateBannerSort($eventId, $sortData)
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        // 验证排序数据
        $this->validateSortData($sortData);

        $bannerModel = new SportEventBanner();
        $result = $bannerModel->updateBannerSort($eventId, $sortData);

        if (!$result) {
            throw new CommonException('更新Banner排序失败');
        }

        return true;
    }

    /**
     * 批量删除赛事的Banner
     * @param int $eventId
     * @return bool
     * @throws CommonException
     */
    public function deleteEventBanners($eventId)
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        $bannerModel = new SportEventBanner();
        $banners = $bannerModel->getEventBanners($eventId);

        // 删除所有图片文件
        foreach ($banners as $banner) {
            $this->deleteImageFile($banner['image_url']);
        }

        // 删除数据库记录
        $result = $bannerModel->deleteEventBanners($eventId);

        if (!$result) {
            throw new CommonException('删除赛事Banner失败');
        }

        return true;
    }

    /**
     * 验证赛事权限
     * @param int $eventId
     * @throws CommonException
     */
    private function checkEventPermission($eventId)
    {
        $eventModel = new SportEvent();
        $event = $eventModel->where('id', $eventId)
            ->where('member_id', $this->member_id)
            ->findOrEmpty();

        if ($event->isEmpty()) {
            throw new CommonException('赛事不存在或无权限操作');
        }
    }

    /**
     * 验证Banner权限
     * @param int $bannerId
     * @throws CommonException
     */
    private function checkBannerPermission($bannerId)
    {
        $bannerModel = new SportEventBanner();
        $banner = $bannerModel->findOrEmpty($bannerId);

        if ($banner->isEmpty()) {
            throw new CommonException('Banner不存在');
        }

        // 验证赛事权限
        $this->checkEventPermission($banner->event_id);
    }

    /**
     * 验证图片文件
     * @param array $file
     * @throws CommonException
     */
    private function validateImageFile($file)
    {
        if (!$file || !isset($file['tmp_name'])) {
            throw new CommonException('请选择要上传的图片');
        }

        // 验证文件类型
        $allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
        if (!in_array($file['type'], $allowedTypes)) {
            throw new CommonException('只支持 JPG、PNG、GIF、WebP 格式的图片');
        }

        // 验证文件大小 (5MB)
        $maxSize = 5 * 1024 * 1024;
        if ($file['size'] > $maxSize) {
            throw new CommonException('图片大小不能超过 5MB');
        }

        // 验证是否为有效图片
        $imageInfo = getimagesize($file['tmp_name']);
        if (!$imageInfo) {
            throw new CommonException('无效的图片文件');
        }
    }

    /**
     * 验证排序数据
     * @param array $sortData
     * @throws CommonException
     */
    private function validateSortData($sortData)
    {
        if (!is_array($sortData)) {
            throw new CommonException('排序数据格式错误');
        }

        foreach ($sortData as $item) {
            if (!isset($item['id']) || !isset($item['sort'])) {
                throw new CommonException('排序数据缺少必需字段');
            }

            if (!is_numeric($item['id']) || !is_numeric($item['sort'])) {
                throw new CommonException('排序数据格式错误');
            }
        }
    }

    /**
     * 删除图片文件
     * @param string $imageUrl
     */
    private function deleteImageFile($imageUrl)
    {
        try {
            if ($imageUrl && strpos($imageUrl, '/storage/') === 0) {
                $filePath = public_path() . $imageUrl;
                if (file_exists($filePath)) {
                    unlink($filePath);
                }
            }
        } catch (\Exception $e) {
            // 忽略删除文件时的错误
        }
    }
}
