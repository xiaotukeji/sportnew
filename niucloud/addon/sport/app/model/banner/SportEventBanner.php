<?php

namespace addon\sport\app\model\banner;

use core\base\BaseModel;

/**
 * 赛事Banner图片模型
 * Class SportEventBanner
 * @package addon\sport\app\model\banner
 */
class SportEventBanner extends BaseModel
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
    protected $name = 'sport_event_banner';

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
     * 关联赛事
     * @return \think\model\relation\BelongsTo
     */
    public function event()
    {
        return $this->belongsTo('addon\sport\app\model\event\SportEvent', 'event_id', 'id');
    }

    /**
     * 获取赛事的Banner列表
     * @param int $eventId
     * @return array
     */
    public function getEventBanners($eventId)
    {
        return $this->where('event_id', $eventId)
            ->where('status', 1)
            ->order('sort', 'asc')
            ->order('id', 'asc')
            ->select()
            ->toArray();
    }

    /**
     * 添加Banner图片
     * @param int $eventId
     * @param string $imageUrl
     * @param string $imageTitle
     * @param string $imageLink
     * @return bool
     */
    public function addBanner($eventId, $imageUrl, $imageTitle = '', $imageLink = '')
    {
        // 获取当前最大排序值
        $maxSort = $this->where('event_id', $eventId)->max('sort') ?: 0;
        
        return $this->save([
            'event_id' => $eventId,
            'image_url' => $imageUrl,
            'image_title' => $imageTitle,
            'image_link' => $imageLink,
            'sort' => $maxSort + 1,
            'status' => 1,
            'create_time' => time(),
            'update_time' => time()
        ]);
    }

    /**
     * 更新Banner信息
     * @param int $id
     * @param array $data
     * @return bool
     */
    public function updateBanner($id, $data)
    {
        $banner = $this->find($id);
        if (!$banner) {
            return false;
        }

        $updateData = [];
        if (isset($data['image_title'])) {
            $updateData['image_title'] = $data['image_title'];
        }
        if (isset($data['image_link'])) {
            $updateData['image_link'] = $data['image_link'];
        }
        if (isset($data['status'])) {
            $updateData['status'] = $data['status'];
        }
        
        $updateData['update_time'] = time();
        
        return $banner->save($updateData);
    }

    /**
     * 删除Banner图片
     * @param int $id
     * @return bool
     */
    public function deleteBanner($id)
    {
        $banner = $this->find($id);
        if (!$banner) {
            return false;
        }

        return $banner->delete();
    }

    /**
     * 更新Banner排序
     * @param int $eventId
     * @param array $sortData [['id' => 1, 'sort' => 1], ...]
     * @return bool
     */
    public function updateBannerSort($eventId, $sortData)
    {
        try {
            $this->startTrans();
            
            foreach ($sortData as $item) {
                $this->where('id', $item['id'])
                    ->where('event_id', $eventId)
                    ->update([
                        'sort' => $item['sort'],
                        'update_time' => time()
                    ]);
            }
            
            $this->commit();
            return true;
        } catch (\Exception $e) {
            $this->rollback();
            return false;
        }
    }

    /**
     * 批量删除赛事的Banner
     * @param int $eventId
     * @return bool
     */
    public function deleteEventBanners($eventId)
    {
        return $this->where('event_id', $eventId)->delete();
    }
}
