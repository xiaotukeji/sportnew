<?php

namespace addon\sport\app\model\detail_content;

use core\base\BaseModel;

/**
 * 赛事详情内容模型
 * Class SportEventDetailContent
 * @package addon\sport\app\model\detail_content
 */
class SportEventDetailContent extends BaseModel
{
    /**
     * 数据表主键
     * @var string
     */
    protected $pk = 'id';

    /**
     * 模型名称
     * @var string
     */
    protected $name = 'sport_event_detail_content';

    /**
     * 自动时间戳
     * @var bool
     */
    protected $autoWriteTimestamp = true;

    /**
     * 时间戳字段名
     * @var string
     */
    protected $createTime = 'create_time';
    protected $updateTime = 'update_time';

    /**
     * 内容图片获取器
     * @param $value
     * @return array
     */
    public function getContentImagesAttr($value)
    {
        return $value ? json_decode($value, true) : [];
    }

    /**
     * 内容图片修改器
     * @param $value
     * @return string
     */
    public function setContentImagesAttr($value)
    {
        return is_array($value) ? json_encode($value, JSON_UNESCAPED_UNICODE) : $value;
    }

    /**
     * 关联赛事
     * @return \think\model\relation\BelongsTo
     */
    public function event()
    {
        return $this->belongsTo('addon\sport\app\model\event\SportEvent', 'event_id', 'id');
    }

    /**
     * 获取赛事的详情内容
     * @param int $eventId
     * @return array|null
     */
    public function getEventDetailContent($eventId)
    {
        $content = $this->where('event_id', $eventId)
            ->where('status', 1)
            ->find();

        return $content ? $content->toArray() : null;
    }

    /**
     * 保存赛事的详情内容
     * @param int $eventId
     * @param string $contentType
     * @param string $contentData
     * @param array $contentImages
     * @return bool
     */
    public function saveEventDetailContent($eventId, $contentType, $contentData, $contentImages = [])
    {
        $existing = $this->where('event_id', $eventId)->find();
        
        if ($existing) {
            return $existing->save([
                'content_type' => $contentType,
                'content_data' => $contentData,
                'content_images' => $contentImages,
                'update_time' => time()
            ]);
        } else {
            return $this->save([
                'event_id' => $eventId,
                'content_type' => $contentType,
                'content_data' => $contentData,
                'content_images' => $contentImages,
                'status' => 1,
                'create_time' => time(),
                'update_time' => time()
            ]);
        }
    }

    /**
     * 更新详情内容
     * @param int $id
     * @param array $data
     * @return bool
     */
    public function updateDetailContent($id, $data)
    {
        $content = $this->find($id);
        if (!$content) {
            return false;
        }

        $updateData = [];
        if (isset($data['content_type'])) {
            $updateData['content_type'] = $data['content_type'];
        }
        if (isset($data['content_data'])) {
            $updateData['content_data'] = $data['content_data'];
        }
        if (isset($data['content_images'])) {
            $updateData['content_images'] = $data['content_images'];
        }
        if (isset($data['status'])) {
            $updateData['status'] = $data['status'];
        }
        
        $updateData['update_time'] = time();
        
        return $content->save($updateData);
    }

    /**
     * 删除赛事的详情内容
     * @param int $eventId
     * @return bool
     */
    public function deleteEventDetailContent($eventId)
    {
        return $this->where('event_id', $eventId)->delete();
    }

    /**
     * 添加内容图片
     * @param int $eventId
     * @param string $imageUrl
     * @param string $imageTitle
     * @return bool
     */
    public function addContentImage($eventId, $imageUrl, $imageTitle = '')
    {
        $content = $this->where('event_id', $eventId)->find();
        if (!$content) {
            return false;
        }

        $images = $content->content_images ?: [];
        $images[] = [
            'url' => $imageUrl,
            'title' => $imageTitle,
            'add_time' => time()
        ];

        return $content->save([
            'content_images' => $images,
            'update_time' => time()
        ]);
    }

    /**
     * 删除内容图片
     * @param int $eventId
     * @param string $imageUrl
     * @return bool
     */
    public function removeContentImage($eventId, $imageUrl)
    {
        $content = $this->where('event_id', $eventId)->find();
        if (!$content) {
            return false;
        }

        $images = $content->content_images ?: [];
        $images = array_filter($images, function($image) use ($imageUrl) {
            return $image['url'] !== $imageUrl;
        });

        return $content->save([
            'content_images' => array_values($images),
            'update_time' => time()
        ]);
    }
}
