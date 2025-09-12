<?php

namespace addon\sport\app\api\controller\diy;

use addon\sport\app\service\api\diy\ContentService;
use core\base\BaseApiController;
use core\exception\CommonException;

/**
 * 内容控制器
 * Class Content
 * @package addon\sport\app\api\controller\diy
 */
class Content extends BaseApiController
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
                return fail('赛事ID不能为空');
            }

            $contentService = new ContentService();
            $result = $contentService->getEventDetailContent($eventId);

            return success($result, '获取详情内容成功');

        } catch (CommonException $e) {
            return fail($e->getMessage());
        } catch (\Exception $e) {
            return fail('系统错误: ' . $e->getMessage());
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
                return fail('赛事ID不能为空');
            }

            $contentService = new ContentService();
            $result = $contentService->saveEventDetailContent(
                $data['event_id'],
                $data['content_type'],
                $data['content_data'],
                $data['content_images']
            );

            return success($result, '保存详情内容成功');

        } catch (CommonException $e) {
            return fail($e->getMessage());
        } catch (\Exception $e) {
            return fail('系统错误: ' . $e->getMessage());
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
                return fail('内容ID不能为空');
            }

            $contentService = new ContentService();
            $result = $contentService->updateDetailContent($data['content_id'], $data);

            return success($result, '更新详情内容成功');

        } catch (CommonException $e) {
            return fail($e->getMessage());
        } catch (\Exception $e) {
            return fail('系统错误: ' . $e->getMessage());
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
                return fail('赛事ID不能为空');
            }

            $contentService = new ContentService();
            $result = $contentService->deleteEventDetailContent($eventId);

            return success($result, '删除详情内容成功');

        } catch (CommonException $e) {
            return fail($e->getMessage());
        } catch (\Exception $e) {
            return fail('系统错误: ' . $e->getMessage());
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
                return fail('赛事ID不能为空');
            }

            $file = $this->request->file('image');
            if (!$file) {
                return fail('请选择要上传的图片');
            }

            $contentService = new ContentService();
            $result = $contentService->uploadContentImage($eventId, $file, $imageTitle);

            return success($result, '上传内容图片成功');

        } catch (CommonException $e) {
            return fail($e->getMessage());
        } catch (\Exception $e) {
            return fail('系统错误: ' . $e->getMessage());
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
                return fail('赛事ID不能为空');
            }

            if (!$imageUrl) {
                return fail('图片URL不能为空');
            }

            $contentService = new ContentService();
            $result = $contentService->removeContentImage($eventId, $imageUrl);

            return success($result, '删除内容图片成功');

        } catch (CommonException $e) {
            return fail($e->getMessage());
        } catch (\Exception $e) {
            return fail('系统错误: ' . $e->getMessage());
        }
    }
}
