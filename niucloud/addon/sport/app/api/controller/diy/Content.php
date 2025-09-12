<?php

namespace addon\sport\app\api\controller\diy;

use addon\sport\app\service\api\diy\ContentService;
use app\BaseController;
use core\exception\CommonException;

/**
 * 内容控制器
 * Class Content
 * @package addon\sport\app\api\controller\diy
 */
class Content extends BaseController
{
    /**
     * 获取赛事的详情内容
     * @return \think\Response
     */
    public function get()
    {
        try {
            $eventId = $this->request->param('event_id', 0, 'intval');
            
            if (!$eventId) {
                return $this->error('赛事ID不能为空');
            }

            $memberId = $this->request->uid ?? 0;
            $contentService = new ContentService($memberId);
            $result = $contentService->getEventDetailContent($eventId);

            return $this->success($result, '获取详情内容成功');

        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 保存赛事的详情内容
     * @return \think\Response
     */
    public function save()
    {
        try {
            $data = $this->request->params([
                ['event_id', 0, 'intval'],
                ['content_type', 'rich_text', 'trim'],
                ['content_data', '', 'trim'],
                ['content_images', [], 'array']
            ]);

            if (!$data['event_id']) {
                return $this->error('赛事ID不能为空');
            }

            $memberId = $this->request->uid ?? 0;
            $contentService = new ContentService($memberId);
            $result = $contentService->saveEventDetailContent(
                $data['event_id'],
                $data['content_type'],
                $data['content_data'],
                $data['content_images']
            );

            return $this->success($result, '保存详情内容成功');

        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 更新详情内容
     * @return \think\Response
     */
    public function update()
    {
        try {
            $data = $this->request->params([
                ['content_id', 0, 'intval'],
                ['content_type', '', 'trim'],
                ['content_data', '', 'trim'],
                ['content_images', [], 'array'],
                ['status', 1, 'intval']
            ]);

            if (!$data['content_id']) {
                return $this->error('内容ID不能为空');
            }

            $memberId = $this->request->uid ?? 0;
            $contentService = new ContentService($memberId);
            $result = $contentService->updateDetailContent($data['content_id'], $data);

            return $this->success($result, '更新详情内容成功');

        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 删除赛事的详情内容
     * @return \think\Response
     */
    public function delete()
    {
        try {
            $eventId = $this->request->param('event_id', 0, 'intval');
            
            if (!$eventId) {
                return $this->error('赛事ID不能为空');
            }

            $memberId = $this->request->uid ?? 0;
            $contentService = new ContentService($memberId);
            $result = $contentService->deleteEventDetailContent($eventId);

            return $this->success($result, '删除详情内容成功');

        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 上传内容图片
     * @return \think\Response
     */
    public function uploadImage()
    {
        try {
            $eventId = $this->request->param('event_id', 0, 'intval');
            $imageTitle = $this->request->param('image_title', '', 'trim');
            
            if (!$eventId) {
                return $this->error('赛事ID不能为空');
            }

            $file = $this->request->file('image');
            if (!$file) {
                return $this->error('请选择要上传的图片');
            }

            $memberId = $this->request->uid ?? 0;
            $contentService = new ContentService($memberId);
            $result = $contentService->uploadContentImage($eventId, $file, $imageTitle);

            return $this->success($result, '上传内容图片成功');

        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 删除内容图片
     * @return \think\Response
     */
    public function removeImage()
    {
        try {
            $eventId = $this->request->param('event_id', 0, 'intval');
            $imageUrl = $this->request->param('image_url', '', 'trim');
            
            if (!$eventId) {
                return $this->error('赛事ID不能为空');
            }

            if (!$imageUrl) {
                return $this->error('图片URL不能为空');
            }

            $memberId = $this->request->uid ?? 0;
            $contentService = new ContentService($memberId);
            $result = $contentService->removeContentImage($eventId, $imageUrl);

            return $this->success($result, '删除内容图片成功');

        } catch (CommonException $e) {
            return $this->error($e->getMessage());
        } catch (\Exception $e) {
            return $this->error('系统错误: ' . $e->getMessage());
        }
    }
}
