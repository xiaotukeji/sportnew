<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addSportEvent') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="sportEventTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('seriesId')" prop="series_id">
                        <el-input v-model="sportEventTable.searchParam.series_id" :placeholder="t('seriesIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="sportEventTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('eventType')" prop="event_type">
                        <el-input v-model="sportEventTable.searchParam.event_type" :placeholder="t('eventTypePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('year')" prop="year">
                        <el-input v-model="sportEventTable.searchParam.year" :placeholder="t('yearPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('season')" prop="season">
                        <el-input v-model="sportEventTable.searchParam.season" :placeholder="t('seasonPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('startTime')" prop="start_time">
                        <el-input v-model="sportEventTable.searchParam.start_time" :placeholder="t('startTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('endTime')" prop="end_time">
                        <el-input v-model="sportEventTable.searchParam.end_time" :placeholder="t('endTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('location')" prop="location">
                        <el-input v-model="sportEventTable.searchParam.location" :placeholder="t('locationPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('organizerId')" prop="organizer_id">
                        <el-input v-model="sportEventTable.searchParam.organizer_id" :placeholder="t('organizerIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('organizerType')" prop="organizer_type">
                        <el-input v-model="sportEventTable.searchParam.organizer_type" :placeholder="t('organizerTypePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('sort')" prop="sort">
                        <el-input v-model="sportEventTable.searchParam.sort" :placeholder="t('sortPlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="sportEventTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option
                                v-for="(item, index) in statusList"
                                :key="index"
                                :label="item.name"
                                :value="item.value"
                            />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('remark')" prop="remark">
                        <el-input v-model="sportEventTable.searchParam.remark" :placeholder="t('remarkPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-input v-model="sportEventTable.searchParam.create_time" :placeholder="t('createTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('updateTime')" prop="update_time">
                        <el-input v-model="sportEventTable.searchParam.update_time" :placeholder="t('updateTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadSportEventList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="sportEventTable.data" size="large" v-loading="sportEventTable.loading">
                    <template #empty>
                        <span>{{ !sportEventTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="series_id" :label="t('seriesId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="event_type" :label="t('eventType')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="year" :label="t('year')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="season" :label="t('season')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="start_time" :label="t('startTime')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="end_time" :label="t('endTime')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="location" :label="t('location')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="organizer_id" :label="t('organizerId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="organizer_type" :label="t('organizerType')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in statusList">
                                <div v-if="item.value == row.status">{{ item.name }}</div>
                            </div>
                        </template>
                    </el-table-column>
                    
                    <el-table-column prop="remark" :label="t('remark')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="sportEventTable.page" v-model:page-size="sportEventTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="sportEventTable.total"
                        @size-change="loadSportEventList()" @current-change="loadSportEventList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getSportEventList, deleteSportEvent } from '@/addon/sport/api/sport_event'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let sportEventTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "series_id":"",
      "name":"",
      "event_type":"",
      "year":"",
      "season":"",
      "start_time":"",
      "end_time":"",
      "location":"",
      "organizer_id":"",
      "organizer_type":"",
      "sort":"",
      "status":"",
      "remark":"",
      "create_time":"",
      "update_time":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    const statusList = ref([] as any[])
    const statusDictList = async () => {
    statusList.value = await (await useDictionary('status')).data.dictionary
    }
    statusDictList();

/**
 * 获取赛事列表
 */
const loadSportEventList = (page: number = 1) => {
    sportEventTable.loading = true
    sportEventTable.page = page

    getSportEventList({
        page: sportEventTable.page,
        limit: sportEventTable.limit,
         ...sportEventTable.searchParam
    }).then(res => {
        sportEventTable.loading = false
        sportEventTable.data = res.data.data
        sportEventTable.total = res.data.total
    }).catch(() => {
        sportEventTable.loading = false
    })
}
loadSportEventList()

const router = useRouter()

/**
 * 添加赛事
 */
const addEvent = () => {
    router.push('/sport_event/sport_event_edit')
}

/**
 * 编辑赛事
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/sport_event/sport_event_edit?id='+data.id)
}

/**
 * 删除赛事
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('sportEventDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteSportEvent(id).then(() => {
            loadSportEventList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadSportEventList()
}
</script>

<style lang="scss" scoped>
/* 多行超出隐藏 */
.multi-hidden {
		word-break: break-all;
		text-overflow: ellipsis;
		overflow: hidden;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
	}
</style>
