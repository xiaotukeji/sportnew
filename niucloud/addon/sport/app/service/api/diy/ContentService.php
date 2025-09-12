<?php

namespace addon\sport\app\service\api\diy;

use addon\sport\app\model\detail_content\SportEventDetailContent;
use addon\sport\app\model\event\SportEvent;
use core\exception\CommonException;
use think\facade\Filesystem;

/**
 * 内容服务类
 * Class ContentService
 * @package addon\sport\app\service\api\diy
 */
class ContentService
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
     * 获取赛事的详情内容
     * @param int $eventId
     * @return array|null
     * @throws CommonException
     */
    public function getEventDetailContent($eventId)
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        $contentModel = new SportEventDetailContent();
        $content = $contentModel->getEventDetailContent($eventId);

        return $content;
    }

    /**
     * 保存赛事的详情内容
     * @param int $eventId
     * @param string $contentType
     * @param string $contentData
     * @param array $contentImages
     * @return bool
     * @throws CommonException
     */
    public function saveEventDetailContent($eventId, $contentType, $contentData, $contentImages = [])
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        // 验证内容类型
        $this->validateContentType($contentType);

        $contentModel = new SportEventDetailContent();
        $result = $contentModel->saveEventDetailContent($eventId, $contentType, $contentData, $contentImages);

        if (!$result) {
            throw new CommonException('保存详情内容失败');
        }

        return true;
    }

    /**
     * 更新详情内容
     * @param int $contentId
     * @param array $data
     * @return bool
     * @throws CommonException
     */
    public function updateDetailContent($contentId, $data)
    {
        // 验证内容权限
        $this->checkContentPermission($contentId);

        $contentModel = new SportEventDetailContent();
        $result = $contentModel->updateDetailContent($contentId, $data);

        if (!$result) {
            throw new CommonException('更新详情内容失败');
        }

        return true;
    }

    /**
     * 删除赛事的详情内容
     * @param int $eventId
     * @return bool
     * @throws CommonException
     */
    public function deleteEventDetailContent($eventId)
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        $contentModel = new SportEventDetailContent();
        $result = $contentModel->deleteEventDetailContent($eventId);

        if (!$result) {
            throw new CommonException('删除详情内容失败');
        }

        return true;
    }

    /**
     * 上传内容图片
     * @param int $eventId
     * @param array $file
     * @param string $imageTitle
     * @return array
     * @throws CommonException
     */
    public function uploadContentImage($eventId, $file, $imageTitle = '')
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        // 验证文件
        $this->validateImageFile($file);

        try {
            // 上传文件
            $saveName = Filesystem::disk('public')->putFile('sport/content', $file);
            $imageUrl = '/storage/' . $saveName;

            // 保存到数据库
            $contentModel = new SportEventDetailContent();
            $result = $contentModel->addContentImage($eventId, $imageUrl, $imageTitle);

            if (!$result) {
                throw new CommonException('保存内容图片失败');
            }

            return [
                'image_url' => $imageUrl,
                'image_title' => $imageTitle,
                'add_time' => time()
            ];

        } catch (\Exception $e) {
            throw new CommonException('上传内容图片失败: ' . $e->getMessage());
        }
    }

    /**
     * 删除内容图片
     * @param int $eventId
     * @param string $imageUrl
     * @return bool
     * @throws CommonException
     */
    public function removeContentImage($eventId, $imageUrl)
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        $contentModel = new SportEventDetailContent();
        $result = $contentModel->removeContentImage($eventId, $imageUrl);

        if (!$result) {
            throw new CommonException('删除内容图片失败');
        }

        // 删除文件
        $this->deleteImageFile($imageUrl);

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
     * 验证内容权限
     * @param int $contentId
     * @throws CommonException
     */
    private function checkContentPermission($contentId)
    {
        $contentModel = new SportEventDetailContent();
        $content = $contentModel->findOrEmpty($contentId);

        if ($content->isEmpty()) {
            throw new CommonException('内容不存在');
        }

        // 验证赛事权限
        $this->checkEventPermission($content->event_id);
    }

    /**
     * 验证内容类型
     * @param string $contentType
     * @throws CommonException
     */
    private function validateContentType($contentType)
    {
        $allowedTypes = ['rich_text', 'html', 'markdown'];
        if (!in_array($contentType, $allowedTypes)) {
            throw new CommonException('不支持的内容类型');
        }
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
