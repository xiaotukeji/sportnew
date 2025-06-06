<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addSportScore') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="sportScoreTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('matchId')" prop="match_id">
                        <el-input v-model="sportScoreTable.searchParam.match_id" :placeholder="t('matchIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('athleteId')" prop="athlete_id">
                        <el-input v-model="sportScoreTable.searchParam.athlete_id" :placeholder="t('athleteIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('teamId')" prop="team_id">
                        <el-input v-model="sportScoreTable.searchParam.team_id" :placeholder="t('teamIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('scoreType')" prop="score_type">
                        <el-input v-model="sportScoreTable.searchParam.score_type" :placeholder="t('scoreTypePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('scoreValue')" prop="score_value">
                        <el-input v-model="sportScoreTable.searchParam.score_value" :placeholder="t('scoreValuePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('unit')" prop="unit">
                        <el-input v-model="sportScoreTable.searchParam.unit" :placeholder="t('unitPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('rank')" prop="rank">
                        <el-input v-model="sportScoreTable.searchParam.rank" :placeholder="t('rankPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('refereeId')" prop="referee_id">
                        <el-input v-model="sportScoreTable.searchParam.referee_id" :placeholder="t('refereeIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('isValid')" prop="is_valid">
                        <el-input v-model="sportScoreTable.searchParam.is_valid" :placeholder="t('isValidPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('sort')" prop="sort">
                        <el-input v-model="sportScoreTable.searchParam.sort" :placeholder="t('sortPlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="sportScoreTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
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
                        <el-input v-model="sportScoreTable.searchParam.remark" :placeholder="t('remarkPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-input v-model="sportScoreTable.searchParam.create_time" :placeholder="t('createTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('updateTime')" prop="update_time">
                        <el-input v-model="sportScoreTable.searchParam.update_time" :placeholder="t('updateTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadSportScoreList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="sportScoreTable.data" size="large" v-loading="sportScoreTable.loading">
                    <template #empty>
                        <span>{{ !sportScoreTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="match_id" :label="t('matchId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="athlete_id" :label="t('athleteId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="team_id" :label="t('teamId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="score_type" :label="t('scoreType')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="score_value" :label="t('scoreValue')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="unit" :label="t('unit')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="rank" :label="t('rank')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="referee_id" :label="t('refereeId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="is_valid" :label="t('isValid')" min-width="120" :show-overflow-tooltip="true"/>
                    
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
                    <el-pagination v-model:current-page="sportScoreTable.page" v-model:page-size="sportScoreTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="sportScoreTable.total"
                        @size-change="loadSportScoreList()" @current-change="loadSportScoreList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getSportScoreList, deleteSportScore } from '@/addon/sport/api/sport_score'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let sportScoreTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "match_id":"",
      "athlete_id":"",
      "team_id":"",
      "score_type":"",
      "score_value":"",
      "unit":"",
      "rank":"",
      "referee_id":"",
      "is_valid":"",
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
 * 获取比赛成绩列表
 */
const loadSportScoreList = (page: number = 1) => {
    sportScoreTable.loading = true
    sportScoreTable.page = page

    getSportScoreList({
        page: sportScoreTable.page,
        limit: sportScoreTable.limit,
         ...sportScoreTable.searchParam
    }).then(res => {
        sportScoreTable.loading = false
        sportScoreTable.data = res.data.data
        sportScoreTable.total = res.data.total
    }).catch(() => {
        sportScoreTable.loading = false
    })
}
loadSportScoreList()

const router = useRouter()

/**
 * 添加比赛成绩
 */
const addEvent = () => {
    router.push('/sport_score/sport_score_edit')
}

/**
 * 编辑比赛成绩
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/sport_score/sport_score_edit?id='+data.id)
}

/**
 * 删除比赛成绩
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('sportScoreDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteSportScore(id).then(() => {
            loadSportScoreList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadSportScoreList()
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
