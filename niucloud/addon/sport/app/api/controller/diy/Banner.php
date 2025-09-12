<?php

namespace addon\sport\app\api\controller\diy;

use addon\sport\app\service\api\diy\BannerService;
use core\base\BaseApiController;
use core\exception\CommonException;

/**
 * Banner控制器
 * Class Banner
 * @package addon\sport\app\api\controller\diy
 */
class Banner extends BaseApiController
{
    /**
     * 获取赛事的Banner列表
     * @return \think\Response
     */
    public function getList()
    {
        try {
            $eventId = $this->request->param('event_id', 0, 'intval');
            
            if (!$eventId) {
                return fail('赛事ID不能为空');
            }

            $memberId = $this->request->uid ?? 0;
            $bannerService = new BannerService($memberId);
            $result = $bannerService->getEventBanners($eventId);

            return success($result, '获取Banner列表成功');

        } catch (CommonException $e) {
            return fail($e->getMessage());
        } catch (\Exception $e) {
            return fail('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 上传Banner图片
     * @return \think\Response
     */
    public function upload()
    {
        try {
            $eventId = $this->request->param('event_id', 0, 'intval');
            $imageTitle = $this->request->param('image_title', '', 'trim');
            $imageLink = $this->request->param('image_link', '', 'trim');
            
            if (!$eventId) {
                return fail('赛事ID不能为空');
            }

            $file = $this->request->file('image');
            if (!$file) {
                return $this->error('请选择要上传的图片');
            }

            $memberId = $this->request->uid ?? 0;
            $bannerService = new BannerService($memberId);
            $result = $bannerService->uploadBanner($eventId, $file, $imageTitle, $imageLink);

            return success($result, '上传Banner成功');

        } catch (CommonException $e) {
            return fail($e->getMessage());
        } catch (\Exception $e) {
            return fail('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 更新Banner信息
     * @return \think\Response
     */
    public function update()
    {
        try {
            $data = $this->request->params([
                ['banner_id', 0, 'intval'],
                ['image_title', '', 'trim'],
                ['image_link', '', 'trim'],
                ['status', 1, 'intval']
            ]);

            if (!$data['banner_id']) {
                return $this->error('Banner ID不能为空');
            }

            $memberId = $this->request->uid ?? 0;
            $bannerService = new BannerService($memberId);
            $result = $bannerService->updateBanner($data['banner_id'], $data);

            return success($result, '更新Banner信息成功');

        } catch (CommonException $e) {
            return fail($e->getMessage());
        } catch (\Exception $e) {
            return fail('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 删除Banner图片
     * @return \think\Response
     */
    public function delete()
    {
        try {
            $bannerId = $this->request->param('banner_id', 0, 'intval');
            
            if (!$bannerId) {
                return $this->error('Banner ID不能为空');
            }

            $memberId = $this->request->uid ?? 0;
            $bannerService = new BannerService($memberId);
            $result = $bannerService->deleteBanner($bannerId);

            return success($result, '删除Banner成功');

        } catch (CommonException $e) {
            return fail($e->getMessage());
        } catch (\Exception $e) {
            return fail('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 更新Banner排序
     * @return \think\Response
     */
    public function updateSort()
    {
        try {
            $eventId = $this->request->param('event_id', 0, 'intval');
            $sortData = $this->request->param('sort_data', []);
            
            if (!$eventId) {
                return fail('赛事ID不能为空');
            }

            if (!is_array($sortData) || empty($sortData)) {
                return $this->error('排序数据不能为空');
            }

            $memberId = $this->request->uid ?? 0;
            $bannerService = new BannerService($memberId);
            $result = $bannerService->updateBannerSort($eventId, $sortData);

            return success($result, '更新Banner排序成功');

        } catch (CommonException $e) {
            return fail($e->getMessage());
        } catch (\Exception $e) {
            return fail('系统错误: ' . $e->getMessage());
        }
    }

    /**
     * 批量删除赛事的Banner
     * @return \think\Response
     */
    public function deleteEventBanners()
    {
        try {
            $eventId = $this->request->param('event_id', 0, 'intval');
            
            if (!$eventId) {
                return fail('赛事ID不能为空');
            }

            $memberId = $this->request->uid ?? 0;
            $bannerService = new BannerService($memberId);
            $result = $bannerService->deleteEventBanners($eventId);

            return success($result, '删除赛事Banner成功');

        } catch (CommonException $e) {
            return fail($e->getMessage());
        } catch (\Exception $e) {
            return fail('系统错误: ' . $e->getMessage());
        }
    }
}
