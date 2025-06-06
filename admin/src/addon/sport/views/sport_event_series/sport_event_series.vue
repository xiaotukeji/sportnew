<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addSportEventSeries') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="sportEventSeriesTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="sportEventSeriesTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('organizerId')" prop="organizer_id">
                        <el-input v-model="sportEventSeriesTable.searchParam.organizer_id" :placeholder="t('organizerIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('memberId')" prop="member_id">
                        <el-input v-model="sportEventSeriesTable.searchParam.member_id" :placeholder="t('memberIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('description')" prop="description">
                        <el-input v-model="sportEventSeriesTable.searchParam.description" :placeholder="t('descriptionPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('startYear')" prop="start_year">
                        <el-input v-model="sportEventSeriesTable.searchParam.start_year" :placeholder="t('startYearPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('endYear')" prop="end_year">
                        <el-input v-model="sportEventSeriesTable.searchParam.end_year" :placeholder="t('endYearPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('sort')" prop="sort">
                        <el-input v-model="sportEventSeriesTable.searchParam.sort" :placeholder="t('sortPlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="sportEventSeriesTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
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
                        <el-input v-model="sportEventSeriesTable.searchParam.remark" :placeholder="t('remarkPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-input v-model="sportEventSeriesTable.searchParam.create_time" :placeholder="t('createTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('updateTime')" prop="update_time">
                        <el-input v-model="sportEventSeriesTable.searchParam.update_time" :placeholder="t('updateTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadSportEventSeriesList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="sportEventSeriesTable.data" size="large" v-loading="sportEventSeriesTable.loading">
                    <template #empty>
                        <span>{{ !sportEventSeriesTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="organizer_id" :label="t('organizerId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="member_id" :label="t('memberId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="description" :label="t('description')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="start_year" :label="t('startYear')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="end_year" :label="t('endYear')" min-width="120" :show-overflow-tooltip="true"/>
                    
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
                    <el-pagination v-model:current-page="sportEventSeriesTable.page" v-model:page-size="sportEventSeriesTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="sportEventSeriesTable.total"
                        @size-change="loadSportEventSeriesList()" @current-change="loadSportEventSeriesList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getSportEventSeriesList, deleteSportEventSeries } from '@/addon/sport/api/sport_event_series'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let sportEventSeriesTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "name":"",
      "organizer_id":"",
      "member_id":"",
      "description":"",
      "start_year":"",
      "end_year":"",
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
 * 获取赛事系列列表
 */
const loadSportEventSeriesList = (page: number = 1) => {
    sportEventSeriesTable.loading = true
    sportEventSeriesTable.page = page

    getSportEventSeriesList({
        page: sportEventSeriesTable.page,
        limit: sportEventSeriesTable.limit,
         ...sportEventSeriesTable.searchParam
    }).then(res => {
        sportEventSeriesTable.loading = false
        sportEventSeriesTable.data = res.data.data
        sportEventSeriesTable.total = res.data.total
    }).catch(() => {
        sportEventSeriesTable.loading = false
    })
}
loadSportEventSeriesList()

const router = useRouter()

/**
 * 添加赛事系列
 */
const addEvent = () => {
    router.push('/sport_event_series/sport_event_series_edit')
}

/**
 * 编辑赛事系列
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/sport_event_series/sport_event_series_edit?id='+data.id)
}

/**
 * 删除赛事系列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('sportEventSeriesDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteSportEventSeries(id).then(() => {
            loadSportEventSeriesList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadSportEventSeriesList()
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
